   
   CREATE   PROCEDURE presale.stpIUAuctionEdgeFeed
   (
      @typAuctionEdgeIUParam presale.typAuctionEdgeFeed READONLY
   )
   /*---------------------------------------------------------------------------------------------
   Created By  : Daniel Folz
   Created On  : Aug 8th 2018
   Application : Called by Auction Edge Feed Reader Applicationr
   Description : Insert or Update records into presale.tblAuctionEdgeFeed
   -----------------------------------------------------------------------------------------------
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
            SAVE TRANSACTION stpIUAuctionEdgeFeed;

         --Put the passed-in parameter type table into a local type table
         DECLARE @typAuctionEdgeIU presale.typAuctionEdgeFeed;

         INSERT @typAuctionEdgeIU
         SELECT
            VIN
         ,  AuctionID
         ,  SaleDate
         ,  IsDeleted
         ,  UVC
         ,  [URL]
         ,  ExternalStockNumber
         ,  BidOnline
         ,  CreatedAtDateTimeUTC
         ,  UpdatedAtDateTimeUTC
         ,  OdometerReading
         ,  TitleState
         ,  BookValue
         ,  CheckInAtDateTimeUTC
         ,  GlobalConsignorKey
         ,  GlobalConsignorName
         ,  OdometerStatus
         ,  BuyNowExpiresAtDateTimeUTC
         ,  BuyNowPrice
         ,  OdometerComment
         ,  MSRP
         ,  AuctionSaleDayID
         ,  ConsignmentDateTimeUTC
         ,  RunNumber
         ,  LaneName
         ,  LaneTitle
         ,  PhysicalLaneName
         ,  Announcements
         ,  Certifications
         ,  [Year]
         ,  Make
         ,  Model
         ,  Series
         ,  MakeModelSeries
         ,  BodyStyle
         ,  OriginalBodyStyle
         ,  ExteriorColor
         ,  InteriorColor
         ,  InteriorMaterial
         ,  EngineSize
         ,  Cylinders
         ,  DriveType
         ,  FuelType
         ,  TransmissionType
         ,  DoorConfiguration
         ,  OptionJSON
         ,  SaleLightsJSON
         ,  ImageURLJSON
         ,  TireJSON
         ,  ConditionReportItemJSON
         ,  ConditionReportCreatedAtDateUTC
         ,  Author
         ,  Grade
         ,  FrameDamage
         ,  Drivable
         ,  OriginalPaint
         ,  AutoGrade
         FROM
            @typAuctionEdgeIUParam; 

         --Determine the DriveTimeListingID and prep to determine if the record exists or not in presale.tblManheimFeed
         --There already is a unique index on the AuctionID/SaleDate/VIN field in @typAuctionEdgeIU, 
         --we do not need to be concerned about duplicates
         DECLARE @DriveTimeListing TABLE 
         (
            VIN                  VARCHAR(17) NOT NULL
         ,  AuctionID            VARCHAR(10) NOT NULL
         ,  SaleDate             DATE        NOT NULL
         ,  DriveTimeListingID   AS UPPER(CAST(AuctionID + CONVERT(VARCHAR(10), SaleDate, 112) + VIN AS VARCHAR(35)))  --<---computed column derives the Unique DriveTimeListingID
         ,  DoesRecordExist      BIT         NOT NULL
         );

         INSERT @DriveTimeListing (VIN, AuctionID, SaleDate, DoesRecordExist)
         SELECT
            a.VIN
         ,  a.AuctionID
         ,  a.SaleDate
         ,  DoesRecordExist = 0  --<--- Set the default to be an insert, the code will determine if it is an update later
         FROM
            @typAuctionEdgeIU a;

         --Determine which listings exist and need updating instead of being a new insert
         UPDATE
            l
         SET
            DoesRecordExist = 1
         FROM
               presale.tblAuctionEdgeFeed f 
         JOIN  @DriveTimeListing          l ON     f.VIN = l.VIN
                                             AND   f.AuctionID = l.AuctionID
                                             AND   f.SaleDate = l.SaleDate

         --Insert those records determined to be new
         INSERT presale.tblAuctionEdgeFeed
         (
            DriveTimeListingID
         ,  RowLoadedDateTime
         ,  RowUpdatedDateTime
         ,  VIN
         ,  AuctionID
         ,  SaleDate
         ,  IsDeleted
         ,  UVC
         ,  [URL]
         ,  ExternalStockNumber
         ,  BidOnline
         ,  CreatedAtDateTimeUTC
         ,  UpdatedAtDateTimeUTC
         ,  OdometerReading
         ,  TitleState
         ,  BookValue
         ,  CheckInAtDateTimeUTC
         ,  GlobalConsignorKey
         ,  GlobalConsignorName
         ,  OdometerStatus
         ,  BuyNowExpiresAtDateTimeUTC
         ,  BuyNowPrice
         ,  OdometerComment
         ,  MSRP
         ,  AuctionSaleDayID
         ,  ConsignmentDateTimeUTC
         ,  RunNumber
         ,  LaneName
         ,  LaneTitle
         ,  PhysicalLaneName
         ,  Announcements
         ,  Certifications
         ,  [Year]
         ,  Make
         ,  Model
         ,  Series
         ,  MakeModelSeries
         ,  BodyStyle
         ,  OriginalBodyStyle
         ,  ExteriorColor
         ,  InteriorColor
         ,  InteriorMaterial
         ,  EngineSize
         ,  Cylinders
         ,  DriveType
         ,  FuelType
         ,  TransmissionType
         ,  DoorConfiguration
         ,  OptionJSON
         ,  SaleLightsJSON
         ,  ImageURLJSON
         ,  TireJSON
         ,  ConditionReportItemJSON
         ,  ConditionReportCreatedAtDateUTC
         ,  Author
         ,  Grade
         ,  FrameDamage
         ,  Drivable
         ,  OriginalPaint
         ,  AutoGrade
         )
         SELECT
            l.DriveTimeListingID
         ,  SYSDATETIME()
         ,  NULL
         ,  i.VIN
         ,  i.AuctionID
         ,  i.SaleDate
         ,  i.IsDeleted
         ,  i.UVC
         ,  i.[URL]
         ,  i.ExternalStockNumber
         ,  i.BidOnline
         ,  i.CreatedAtDateTimeUTC
         ,  i.UpdatedAtDateTimeUTC
         ,  i.OdometerReading
         ,  i.TitleState
         ,  i.BookValue
         ,  i.CheckInAtDateTimeUTC
         ,  i.GlobalConsignorKey
         ,  i.GlobalConsignorName
         ,  i.OdometerStatus
         ,  i.BuyNowExpiresAtDateTimeUTC
         ,  i.BuyNowPrice
         ,  i.OdometerComment
         ,  i.MSRP
         ,  i.AuctionSaleDayID
         ,  i.ConsignmentDateTimeUTC
         ,  i.RunNumber
         ,  i.LaneName
         ,  i.LaneTitle
         ,  i.PhysicalLaneName
         ,  i.Announcements
         ,  i.Certifications
         ,  i.[Year]
         ,  i.Make
         ,  i.Model
         ,  i.Series
         ,  i.MakeModelSeries
         ,  i.BodyStyle
         ,  i.OriginalBodyStyle
         ,  i.ExteriorColor
         ,  i.InteriorColor
         ,  i.InteriorMaterial
         ,  i.EngineSize
         ,  i.Cylinders
         ,  i.DriveType
         ,  i.FuelType
         ,  i.TransmissionType
         ,  i.DoorConfiguration
         ,  i.OptionJSON
         ,  i.SaleLightsJSON
         ,  i.ImageURLJSON
         ,  i.TireJSON
         ,  i.ConditionReportItemJSON
         ,  i.ConditionReportCreatedAtDateUTC
         ,  i.Author
         ,  i.Grade
         ,  i.FrameDamage
         ,  i.Drivable
         ,  i.OriginalPaint
         ,  i.AutoGrade
         FROM
               @DriveTimeListing l
         JOIN  @typAuctionEdgeIU i ON  l.VIN       = i.VIN
                                   AND l.AuctionID = i.AuctionID
                                   AND l.SaleDate  = i.SaleDate
                                   AND l.DoesRecordExist = 0;

         --Update the records determined to already exist
         UPDATE
            f
         SET
            f.RowUpdatedDateTime                = SYSDATETIME()
         ,  f.VIN                               = u.VIN
         ,  f.AuctionID                         = u.AuctionID
         ,  f.SaleDate                          = u.SaleDate
         ,  f.IsDeleted                         = u.IsDeleted
         ,  f.UVC                               = u.UVC
         ,  f.[URL]                             = u.[URL]
         ,  f.ExternalStockNumber               = u.ExternalStockNumber
         ,  f.BidOnline                         = u.BidOnline
         ,  f.CreatedAtDateTimeUTC              = u.CreatedAtDateTimeUTC
         ,  f.UpdatedAtDateTimeUTC              = u.UpdatedAtDateTimeUTC
         ,  f.OdometerReading                   = u.OdometerReading
         ,  f.TitleState                        = u.TitleState
         ,  f.BookValue                         = u.BookValue
         ,  f.CheckInAtDateTimeUTC              = u.CheckInAtDateTimeUTC
         ,  f.GlobalConsignorKey                = u.GlobalConsignorKey
         ,  f.GlobalConsignorName               = u.GlobalConsignorName
         ,  f.OdometerStatus                    = u.OdometerStatus
         ,  f.BuyNowExpiresAtDateTimeUTC        = u.BuyNowExpiresAtDateTimeUTC
         ,  f.BuyNowPrice                       = u.BuyNowPrice
         ,  f.OdometerComment                   = u.OdometerComment
         ,  f.MSRP                              = u.MSRP
         ,  f.AuctionSaleDayID                  = u.AuctionSaleDayID
         ,  f.ConsignmentDateTimeUTC            = u.ConsignmentDateTimeUTC
         ,  f.RunNumber                         = u.RunNumber
         ,  f.LaneName                          = u.LaneName
         ,  f.LaneTitle                         = u.LaneTitle
         ,  f.PhysicalLaneName                  = u.PhysicalLaneName
         ,  f.Announcements                     = u.Announcements
         ,  f.Certifications                    = u.Certifications
         ,  f.[Year]                            = u.[Year]
         ,  f.Make                              = u.Make
         ,  f.Model                             = u.Model
         ,  f.Series                            = u.Series
         ,  f.MakeModelSeries                   = u.MakeModelSeries
         ,  f.BodyStyle                         = u.BodyStyle
         ,  f.OriginalBodyStyle                 = u.OriginalBodyStyle
         ,  f.ExteriorColor                     = u.ExteriorColor
         ,  f.InteriorColor                     = u.InteriorColor
         ,  f.InteriorMaterial                  = u.InteriorMaterial
         ,  f.EngineSize                        = u.EngineSize
         ,  f.Cylinders                         = u.Cylinders
         ,  f.DriveType                         = u.DriveType
         ,  f.FuelType                          = u.FuelType
         ,  f.TransmissionType                  = u.TransmissionType
         ,  f.DoorConfiguration                 = u.DoorConfiguration
         ,  f.OptionJSON                        = u.OptionJSON
         ,  f.SaleLightsJSON                    = u.SaleLightsJSON
         ,  f.ImageURLJSON                      = u.ImageURLJSON
         ,  f.TireJSON                          = u.TireJSON
         ,  f.ConditionReportItemJSON           = u.ConditionReportItemJSON
         ,  f.ConditionReportCreatedAtDateUTC   = u.ConditionReportCreatedAtDateUTC
         ,  f.Author                            = u.Author
         ,  f.Grade                             = u.Grade
         ,  f.FrameDamage                       = u.FrameDamage
         ,  f.Drivable                          = u.Drivable
         ,  f.OriginalPaint                     = u.OriginalPaint
         ,  f.AutoGrade                         = u.AutoGrade
         FROM
               @DriveTimeListing          l
         JOIN  @typAuctionEdgeIU          u                 ON    l.VIN                = u.VIN
                                                            AND   l.AuctionID          = u.AuctionID
                                                            AND   l.SaleDate           = u.SaleDate
                                                            AND   l.DoesRecordExist    = 1
         JOIN  presale.tblAuctionEdgeFeed f WITH (ROWLOCK)  ON    l.DriveTimeListingID = f.DriveTimeListingID
         WHERE
            EXISTS (
                     SELECT
                        f.VIN, f.AuctionID, f.SaleDate, f.IsDeleted, f.UVC, f.[URL], f.ExternalStockNumber, f.BidOnline, f.CreatedAtDateTimeUTC, f.UpdatedAtDateTimeUTC, f.OdometerReading, f.TitleState, f.BookValue, 
                        f.CheckInAtDateTimeUTC, f.GlobalConsignorKey, f.GlobalConsignorName, f.OdometerStatus, f.BuyNowExpiresAtDateTimeUTC, f.BuyNowPrice, f.OdometerComment, f.MSRP, f.AuctionSaleDayID, 
                        f.ConsignmentDateTimeUTC, f.RunNumber, f.LaneName, f.LaneTitle, f.PhysicalLaneName, f.Announcements, f.Certifications, f.[Year], f.Make, f.Model, f.Series, f.MakeModelSeries, f.BodyStyle, 
                        f.OriginalBodyStyle, f.ExteriorColor, f.InteriorColor, f.InteriorMaterial, f.EngineSize, f.Cylinders, f.DriveType, f.FuelType, f.TransmissionType, f.DoorConfiguration, f.OptionJSON,
                        f.SaleLightsJSON, f.ImageURLJSON, f.TireJSON, f.ConditionReportItemJSON, f.ConditionReportCreatedAtDateUTC, f.Author, f.Grade, f.FrameDamage, f.Drivable, f.OriginalPaint, f.AutoGrade
                     EXCEPT
                     SELECT
                        u.VIN, u.AuctionID, u.SaleDate, u.IsDeleted, u.UVC, u.[URL], u.ExternalStockNumber, u.BidOnline, u.CreatedAtDateTimeUTC, u.UpdatedAtDateTimeUTC, u.OdometerReading, u.TitleState, u.BookValue, 
                        u.CheckInAtDateTimeUTC, u.GlobalConsignorKey, u.GlobalConsignorName, u.OdometerStatus, u.BuyNowExpiresAtDateTimeUTC, u.BuyNowPrice, u.OdometerComment, u.MSRP, u.AuctionSaleDayID, 
                        u.ConsignmentDateTimeUTC, u.RunNumber, u.LaneName, u.LaneTitle, u.PhysicalLaneName, u.Announcements, u.Certifications, u.[Year], u.Make, u.Model, u.Series, u.MakeModelSeries, u.BodyStyle, 
                        u.OriginalBodyStyle, u.ExteriorColor, u.InteriorColor, u.InteriorMaterial, u.EngineSize, u.Cylinders, u.DriveType, u.FuelType, u.TransmissionType, u.DoorConfiguration, u.OptionJSON,
                        u.SaleLightsJSON, u.ImageURLJSON, u.TireJSON, u.ConditionReportItemJSON, u.ConditionReportCreatedAtDateUTC, u.Author, u.Grade, u.FrameDamage, u.Drivable, u.OriginalPaint, u.AutoGrade
                   );

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
               ROLLBACK TRANSACTION stpIUAuctionEdgeFeed;

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

