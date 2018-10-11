
   CREATE   PROCEDURE presale.stpIUCombinedPresale
   /*----------------------------------------------------------------------------------------
   Created By  : Daniel Folz
   Created On  : Oct 2, 2018
   Description : Combine Manheim and Adesa presale feed into one unified presale table
   EXEC presale.stpIUCombinedPresale
   ------------------------------------------------------------------------------------------
   */
   AS
   BEGIN;
      SET NOCOUNT ON;
      SET XACT_ABORT ON;

      BEGIN TRY;

         -- Get if the session is in transaction state yet or not
         -- Detect if the procedure was called from an active transaction and save that for later use. In the procedure, 
         -- @TranCount = 0 means there was no active transaction and the procedure started one. @TranCount > 0 means 
         -- an active transaction was started before the procedure was called.
         -- No active transaction so begin one
         -- Create a savepoint to be able to roll back only the work done in the procedure if there is an error
         -- use first or last 32 BUT KEEP IT THE SAME NAME FOR THE ROLLBACK BELOW;
         DECLARE @TranCount INTEGER = @@TRANCOUNT;

         IF @TranCount = 0
            BEGIN TRANSACTION;
         ELSE
            SAVE TRANSACTION stpIUCombinedPresale;

         DECLARE @Today DATE = CONVERT(DATE, GETDATE());

         DROP TABLE IF EXISTS #Valuation;
         CREATE TABLE #Valuation
         (
            BuyAuctionHouseTypeID   BIGINT
         ,  AuctionID               VARCHAR(50)
         ,  AuctionName             VARCHAR(200)
         ,  VIN                     VARCHAR(17) NOT NULL
         ,  SaleDate                DATE
         ,  MMRValue                BIGINT
         ,  MMRMID                  VARCHAR(16)
         );

         INSERT #Valuation (BuyAuctionHouseTypeID, AuctionID, AuctionName, VIN, SaleDate, MMRValue, MMRMID)
         SELECT
            t.BuyAuctionHouseTypeID
         ,  t.AuctionID
         ,  t.AuctionName
         ,  t.VIN
         ,  t.SaleDate
         ,  t.AdjustedPricingWholesaleAverage
         ,  t.MID
         FROM
         (      
            SELECT
               ht.BuyAuctionHouseTypeID
            ,  vt.AuctionID
            ,  AuctionName                = lt.AuctionListDescription
            ,  vt.VIN
            ,  vt.SaleDate
            ,  vt.AdjustedPricingWholesaleAverage
            ,  vt.MID
            ,  RowNumber                  = ROW_NUMBER() OVER (PARTITION BY ht.BuyAuctionHouseTypeID, vt.AuctionID, vt.VIN, vt.SaleDate ORDER BY vt.RowLoadedDateTime DESC)

            FROM
                        Decode.valuation.tblManheimValuation vt WITH (NOLOCK)
            LEFT JOIN   dbo.tblBuyAuctionHouseType           ht                ON ht.AuctionHouseKey         = vt.AuctionHouse
            LEFT JOIN   dbo.tblBuyAuctionListType            lt                ON lt.ExternalAuctionID       = vt.AuctionID
            OUTER APPLY
            (
               SELECT
                  AuctionHouse = ISNULL(ht.AuctionHouseKey, vt.AuctionHouse)
            ) a
            WHERE
                  vt.SaleDate    >= @Today
            AND   a.AuctionHouse IN ('Manheim', 'Adesa')
         ) t
         WHERE
            t.RowNumber = 1

         CREATE NONCLUSTERED INDEX IDX_ValuationStage_KeyElements                   ON #Valuation (BuyAuctionHouseTypeID, AuctionID, VIN, SaleDate)
         CREATE NONCLUSTERED INDEX IDX_Valuation_BuyAuctionHouseTypeID_Includes     ON #Valuation (BuyAuctionHouseTypeID)                                   INCLUDE ([AuctionName],[VIN],[SaleDate],[MMRValue],[MMRMID])
         CREATE NONCLUSTERED INDEX IDX_Valuation_House_Name_VIN_Saledate_Includes   ON #Valuation ([BuyAuctionHouseTypeID],[AuctionName],[VIN],[SaleDate])  INCLUDE ([MMRValue],[MMRMID])

         --SELECT * FROM #Valuation

         DROP TABLE IF EXISTS #Presale
         CREATE TABLE #Presale
         (
            PresaleRowLoadedDateTime   DATETIME2(7)   NULL
         ,  BuyAuctionHouseTypeID      BIGINT         NULL
         ,  AuctionID                  VARCHAR(50)    NULL
         ,  AuctionName                VARCHAR(200)   NULL
         ,  AuctionEndDateTime         DATETIME2(3)   NULL
         ,  VIN                        VARCHAR(17)    NOT NULL
         ,  SaleDate                   DATE           NULL
         ,  MMRMID                     VARCHAR(16)    NULL
         ,  MMRValue                   BIGINT         NULL
         ,  Channel                    VARCHAR(50)    NULL
         ,  CRScore                    VARCHAR(10)    NULL
         ,  [Year]                     SMALLINT       NULL
         ,  Make                       VARCHAR(50)    NULL
         ,  Model                      VARCHAR(100)   NULL
         ,  ExteriorColor              VARCHAR(250)   NULL
         ,  Mileage                    INTEGER        NULL
         ,  Engine                     VARCHAR(50)    NULL
         ,  Transmission               VARCHAR(100)   NULL
         ,  Announcements              VARCHAR(4000)  NULL
         ,  VehicleDetailURL           VARCHAR(1000)  NULL        
         ,  CRLink                     VARCHAR(1000)  NULL
         ,  AsIs                       TINYINT        NULL
         ,  LaneNumber                 VARCHAR(50)    NULL
         ,  RunNumber                  VARCHAR(50)    NULL
         ,  Seller                     VARCHAR(200)   NULL
         ,  IsDecommissioned           TINYINT        NULL
         ,  IsDecommissionedDateTime   DATETIME2(7)   NULL
         ,  YearsOld                   AS CAST((YEAR(GETDATE()) - [Year]) AS SMALLINT) 
         )

         --Insert Adesa and Manheim Records if they do not already exist
         INSERT #Presale
         (
            PresaleRowLoadedDateTime
         ,  BuyAuctionHouseTypeID
         ,  AuctionID            
         ,  AuctionName
         ,  AuctionEndDateTime         
         ,  VIN                  
         ,  SaleDate             
         ,  MMRMID              
         ,  MMRValue            
         ,  Channel              
         ,  CRScore              
         ,  [Year]               
         ,  Make                 
         ,  Model                
         ,  ExteriorColor        
         ,  Mileage              
         ,  Engine               
         ,  Transmission         
         ,  Announcements        
         ,  VehicleDetailURL     
         ,  CRLink               
         ,  AsIs                 
         ,  LaneNumber           
         ,  RunNumber   
         ,  Seller               
         ,  IsDecommissioned
         ,  IsDecommissionedDateTime         
         )
         SELECT
            PresaleRowLoadedDateTime   = a.RowLoadTimeStamp
         ,  lt.BuyAuctionHouseTypeID
         ,  f.AuctionID
         ,  f.AuctionName
         ,  a.AuctionEndDateTime
         ,  a.VIN
         ,  f.SaleDate
         ,  v.MMRMID
         ,  v.MMRValue
         ,  f.Channel
         ,  CRScore                    = a.VehicleGrade
         ,  a.[Year]
         ,  a.Make
         ,  a.Model
         ,  ExteriorColor              = a.Color
         ,  Mileage                    = a.Odometer
         ,  a.Engine
         ,  a.Transmission
         ,  Announcements              = a.Announcement
         ,  a.VehicleDetailURL         
         ,  f.CRLink
         ,  AsIs                       = 0
         ,  LaneNumber                 = a.Lane
         ,  RunNumber                  = CAST(a.RunNumber AS VARCHAR(50))
         ,  Seller                     = a.Consignor
         ,  IsDecommissioned           = CASE WHEN f.IsDeleted = 1 THEN 1 ELSE 0 END
         ,  IsDecommissionedDateTime   = CASE WHEN f.IsDeleted = 1 THEN COALESCE(a.RowUpdateTimeStamp, a.RowLoadTimeStamp, SYSDATETIME()) ELSE NULL END
         FROM
                     presale.tblAdesaPreSale    a  WITH (NOLOCK)
         LEFT JOIN   dbo.tblBuyAuctionListType  lt                ON    a.[Location]               = lt.AuctionListKey
                                                                  AND   lt.BuyAuctionHouseTypeID   = 2                           --<---Adesa
         CROSS APPLY 
         (
            SELECT 
               SaleDate    = CAST(a.SaleDate AS DATE)
            ,  AuctionName = COALESCE(a.[Location], 'Unknown')
            ,  Channel     = 'Simulcast'
            ,  CRLink      = (CASE WHEN a.VehicleGrade IS NULL THEN NULL ELSE a.VehicleDetailURL END)
            ,  AuctionID   = lt.ExternalAuctionID
            ,  IsDeleted   = CASE WHEN a.[Status] = 'Removed' THEN 1 ELSE 0 END
         ) f
         LEFT JOIN   #Valuation                 v  ON    a.VIN                               = v.VIN
                                                   AND   f.AuctionName                       = v.AuctionName
                                                   AND   f.SaleDate                          = v.SaleDate
                                                   AND   v.BuyAuctionHouseTypeID             = 2                                 --<---Adesa
         LEFT JOIN   presale.tblCombinedPresale cp ON    a.RowLoadTimeStamp                  = cp.PresaleRowLoadedDateTime
                                                   AND   ISNULL(lt.BuyAuctionHouseTypeID, 0) = ISNULL(cp.BuyAuctionHouseTypeID, 0)
                                                   AND   ISNULL(f.AuctionID, 0)              = ISNULL(cp.AuctionID, 0)
                                                   AND   a.VIN                               = cp.VIN
                                                   AND   
                                                   (     ISNULL(a.SaleDate, '')              = ISNULL(cp.SaleDate, '')
                                                     OR  ISNULL(a.AuctionEndDateTime, '')    = ISNULL(cp.AuctionEndDateTime, '')
                                                   )
                                                   AND   f.Channel                           = cp.Channel
         WHERE
               f.SaleDate           >= @Today
         AND   a.IsLiveBlockVehicle IS NOT NULL
         AND   cp.CombinedPresaleID IS NULL

         UNION ALL

         SELECT
            PresaleRowLoadedDateTime   = m.RowLoadedDateTime
         ,  lt.BuyAuctionHouseTypeID
         ,  m.AuctionID
         ,  f.AuctionName
         ,  AuctionEndDateTime         = m.AuctionEndDate
         ,  m.VIN
         ,  m.SaleDate
         ,  v.MMRMID              
         ,  v.MMRValue   
         ,  Channel                    = 'Simulcast'
         ,  CRScore                    = CAST(m.ConditionGradeNumDecimal AS VARCHAR(10))
         ,  m.[Year]
         ,  m.Make
         ,  m.Model
         ,  m.ExteriorColor
         ,  m.Mileage
         ,  m.Engine
         ,  m.Transmission
         ,  Announcements              = CASE
                                             WHEN ISNULL(m.Comments, '') = ISNULL(m.AuctionComments, '') AND  ISNULL(m.Comments, '') = ISNULL(m.Remarks, '') 
                                             THEN ISNULL(m.Comments, '')
                                             ELSE ISNULL(m.Comments, '') + ' ' + ISNULL(m.AuctionComments, '') + ' ' + ISNULL(m.Remarks, '')
                                          END
         ,  VehicleDetailURL           = m.VdpURL
         ,  CRLink                     = m.EcrURL
         ,  m.AsIs
         ,  f.LaneNumber
         ,  f.RunNumber
         ,  m.Seller
         ,  IsDecommissioned          = CASE WHEN m.IsDeleted = 1 THEN 1 ELSE 0 END
         ,  IsDecommissionedDateTime  = CASE WHEN m.IsDeleted = 1 THEN COALESCE(m.RowUpdatedDateTime, m.RowLoadedDateTime, SYSDATETIME()) ELSE NULL END
         FROM
            presale.tblManheimFeed m WITH (NOLOCK)
         CROSS APPLY 
         (
            SELECT 
               AuctionName = COALESCE(m.AuctionLocation, 'Unknown')
            ,  LaneNumber  = CAST(m.LaneNumber AS VARCHAR(50))
            ,  RunNumber   = CAST(m.RunNumber  AS VARCHAR(50)) 
            WHERE
                  m.Channel      = 'SIMULCAST'
            AND
            (     m.GroupCode    <> 'TRA' 
               OR m.GroupCode    IS NULL
            )
            AND   m.Salvage      =  0
            AND   m.SaleDate     >= @Today
         ) f
         LEFT JOIN   dbo.tblBuyAuctionListType  lt ON    m.AuctionLocation                   = lt.AuctionListKey
                                                   AND   lt.BuyAuctionHouseTypeID            = 1                              --<---Manheim
         LEFT JOIN   #Valuation                 v  ON    m.VIN                               = v.VIN
                                                   AND   f.AuctionName                       = v.AuctionName
                                                   AND   m.SaleDate                          = v.SaleDate
                                                   AND   v.BuyAuctionHouseTypeID             = 1                              --<---Manheim
         LEFT JOIN   presale.tblCombinedPresale cp ON    m.RowLoadedDateTime                 = cp.PresaleRowLoadedDateTime
                                                   AND   ISNULL(lt.BuyAuctionHouseTypeID, 0) = ISNULL(cp.BuyAuctionHouseTypeID, 0)
                                                   AND   ISNULL(m.AuctionID, 0)              = ISNULL(cp.AuctionID, 0)
                                                   AND   m.VIN                               = cp.VIN
                                                   AND   
                                                   (     ISNULL(m.SaleDate, '')              = ISNULL(cp.SaleDate, '')
                                                     OR  ISNULL(m.AuctionEndDate, '')        = ISNULL(cp.AuctionEndDateTime, '')
                                                   )
                                                   AND   m.Channel                           = cp.Channel
         WHERE
            cp.CombinedPresaleID IS NULL

         --Insert records to presale.tblCombinedPresale
         INSERT presale.tblCombinedPresale
         (
            RowUpdatedDateTime
         ,  LastChangedByEmpID
         ,  PresaleRowLoadedDateTime
         ,  BuyAuctionHouseTypeID
         ,  AuctionID
         ,  AuctionName
         ,  AuctionEndDateTime
         ,  VIN
         ,  SaleDate
         ,  MMRMID
         ,  MMRValue
         ,  Channel
         ,  CRScore
         ,  [Year]
         ,  Make
         ,  Model
         ,  ExteriorColor
         ,  Mileage
         ,  Engine
         ,  Transmission
         ,  Announcements
         ,  VehicleDetailURL
         ,  CRLink
         ,  AsIs
         ,  LaneNumber
         ,  RunNumber
         ,  Seller
         ,  IsDecommissioned
         ,  IsDecommissionedDateTime
         ,  YearsOld
         )
         SELECT
            RowUpdatedDateTime         = NULL
         ,  LastChangedByEmpID         = UPPER(REPLACE(SYSTEM_USER, 'COEXIST\', ''))
         ,  p.PresaleRowLoadedDateTime
         ,  p.BuyAuctionHouseTypeID
         ,  p.AuctionID
         ,  p.AuctionName
         ,  p.AuctionEndDateTime
         ,  p.VIN
         ,  p.SaleDate
         ,  p.MMRMID
         ,  p.MMRValue
         ,  p.Channel
         ,  p.CRScore
         ,  p.[Year]
         ,  p.Make
         ,  p.Model
         ,  p.ExteriorColor
         ,  p.Mileage
         ,  p.Engine
         ,  p.Transmission
         ,  p.Announcements
         ,  p.VehicleDetailURL
         ,  p.CRLink
         ,  p.AsIs
         ,  p.LaneNumber
         ,  p.RunNumber
         ,  p.Seller
         ,  p.IsDecommissioned
         ,  p.IsDecommissionedDateTime
         ,  p.YearsOld
         FROM
            #Presale p

         --Update Adesa presale
         UPDATE
            cp
         SET
            cp.RowUpdatedDateTime         = SYSDATETIME()
         ,  cp.LastChangedByEmpID         = UPPER(REPLACE(SYSTEM_USER, 'COEXIST\', ''))
         ,  cp.BuyAuctionHouseTypeID      = lt.BuyAuctionHouseTypeID
         ,  cp.AuctionID                  = f.AuctionID
         ,  cp.AuctionName                = f.AuctionName
         ,  cp.AuctionEndDateTime         = a.AuctionEndDateTime
         ,  cp.VIN                        = a.VIN
         ,  cp.SaleDate                   = f.SaleDate
         ,  cp.MMRMID                     = v.MMRMID
         ,  cp.MMRValue                   = V.MMRValue
         ,  cp.Channel                    = f.Channel
         ,  cp.CRScore                    = a.VehicleGrade
         ,  cp.[Year]                     = a.[Year]
         ,  cp.Make                       = a.Make
         ,  cp.Model                      = a.Model
         ,  cp.ExteriorColor              = a.Color
         ,  cp.Mileage                    = a.Odometer
         ,  cp.engine                     = a.Engine
         ,  cp.Transmission               = a.Transmission
         ,  cp.Announcements              = a.Announcement
         ,  cp.VehicleDetailURL           = a.VehicleDetailURL         
         ,  cp.CRLink                     = f.CRLink
         ,  cp.LaneNumber                 = a.Lane
         ,  cp.RunNumber                  = f.RunNumber
         ,  cp.Seller                     = a.Consignor
         ,  cp.IsDecommissioned           = CASE WHEN f.IsDeleted = 1 THEN 1 ELSE 0 END
         ,  cp.IsDecommissionedDateTime   = CASE WHEN f.IsDeleted = 1 THEN COALESCE(a.RowUpdateTimeStamp, a.RowLoadTimeStamp, SYSDATETIME()) ELSE NULL END
         ,  cp.YearsOld                   = CAST((YEAR(GETDATE()) - a.[Year]) AS SMALLINT) 
         FROM
                     presale.tblAdesaPreSale    a  WITH (NOLOCK)
         LEFT JOIN   dbo.tblBuyAuctionListType  lt                ON    a.[Location]               = lt.AuctionListKey
                                                                  AND   lt.BuyAuctionHouseTypeID   = 2                              --<---Adesa
         CROSS APPLY 
         (
            SELECT 
               SaleDate    = CAST(a.SaleDate AS DATE)
            ,  AuctionName = COALESCE(a.[Location], 'Unknown')
            ,  Channel     = 'Simulcast'
            ,  CRLink      = (CASE WHEN a.VehicleGrade IS NULL THEN NULL ELSE a.VehicleDetailURL END)
            ,  AuctionID   = lt.ExternalAuctionID
            ,  IsDeleted   = CASE WHEN a.[Status] = 'Removed' THEN 1 ELSE 0 END
            ,  RunNumber   = CAST(a.RunNumber AS VARCHAR(50))
         ) f
         LEFT JOIN   #Valuation                 v  ON    a.VIN                               = v.VIN
                                                   AND   f.AuctionName                       = v.AuctionName
                                                   AND   f.SaleDate                          = v.SaleDate
                                                   AND   v.BuyAuctionHouseTypeID             = 2                                    --<---Adesa
         JOIN        presale.tblCombinedPresale cp ON    a.RowLoadTimeStamp                  = cp.PresaleRowLoadedDateTime
                                                   AND   ISNULL(lt.BuyAuctionHouseTypeID, 0) = ISNULL(cp.BuyAuctionHouseTypeID, 0)
                                                   AND   ISNULL(f.AuctionID, 0)              = ISNULL(cp.AuctionID, 0)
                                                   AND   a.VIN                               = cp.VIN
                                                   AND   
                                                   (     ISNULL(a.SaleDate, '')              = ISNULL(cp.SaleDate, '')
                                                     OR  ISNULL(a.AuctionEndDateTime, '')    = ISNULL(cp.AuctionEndDateTime, '')
                                                   )
                                                   AND   f.Channel                           = cp.Channel
         WHERE
               f.SaleDate           >= @Today
         AND   a.IsLiveBlockVehicle IS NOT NULL
         AND   EXISTS
               (  
                  SELECT   cp.BuyAuctionHouseTypeID, cp.AuctionID, cp.AuctionName, cp.AuctionEndDateTime, cp.VIN, cp.SaleDate, cp.MMRMID, cp.MMRValue, cp.Channel, cp.CRScore, cp.[Year], cp.Make
                        ,  cp.Model, cp.ExteriorColor, cp.Mileage, cp.engine, cp.Transmission, cp.Announcements, cp.VehicleDetailURL, cp.CRLink, cp.LaneNumber, cp.RunNumber, cp.Seller
                        ,  cp.IsDecommissioned, cp.IsDecommissionedDateTime

                  EXCEPT
   
                  SELECT   lt.BuyAuctionHouseTypeID, f.AuctionID, f.AuctionName, a.AuctionEndDateTime, a.VIN, f.SaleDate, v.MMRMID, V.MMRValue, f.Channel, a.VehicleGrade, a.[Year], a.Make
                        ,  a.Model, a.Color, a.Odometer, a.Engine, a.Transmission, a.Announcement, a.VehicleDetailURL, f.CRLink, a.Lane, f.RunNumber, a.Consignor
                        ,  CASE WHEN f.IsDeleted = 1 THEN 1 ELSE 0 END, CASE WHEN f.IsDeleted = 1 THEN COALESCE(a.RowUpdateTimeStamp, a.RowLoadTimeStamp, SYSDATETIME()) ELSE NULL END
               )

         --Update Manheim
         UPDATE
            cp
         SET
            cp.RowUpdatedDateTime         = SYSDATETIME()
         ,  cp.LastChangedByEmpID         = UPPER(REPLACE(SYSTEM_USER, 'COEXIST\', ''))
         ,  cp.BuyAuctionHouseTypeID      = lt.BuyAuctionHouseTypeID
         ,  cp.AuctionID                  = m.AuctionID
         ,  cp.AuctionName                = f.AuctionName
         ,  cp.AuctionEndDateTime         = m.AuctionEndDate
         ,  cp.VIN                        = m.VIN
         ,  cp.SaleDate                   = m.SaleDate
         ,  cp.MMRMID                     = v.MMRMID              
         ,  cp.MMRValue                   = v.MMRValue   
         ,  cp.Channel                    = 'Simulcast'
         ,  cp.CRScore                    = f.CRScore
         ,  cp.[Year]                     = m.[Year]
         ,  cp.Make                       = m.Make
         ,  cp.Model                      = m.Model
         ,  cp.ExteriorColor              = m.ExteriorColor
         ,  cp.Mileage                    = m.Mileage
         ,  cp.Engine                     = m.Engine
         ,  cp.Transmission               = m.Transmission
         ,  cp.Announcements              = f.Announcements
         ,  cp.VehicleDetailURL           = m.VdpURL
         ,  cp.CRLink                     = m.EcrURL
         ,  cp.AsIs                       = m.AsIs
         ,  cp.LaneNumber                 = f.LaneNumber
         ,  cp.RunNumber                  = f.RunNumber
         ,  cp.Seller                     = m.Seller
         ,  cp.IsDecommissioned           = CASE WHEN m.IsDeleted = 1 THEN 1 ELSE 0 END
         ,  cp.IsDecommissionedDateTime   = CASE WHEN m.IsDeleted = 1 THEN COALESCE(m.RowUpdatedDateTime, m.RowLoadedDateTime, SYSDATETIME()) ELSE NULL END
         ,  cp.YearsOld                   = CAST((YEAR(GETDATE()) - m.[Year]) AS SMALLINT) 
         FROM
            presale.tblManheimFeed m WITH (NOLOCK)
         CROSS APPLY 
         (
            SELECT 
               AuctionName    = COALESCE(m.AuctionLocation, 'Unknown')
            ,  CRScore        = CAST(m.ConditionGradeNumDecimal AS VARCHAR(10))
            ,  Announcements  = CASE
                                    WHEN ISNULL(m.Comments, '') = ISNULL(m.AuctionComments, '') AND  ISNULL(m.Comments, '') = ISNULL(m.Remarks, '') 
                                    THEN ISNULL(m.Comments, '')
                                    ELSE ISNULL(m.Comments, '') + ' ' + ISNULL(m.AuctionComments, '') + ' ' + ISNULL(m.Remarks, '')
                                 END
            ,  LaneNumber     = CAST(m.LaneNumber AS VARCHAR(50))
            ,  RunNumber      = CAST(m.RunNumber  AS VARCHAR(50))
            WHERE
                  m.Channel      = 'SIMULCAST'
            AND
            (     m.GroupCode    <> 'TRA' 
               OR m.GroupCode    IS NULL
            )
            AND   m.Salvage      =  0
            AND   m.SaleDate     >= @Today
         ) f
         LEFT JOIN   dbo.tblBuyAuctionListType  lt ON    m.AuctionLocation                   = lt.AuctionListKey
                                                   AND   lt.BuyAuctionHouseTypeID            = 1                                       --<---Manheim
         LEFT JOIN   #Valuation                 v  ON    m.VIN                               = v.VIN
                                                   AND   f.AuctionName                       = v.AuctionName
                                                   AND   m.SaleDate                          = v.SaleDate
                                                   AND   v.BuyAuctionHouseTypeID             = 1                                       --<---Manheim
         JOIN        presale.tblCombinedPresale cp ON    m.RowLoadedDateTime                 = cp.PresaleRowLoadedDateTime
                                                   AND   ISNULL(lt.BuyAuctionHouseTypeID, 0) = ISNULL(cp.BuyAuctionHouseTypeID, 0)
                                                   AND   ISNULL(m.AuctionID, 0)              = ISNULL(cp.AuctionID, 0)
                                                   AND   m.VIN                               = cp.VIN
                                                   AND   
                                                   (     ISNULL(m.SaleDate, '')              = ISNULL(cp.SaleDate, '')
                                                     OR  ISNULL(m.AuctionEndDate, '')        = ISNULL(cp.AuctionEndDateTime, '')
                                                   )
                                                   AND   m.Channel                           = cp.Channel
         WHERE EXISTS
               (  
                  SELECT   cp.BuyAuctionHouseTypeID, cp.AuctionID, cp.AuctionName, cp.AuctionEndDateTime, cp.VIN, cp.SaleDate, cp.MMRMID, cp.MMRValue, cp.Channel, cp.CRScore, cp.[Year], cp.Make
                        ,  cp.Model, cp.ExteriorColor, cp.Mileage, cp.engine, cp.Transmission, cp.Announcements, cp.VehicleDetailURL, cp.CRLink, cp.LaneNumber, cp.RunNumber, cp.Seller
                        ,  cp.IsDecommissioned, cp.IsDecommissionedDateTime
                  EXCEPT
   
                  SELECT   lt.BuyAuctionHouseTypeID, m.AuctionID, f.AuctionName, m.AuctionEndDate, m.VIN, m.SaleDate, v.MMRMID, V.MMRValue, m.Channel, f.CRScore, m.[Year], m.Make
                        ,  m.Model, m.ExteriorColor, m.Mileage, m.Engine, m.Transmission, f.Announcements, m.VDPUrl, m.ECRUrl, f.LaneNumber, f.RunNumber, m.Seller
                        ,  CASE WHEN m.IsDeleted = 1 THEN 1 ELSE 0 END, CASE WHEN m.IsDeleted = 1 THEN COALESCE(m.RowUpdatedDateTime, m.RowLoadedDateTime, SYSDATETIME()) ELSE NULL END
               )

         -- @TranCount = 0 means no transaction was started before the procedure was called.
         -- The procedure must commit the transaction it started.
         IF @TranCount = 0
            COMMIT TRANSACTION;
      END TRY
      BEGIN CATCH
         DECLARE 
            @XactState       INTEGER,
            @CurrTranCount   INTEGER;

         -- Get the state of the existing transaction so we can tell what type of rollback needs to occur
         --    If 1, the transaction is committable.  
         --    If -1, the transaction is uncommittable and should   
         --        be rolled back but only if it is a Full roll back.  Rollback for a save point will not work.
         --    XACT_STATE = 0 means that there is no transaction and  
         --        a commit or rollback operation would generate an error. 
         SET @XactState = XACT_STATE();

         -- Get the current transaction count 
         -- It is possible for the @TranCount value to be set, but a transaction to not be opened 
         --    when an error occurs. When this happens, we cannot call the rollback statement as there is no
         --    transaction to rollback. An example of this is when the executing account does not have
         --    permissions to the underlying objects, but does have authorization to execute the procedure.  
         SET @CurrTranCount = @@TRANCOUNT;

         -- @TranCount = 0 means no transaction was started before the procedure was called.
         -- The procedure must rollback the transaction it started.
         -- If the state of the transaction is stable, then rollback just the current save point work
         IF @TranCount = 0 AND @CurrTranCount > 0 AND @XactState <> 0
            ROLLBACK TRANSACTION;
         ELSE
            IF @TranCount > 0 AND @CurrTranCount > 0 AND @XactState = 1
               ROLLBACK TRANSACTION stpIUCombinedPresale;

         -- Use THROW inside the CATCH block to return error
         -- information about the original error that caused
         -- execution to jump to the CATCH block.
         -- must be 16 for Informatica to pick it up
         THROW;

         -- Return a negative number so that if the calling code is using a LINK server, it will
         -- be able to test that the procedure failed.  Without this, there are some lower type of 
         -- errors that do not show up across the LINK as an error.  This causes ProcessControl 
         -- in particular to not see that the procedure failed which is bad.
         RETURN -1;

      END CATCH;
   END;

