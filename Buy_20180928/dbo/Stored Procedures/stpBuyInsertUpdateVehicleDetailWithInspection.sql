

CREATE PROCEDURE [dbo].[stpBuyInsertUpdateVehicleDetailWithInspection] 
   /*
   ----------------------------------------------------------------------------------------------------------------------
   Created By  : Gwendolyn Lukemire
   Created On  : 2/26/2018
   Application : Added logic for inspection vehicles
   Description : Insert/Update data from tblBuyStage and tblInspectionStage to new buy schema

   Updated By  : Travis Bleile
   Updated On  : 4/3/2018
   Description : Removing InspectionDateTime and SaleDate Logic from #DistinctVIN and Update Section to tblBuyVehicle

   Updated By  : Travis Bleile
   Updated On  : 7/11/2018
   Description : Complete overhaul to begin to tie inspections/decodes to a saledate. All tblBuyInspection/tblBuyDecode
				     logic has been replaced to now utilize new tblBuyAuctionInspection/tblBuyAuctionDecode. Also removed
				     all logic touching tblBuyAuctionVehicleInspectionStatus and have merged it with the newly created
				     tblbuyAuctionInspection table as this will now handle all completed inspections AND hold the status
				     of an inspection for a vehicle at an auction for a specific sale date.

   Updated By  : Daniel Folz
   Updated On  : 07/25/2018
   Description : Created a Table Variable in memory to eliminate traffic to multiple dbo.tblBuyAuctionListType calls.
				
   Updated By  : Travis Bleile
   Updated On  : 08/01/2018
   Description : Removed all references to InspectionDateTime in the Insert/Update tblBuyAuctionInspection Sections

   Updated By  : Travis Bleile
   Updated On  : 08/02/2018
   Description : Added DISTINCT into the Insert of tblBuyAuctionInspection to remove duplicate entries for vehicles with 
					  the same saledate at different auctions...

   Updated By  : Vivek Shah and Daniel Folz
   Updated On  : 08/15/2018
   Description : Changed all join sections to ensure we are matching the pertinent stage table to VIN, Auction 
                 and SaleDate

   Updated By  : Travis Bleile
   Updated On  : 09/26/2018
   Description : Updates to populate/update new table - tblBuyAuctionVehicleAttributes (CTRL+F "Updates 9/26").
					Cleaning up old commented out code

   EXEC [dbo].[stpBuyInsertUpdateVehicleDetailWithInspection]
   ----------------------------------------------------------------------------------------------------------------------
   */
  

   AS
   BEGIN;
      BEGIN TRY;

         ----SET Environment
         SET NOCOUNT ON;

         ----Create in memory table to handle dbo.tblBuyAuctionListType (07/25/2018)
         DECLARE @BuyAuctionListType TABLE
         (
            BuyAuctionListTypeID    BIGINT         NOT NULL PRIMARY KEY CLUSTERED
         ,  BuyAuctionHouseTypeID   BIGINT         NOT NULL
         ,  RowLoadedDateTime       DATETIME2(7)   NOT NULL
         ,  RowUpdatedDateTime      DATETIME2(7)   NULL
         ,  LastChangedByEmpID      VARCHAR(128)   NULL
         ,  AuctionListKey          VARCHAR(50)    NULL        
         ,  AuctionListDescription  VARCHAR(200)   NULL
         ,  [Address]               VARCHAR(50)    NULL
         ,  City                    VARCHAR(50)    NULL
         ,  [State]                 VARCHAR(20)    NULL
         ,  ZipCode                 VARCHAR(20)    NULL
         ,  IsActive                TINYINT        NOT NULL
         ,  ExternalAuctionID       VARCHAR(50)    NULL
         )

         INSERT @BuyAuctionListType
         (
            BuyAuctionListTypeID
         ,  BuyAuctionHouseTypeID
         ,  RowLoadedDateTime
         ,  RowUpdatedDateTime
         ,  LastChangedByEmpID
         ,  AuctionListKey
         ,  AuctionListDescription
         ,  [Address]
         ,  City
         ,  [State]
         ,  ZipCode
         ,  IsActive
         ,  ExternalAuctionID
         )
         SELECT
            balt.BuyAuctionListTypeID
         ,  balt.BuyAuctionHouseTypeID
         ,  balt.RowLoadedDateTime
         ,  balt.RowUpdatedDateTime
         ,  balt.LastChangedByEmpID
         ,  balt.AuctionListKey
         ,  balt.AuctionListDescription
         ,  balt.[Address]
         ,  balt.City
         ,  balt.[State]
         ,  balt.ZipCode
         ,  balt.IsActive
         ,  balt.ExternalAuctionID
         FROM
            dbo.tblBuyAuctionListType balt WITH (NOLOCK)
         ORDER BY
            balt.BuyAuctionListTypeID


         ----INSERT NEW VEHICLES INTO TBLBUYVEHICLE

         /*Add in a union to tblInspectionStage*/
         IF OBJECT_ID('tempdb.dbo.#DistinctVIN') IS NOT NULL BEGIN DROP TABLE #DistinctVIN END;
         CREATE TABLE #DistinctVIN (VIN VARCHAR(17) PRIMARY KEY CLUSTERED)

         INSERT #DistinctVIN (VIN)
         SELECT
            VIN
         ----MAX(SaleDate) AS SaleDate 
         ----COALESCE(MAX(InspectionDateTime), '') AS InspectionDateTime
         FROM
            dbo.tblBuyStage
         GROUP BY
            VIN
         UNION
         SELECT
            VIN
         ----MAX(SaleDate) AS SaleDate 
         ----COALESCE(MAX(InspectionSurveyEndDT), '') AS InspectionDateTime
         FROM
            dbo.tblInspectionStage
         GROUP BY
            VIN;

         INSERT INTO dbo.tblBuyVehicle (RowLoadedDateTime, LastChangedByEmpID, VIN)
         SELECT
            SYSDATETIME()
         ,  NULL
         ,  dv.VIN
         FROM
                     #DistinctVIN      dv
         LEFT JOIN   dbo.tblBuyVehicle bv ON bv.VIN = dv.VIN
         WHERE
            bv.VIN IS NULL;

         ----UPDATE COLUMN CHANGES TO TBLBUYVEHICLE

         /*Add in a union or join to tblInspectionStage*/
         /*Update the vehicles that exist in inspection stage*/
         UPDATE
            bv
         SET
            bv.RowUpdatedDateTime   = SYSDATETIME()
         ,  bv.[Year]               = ist.[Year]
         ,  bv.Make                 = ist.Make
         ,  bv.Model                = ist.Model
         ,  bv.Color                = ist.Color
         --,  bv.Size                 = ist.Size ---9/26 Update
         ----Select bv.*
         FROM
                     dbo.tblBuyVehicle       bv
         INNER JOIN  #DistinctVIN            dv    ON dv.VIN   = bv.VIN
         INNER JOIN  dbo.tblInspectionStage  ist   ON ist.VIN  = dv.VIN
         ----AND ist.SaleDate = dv.SaleDate
         ----AND COALESCE(ist.InspectionSurveyEndDT, '') = dv.InspectionDateTime
         WHERE
            COALESCE(bv.[Year], '') <> COALESCE(ist.[Year], '')
         OR COALESCE(bv.Make, '')   <> COALESCE(ist.Make, '')
         OR COALESCE(bv.Model, '')  <> COALESCE(ist.Model, '')
         OR COALESCE(bv.Color, '')  <> COALESCE(ist.Color, '');
         --OR COALESCE(bv.Size, '')   <> COALESCE(ist.Size, '') ---- Update 9/26


         /*Update the vehicles that exist in buy stage - this will overwrite any insp stage changes if vehicle exists in both*/
         UPDATE
            bv
         SET
            bv.RowUpdatedDateTime   = SYSDATETIME()
         ,  bv.[Year]               = bs.[Year]
         ,  bv.Make                 = bs.Make
         ,  bv.Model                = bs.Model
         ,  bv.Color                = bs.Color
         ,  bv.BodyStyle            = bs.BodyStyle
         --,  bv.Size                 = bs.Size ----Update 9/26
         ----Select bv.*
         FROM
                     dbo.tblBuyVehicle bv
         INNER JOIN  #DistinctVIN      dv ON dv.VIN = bv.VIN
         INNER JOIN  dbo.tblBuyStage   bs ON bs.VIN = dv.VIN
         ----AND bs.SaleDate = dv.SaleDate
         ----AND COALESCE(bs.InspectionDateTime, '') = dv.InspectionDateTime
         WHERE
            COALESCE(bv.[Year], '')    <> COALESCE(bs.[Year], '')
         OR COALESCE(bv.Make, '')      <> COALESCE(bs.Make, '')
         OR COALESCE(bv.Model, '')     <> COALESCE(bs.Model, '')
         OR COALESCE(bv.Color, '')     <> COALESCE(bs.Color, '')
         OR COALESCE(bv.BodyStyle, '') <> COALESCE(bs.BodyStyle, '');
         --OR COALESCE(bv.Size, '')      <> COALESCE(bs.Size, ''); ----Update 9/26

         ----INSERT DATA INTO TBLBUYAUCTIONVEHICLE

         /*Add logic to insert from inspection stage*/
         /*Cannot assume vehicle exists in buy stage*/

         /*Insert the vehicle into BAV from inspection stage - if it wasn't already inserted from buy stage*/
         INSERT INTO dbo.tblBuyAuctionVehicle
         (
            BuyVehicleID
         ,  BuyAuctionListTypeID
         ,  RowLoadedDateTime
         ,  RowUpdatedDateTime
         ,  LastChangedByEmpID
         ,  SaleDate
         ,  Lane
         ,  Run
         --,  Odometer ----9/26 Update
         ,  SellerName
         ,  PreSaleAnnouncement
         ,  IsDecommissionedInspection
         ,  IsDecommissionedInspectionDateTime
         ,  IsAccuCheckIssue
         ,  IsAccuCheckIssueDateTime
         ,  IsInspectorAppVehicle
         )
         SELECT
            bv.BuyVehicleID
         ,  balt.BuyAuctionListTypeID
         ,  SYSDATETIME()
         ,  SYSDATETIME()
         ,  NULL
         ,  ist.SaleDate
         ,  ist.Lane
         ,  ist.Run
         --,  ist.Odometer ----9/26 Update
         ,  ist.SellerName
         ,  ist.Announcement
         ,  ist.IsDecommissionedInspection
         ,  ist.IsDecommissionedInspectionDateTime
         ,  ist.IsAccuCheckIssue
         ,  ist.IsAccuCheckIssueDateTime
         ,  1
         FROM
                     dbo.tblInspectionStage     ist
         INNER JOIN  dbo.tblBuyVehicle          bv    ON    bv.VIN                     = ist.VIN
         LEFT JOIN   @BuyAuctionListType        balt  ON    ist.AuctionName            = balt.AuctionListKey
         LEFT JOIN   dbo.tblBuyAuctionVehicle   bav   ON    bav.BuyVehicleID           = bv.BuyVehicleID
                                                      AND   bav.SaleDate               = ist.SaleDate
                                                      AND   bav.BuyAuctionListTypeID   = balt.BuyAuctionListTypeID
         WHERE
               bav.BuyAuctionVehicleID    IS NULL
         AND   balt.BuyAuctionListTypeID  IS NOT NULL;

         /*Insert the vehicle into BAV and set the buy app vehicle flag because it exists in buy stage*/
         INSERT INTO dbo.tblBuyAuctionVehicle
         (
            BuyVehicleID
         ,  BuyAuctionListTypeID
         ,  RowLoadedDateTime
         ,  RowUpdatedDateTime
         ,  LastChangedByEmpID
         ,  SaleDate
         ,  Lane
         ,  Run
         --,  Odometer ----Update 9/26
         ,  SellerName
         ,  VehicleLink
         ,  CRLink
         ,  CRScore
         ,  PreSaleAnnouncement
         ,  PriceCap
         ,  IsPreviousDTVehicle
         ,  IsDTInspectionRequested
         ,  IsDecommissioned
         ,  IsDecommissionedDateTime
         ,  KBBMultiplier
         ,  KBBDTAdjustmentValue
         ,  MMRValue
         ,  BuyStrategyID
         ,  Images
         ,  IsAccuCheckIssue
         ,  IsAccuCheckIssueDateTime
         ,  IsBuyerAppVehicle
         )
         SELECT
            bv.BuyVehicleID
         ,  balt.BuyAuctionListTypeID
         ,  SYSDATETIME()
         ,  SYSDATETIME()
         ,  NULL
         ,  bs.SaleDate
         ,  bs.Lane
         ,  bs.Run
         --,  bs.Odometer ----Update 9/26
         ,  bs.SellerName
         ,  bs.VehicleLink
         ,  bs.CRLink
         ,  bs.CRScore
         ,  bs.PreSaleAnnouncement
         ,  bs.PriceCap
         ,  bs.IsPreviousDTVehicle
         ,  bs.IsDTInspectionRequested
         ,  bs.IsDecommissioned
         ,  bs.IsDecommissionedDateTime
         ,  bs.KBBMultiplier
         ,  bs.KBBDTAdjustmentValue
         ,  bs.MMRValue
         ,  bs.BuyStrategyID
         ,  bs.Images
         ,  bs.IsAccuCheckIssue
         ,  bs.IsAccuCheckIssueDateTime
         ,  1
         FROM
                     dbo.tblBuyStage            bs
         INNER JOIN  dbo.tblBuyVehicle          bv    ON    bv.VIN                     = bs.VIN
         LEFT JOIN   @BuyAuctionListType        balt  ON    bs.AuctionName             = balt.AuctionListKey
         LEFT JOIN   dbo.tblBuyAuctionVehicle   bav   ON    bav.BuyVehicleID           = bv.BuyVehicleID
                                                      AND   bav.SaleDate               = bs.SaleDate
                                                      AND   bav.BuyAuctionListTypeID   = balt.BuyAuctionListTypeID
         WHERE
               bav.BuyAuctionVehicleID    IS NULL
         AND   balt.BuyAuctionListTypeID  IS NOT NULL;

         ----UPDATE COLUMN CHANGES TO TBLBUYAUCTIONVEHICLE
         UPDATE
            bav
         SET
            bav.RowUpdatedDateTime                 = SYSDATETIME()
         ,  bav.Lane                               = ist.Lane
         ,  bav.Run                                = ist.Run
         --,  bav.Odometer                           = ist.Odometer ----Update 9/26
         ,  bav.SellerName                         = ist.SellerName
         ,  bav.PreSaleAnnouncement                = ist.Announcement
         ,  bav.IsDecommissionedInspection         = ist.IsDecommissionedInspection
         ,  bav.IsDecommissionedInspectionDateTime = ist.IsDecommissionedInspectionDateTime
         ,  bav.IsAccuCheckIssue                   = ist.IsAccuCheckIssue
         ,  bav.IsAccuCheckIssueDateTime           = ist.IsAccuCheckIssueDateTime
         ,  bav.IsInspectorAppVehicle              = 1
         ----Select *
         FROM
                     dbo.tblBuyAuctionVehicle   bav
         INNER JOIN  dbo.tblBuyVehicle          bv    ON bv.BuyVehicleID            = bav.BuyVehicleID
         LEFT JOIN   @BuyAuctionListType        balt  ON balt.BuyAuctionListTypeID  = bav.BuyAuctionListTypeID
         INNER JOIN  dbo.tblInspectionStage     ist   ON ist.VIN                    = bv.VIN
                                                      AND ist.SaleDate              = bav.SaleDate
                                                      AND ist.AuctionName           = balt.AuctionListKey
         WHERE
            COALESCE(bav.Lane, '')                               <> COALESCE(ist.Lane, '')
         OR COALESCE(bav.Run, '')                                <> COALESCE(ist.Run, '')
         --OR COALESCE(bav.Odometer, 0)                            <> COALESCE(ist.Odometer, 0) ----Update 9/26
         OR COALESCE(bav.SellerName, '')                         <> COALESCE(ist.SellerName, '')
         OR COALESCE(bav.PreSaleAnnouncement, '')                <> COALESCE(ist.Announcement, '')
         OR COALESCE(bav.IsDecommissionedInspection, 0)          <> COALESCE(ist.IsDecommissionedInspection, 0)
         OR COALESCE(bav.IsDecommissionedInspectionDateTime, '') <> COALESCE(ist.IsDecommissionedInspectionDateTime, '')
         OR COALESCE(bav.IsAccuCheckIssue, 0)                    <> COALESCE(ist.IsAccuCheckIssue, 0)
         OR COALESCE(bav.IsAccuCheckIssueDateTime, '')           <> COALESCE(ist.IsAccuCheckIssueDateTime, '')
         OR COALESCE(bav.IsInspectorAppVehicle, 0)               <> 1;


         /*Update columns related to buy stage*/
         UPDATE
            bav
         SET
            bav.RowUpdatedDateTime        = SYSDATETIME()
         ,  bav.Lane                      = bs.Lane
         ,  bav.Run                       = bs.Run
        --,  bav.Odometer                  = bs.Odometer ----Update 9/26
         ,  bav.SellerName                = bs.SellerName
         ,  bav.VehicleLink               = bs.VehicleLink
         ,  bav.CRLink                    = bs.CRLink
         ,  bav.CRScore                   = bs.CRScore
         ,  bav.PreSaleAnnouncement       = bs.PreSaleAnnouncement
         ,  bav.PriceCap                  = bs.PriceCap
         ,  bav.IsPreviousDTVehicle       = bs.IsPreviousDTVehicle
         ,  bav.IsDTInspectionRequested   = CASE WHEN bav.IsDTInspectionRequested = 1 THEN 1 ELSE bs.IsDTInspectionRequested END
         ,  bav.IsDecommissioned          = bs.IsDecommissioned
         ,  bav.IsDecommissionedDateTime  = bs.IsDecommissionedDateTime
         ,  bav.KBBMultiplier             = bs.KBBMultiplier
         ,  bav.KBBDTAdjustmentValue      = bs.KBBDTAdjustmentValue
         ,  bav.MMRValue                  = bs.MMRValue
         ,  bav.BuyStrategyID             = bs.BuyStrategyID
         ,  bav.Images                    = bs.Images
         ,  bav.IsAccuCheckIssue          = bs.IsAccuCheckIssue
         ,  bav.IsAccuCheckIssueDateTime  = bs.IsAccuCheckIssueDateTime
         ,  bav.IsBuyerAppVehicle         = 1
         ----Select bv.VIN, bv.BuyVehicleID, bav.SaleDate, bs.auctionname
         FROM
                     dbo.tblBuyAuctionVehicle   bav
         INNER JOIN  dbo.tblBuyVehicle          bv    ON    bv.BuyVehicleID            = bav.BuyVehicleID
		   LEFT JOIN   @BuyAuctionListType		   balt  ON    balt.BuyAuctionListTypeID  = bav.BuyAuctionListTypeID
         INNER JOIN  dbo.tblBuyStage            bs    ON    bs.VIN                     = bv.VIN
                                                      AND   bs.SaleDate                = bav.SaleDate
													               AND   bs.AuctionName             = balt.AuctionListKey
         WHERE
            COALESCE(bav.Lane, '')                       <> COALESCE(bs.Lane, '')
         OR COALESCE(bav.Run, '')                        <> COALESCE(bs.Run, '')
         --OR COALESCE(bav.Odometer, 0)                    <> COALESCE(bs.Odometer, 0) ----Update 9/26
         OR COALESCE(bav.SellerName, '')                 <> COALESCE(bs.SellerName, '')
         OR COALESCE(bav.VehicleLink, '')                <> COALESCE(bs.VehicleLink, '')
         OR COALESCE(bav.CRLink, '')                     <> COALESCE(bs.CRLink, '')
         OR COALESCE(bav.CRScore, '')                    <> COALESCE(bs.CRScore, '')
         OR COALESCE(bav.PreSaleAnnouncement, '')        <> COALESCE(bs.PreSaleAnnouncement, '')
         OR COALESCE(bav.PriceCap, 0)                    <> COALESCE(bs.PriceCap, 0)
         OR COALESCE(bav.IsPreviousDTVehicle, 0)         <> COALESCE(bs.IsPreviousDTVehicle, 0)
         OR COALESCE(bav.IsDTInspectionRequested, 0)     <> COALESCE(CASE WHEN bav.IsDTInspectionRequested = 1 THEN 1 ELSE bs.IsDTInspectionRequested END, 0)
         OR COALESCE(bav.IsDecommissioned, 0)            <> COALESCE(bs.IsDecommissioned, 0)
         OR COALESCE(bav.IsDecommissionedDateTime, '')   <> COALESCE(bs.IsDecommissionedDateTime, '')
         OR COALESCE(bav.KBBMultiplier, 0)               <> COALESCE(bs.KBBMultiplier, 0)
         OR COALESCE(bav.KBBDTAdjustmentValue, 0)        <> COALESCE(bs.KBBDTAdjustmentValue, 0)
         OR COALESCE(bav.MMRValue, 0)                    <> COALESCE(bs.MMRValue, 0)
         OR COALESCE(bav.BuyStrategyID, 0)               <> COALESCE(bs.BuyStrategyID, 0)
         OR COALESCE(bav.Images, '')                     <> COALESCE(bs.Images, '')
         OR COALESCE(bav.IsAccuCheckIssue, 0)            <> COALESCE(bs.IsAccuCheckIssue, 0)
         OR COALESCE(bav.IsAccuCheckIssueDateTime, '')   <> COALESCE(bs.IsAccuCheckIssueDateTime, '')
         OR COALESCE(bav.IsBuyerAppVehicle, 0)           <> 1;

		/*Insert Presale/Analytics values into tblBuyAuctionVehicleAttributes - Update 9/26*/ 
		
		----tblBuyAuctionVehicleAttributes - From InspectionStage

		INSERT INTO dbo.tblBuyAuctionVehicleAttributes
		(
		    BuyAuctionVehicleID,
		    RowLoadedDateTime,
		    RowUpdatedDateTime,
		    LastChangedByEmpID,
		    Size,
		    Odometer
		)
		SELECT
			bav.BuyAuctionVehicleID,
			SYSDATETIME(),
			SYSDATETIME(),
			NULL,
			ist.Size,
			ist.Odometer
		FROM dbo.tblBuyAuctionVehicle bav 
			 JOIN buy.dbo.tblBuyVehicle bv ON bv.BuyVehicleID = bav.BuyVehicleID
			 LEFT JOIN @BuyAuctionListType balt ON balt.BuyAuctionListTypeID = bav.BuyAuctionListTypeID
			 JOIN buy.dbo.tblInspectionStage ist ON ist.VIN = bv.VIN 
													AND balt.AuctionListKey = ist.AuctionName
													AND ist.SaleDate = bav.SaleDate
			LEFT JOIN buy.dbo.tblBuyAuctionVehicleAttributes bava ON bava.BuyAuctionVehicleID = bav.BuyAuctionVehicleID
			WHERE bava.BuyAuctionVehicleID IS NULL;

		----tblBuyAuctionVehicleAttributes - From BuyStage

		INSERT INTO dbo.tblBuyAuctionVehicleAttributes
		(
		    BuyAuctionVehicleID,
		    RowLoadedDateTime,
		    RowUpdatedDateTime,
		    LastChangedByEmpID,
		    Size,
		    Odometer
		)
		SELECT
			bav.BuyAuctionVehicleID,
			SYSDATETIME(),
			SYSDATETIME(),
			NULL,
			ist.Size,
			ist.Odometer
		FROM dbo.tblBuyAuctionVehicle bav 
			 JOIN buy.dbo.tblBuyVehicle bv ON bv.BuyVehicleID = bav.BuyVehicleID
			 LEFT JOIN @BuyAuctionListType balt ON balt.BuyAuctionListTypeID = bav.BuyAuctionListTypeID
			 JOIN buy.dbo.tblBuystage ist ON ist.VIN = bv.VIN 
													AND balt.AuctionListKey = ist.AuctionName
													AND ist.SaleDate = bav.SaleDate
			LEFT JOIN buy.dbo.tblBuyAuctionVehicleAttributes bava ON bava.BuyAuctionVehicleID = bav.BuyAuctionVehicleID
			WHERE bava.BuyAuctionVehicleID IS NULL;


		---- UPDATE tblBuyAuctionVehicleAttributes - From InspectionStage
		UPDATE bava 
		SET    bava.RowUpdatedDateTime = SYSDATETIME(),
               bava.Size = ist.Size,
               bava.Odometer = ist.Odometer
		--SELECT bava.Size,ist.size,bava.Odometer,ist.odometer
		FROM dbo.tblBuyAuctionVehicleAttributes bava
		JOIN dbo.tblBuyAuctionVehicle bav ON bav.BuyAuctionVehicleID = bava.BuyAuctionVehicleID
		JOIN buy.dbo.tblBuyVehicle bv ON bv.BuyVehicleID = bav.BuyVehicleID 
		LEFT JOIN @BuyAuctionListType balt ON balt.BuyAuctionListTypeID = bav.BuyAuctionListTypeID
		JOIN dbo.tblInspectionStage ist ON ist.VIN = bv.VIN
										AND ist.AuctionName = balt.AuctionListKey
										AND ist.SaleDate = bav.SaleDate
		WHERE	COALESCE(bava.Size, '')		<> COALESCE(ist.Size, '')
				OR COALESCE(bava.Odometer, 0)		<> COALESCE(ist.Odometer, 0)

		---- UPDATE tblBuyAuctionVehicleAttributes - From BuyStage
		UPDATE bava 
		SET    bava.RowUpdatedDateTime = SYSDATETIME(),
               bava.Size = bs.Size,
               bava.Odometer = bs.Odometer
		--SELECT bava.Size,bs.size,bava.Odometer,bs.odometer
		FROM dbo.tblBuyAuctionVehicleAttributes bava
		JOIN dbo.tblBuyAuctionVehicle bav ON bav.BuyAuctionVehicleID = bava.BuyAuctionVehicleID
		JOIN buy.dbo.tblBuyVehicle bv ON bv.BuyVehicleID = bav.BuyVehicleID 
		LEFT JOIN @BuyAuctionListType balt ON balt.BuyAuctionListTypeID = bav.BuyAuctionListTypeID
		JOIN dbo.tblBuyStage bs ON bs.VIN = bv.VIN
										AND bs.AuctionName = balt.AuctionListKey
										AND bs.SaleDate = bav.SaleDate
		WHERE	COALESCE(bava.Size, '')		<> COALESCE(bs.Size, '')
				OR COALESCE(bava.Odometer, 0)		<> COALESCE(bs.Odometer, 0)


         /*Insert new requested (by analytics) inspections into tblBuyAuctionInspection*/
         INSERT INTO dbo.tblBuyAuctionInspection (BuyInspectionTypeID, BuyAuctionVehicleID, RowLoadedDateTime, RowUpdatedDateTime)
         SELECT DISTINCT
            BuyInspectionTypeID        = 1
         ,  bav.BuyAuctionVehicleID
         ,  RowLoadedDateTime          = SYSDATETIME()
         ,  RowUpdatedDateTime         = SYSDATETIME()
         FROM
                     dbo.tblInspectionStage        ist
         JOIN        dbo.tblBuyVehicle             bv    ON    bv.VIN                     = ist.VIN
		 LEFT JOIN   @BuyAuctionListType		   balt  ON    ist.AuctionName            = balt.AuctionListKey
         JOIN        dbo.tblBuyAuctionVehicle      bav   ON    bav.SaleDate               = ist.SaleDate
                                                         AND   bav.BuyVehicleID           = bv.BuyVehicleID
														               AND   bav.BuyAuctionListTypeID   = balt.BuyAuctionListTypeID
         LEFT JOIN   dbo.tblBuyAuctionInspection   bai   ON    bai.BuyAuctionVehicleID    = bav.BuyAuctionVehicleID
                                                         AND   bai.BuyInspectionTypeID    = 1 ----AIM Inspection
         WHERE
            bai.BuyAuctionVehicleID IS NULL;

         /*Set checkbox recon amounts the Survey result date for AIM inspections into tblBuyAuctionInspection*/
         UPDATE
            bai
         SET
            bai.RowUpdatedDateTime               = SYSDATETIME()
         ,  bai.InspectionNotes                  = bs.InspectionNotes
         ,  bai.EstimatedReconTireGlass          = bs.EstimatedReconTireGlass
         ,  bai.EstimatedReconExteriorCosmetic   = bs.EstimatedReconExteriorCosmetic
         ,  bai.EstimatedReconInterior           = bs.EstimatedReconInterior
         ,  bai.EstimatedReconOther              = bs.EstimatedReconOther
         ,  bai.EstimatedReconTotal              = CASE WHEN COALESCE(bai.EstimatedReconTotal, 0) <> COALESCE(bs.EstimatedReconTotal, 0) AND  bai.BuyInspectionTypeID = 1 
                                                        THEN bs.EstimatedReconTotal
                                                        ELSE COALESCE(bai.EstimatedReconTotal, 0)
                                                   END
         ,  bai.DashboardLights                  = bs.DashboardLights
         ,  bai.IsDTPreferred                    = bs.IsDTPreferred
         ,  bai.IsInspectionFailed               = bs.IsInspectionFailed
         ,  bai.SurveyCompletedDateTime          = bs.InspectionDateTime
         ,  bai.SurveyResultsDateTime            = SYSDATETIME()
         ----Select bai.SurveyCompletedDateTime, bs.InspectionDateTIme,*
         FROM
                     dbo.tblBuyAuctionInspection   bai
         INNER JOIN  dbo.tblBuyAuctionVehicle      bav   ON    bav.BuyAuctionVehicleID    = bai.BuyAuctionVehicleID
         LEFT JOIN   @BuyAuctionListType           balt  ON    balt.BuyAuctionListTypeID  = bav.BuyAuctionListTypeID
         INNER JOIN  dbo.tblBuyVehicle             bv    ON    bv.BuyVehicleID            = bav.BuyVehicleID
         INNER JOIN  dbo.tblBuyStage               bs    ON    bs.VIN                     = bv.VIN
                                                         AND   bs.AuctionName             = balt.AuctionListKey
                                                         AND   bs.SaleDate                = bav.SaleDate
         WHERE
            (   ----(COALESCE(bai.ManualBookValue, 0) <> COALESCE(bai.ManualBookValue, 0) AND bai.ManualBookValue = 0)
               ----OR COALESCE(bai.KBBValue, 0) <> COALESCE(bs.KBBValue, 0)
                  COALESCE(bai.InspectionNotes, '')                <> COALESCE(bs.InspectionNotes, '')
               OR COALESCE(bai.EstimatedReconTireGlass, 0)         <> COALESCE(bs.EstimatedReconTireGlass, 0)
               OR COALESCE(bai.EstimatedReconExteriorCosmetic, 0)  <> COALESCE(bs.EstimatedReconExteriorCosmetic, 0)
               OR COALESCE(bai.EstimatedReconInterior, 0)          <> COALESCE(bs.EstimatedReconInterior, 0)
               OR COALESCE(bai.EstimatedReconOther, 0)             <> COALESCE(bs.EstimatedReconOther, 0)
               OR (
                           COALESCE(bai.EstimatedReconTotal, 0)    <> COALESCE(bs.EstimatedReconTotal, 0)     AND   bai.BuyInspectionTypeID = 1
                  )
               OR COALESCE(bai.DashboardLights, '')                <> COALESCE(bs.DashboardLights, '')
               OR COALESCE(bai.IsDTPreferred, 0)                   <> COALESCE(bs.IsDTPreferred, 0)
               OR COALESCE(bai.IsInspectionFailed, 0)              <> COALESCE(bs.IsInspectionFailed, 0)
               OR COALESCE(bai.SurveyCompletedDateTime, '')        <> COALESCE(bs.InspectionDateTime, '')
            )
         AND bai.BuyInspectionTypeID = 1
         AND bs.InspectionDateTime  IS NOT NULL
		   AND (COALESCE(bs.EstimatedReconTotal, 0) > 0 OR COALESCE(bs.IsInspectionFailed, 0) = 1 );

         /*Update tblBuyAuctionInspection for vehicle not found scenario - set vehicle back to Inspection Not Started (all dates NULL) after analytics passes it up again*/
         UPDATE
            bai
         SET
            bai.VehicleNotFoundDateTime       = NULL
         ,  bai.HasConditionReportDateTime    = NULL
         ,  bai.InspectionCompletedDateTime   = NULL
         ,  bai.InspectionStartedDateTime     = NULL
         ,  bai.RowUpdatedDateTime            = SYSDATETIME()
         ----SELECT *
         FROM
               dbo.tblBuyAuctionInspection   bai
         JOIN  dbo.tblBuyAuctionVehicle      bav   ON    bav.BuyAuctionVehicleID    = bai.BuyAuctionVehicleID
		   LEFT JOIN  @BuyAuctionListType      balt  ON    balt.BuyAuctionListTypeID  = bav.BuyAuctionListTypeID
         JOIN  dbo.tblBuyVehicle             bv    ON    bav.BuyVehicleID           = bv.BuyVehicleID
         JOIN  dbo.tblInspectionStage        ist   ON    bv.VIN                     = ist.VIN
                                                   AND   ist.SaleDate               = bav.SaleDate
												               AND   ist.AuctionName            = balt.AuctionListKey
         WHERE
               ist.InspectionBucket    = 'Inspection Not Started'
         AND   bai.InspectionStatusKey = 'VEHICLENOTFOUND';

  

         ----INSERT AIM DECODES INTO TBLBUYAUCTIONDECODE NEW 7/11
         INSERT INTO dbo.tblBuyAuctionDecode
         (
            BuyDecodeTypeID
         ,  BuyAuctionVehicleID
         ,  RowLoadedDateTime
         ,  RowUpdatedDateTime
         ,  LastChangedByEmpID
         ,  DecodeDateTime
         ,  DecodeAmount
         ,  DecodedBy
         ,  DecodedByEmail
         ,  DecodedByEmployeeID
         ,  IsDeleted
         )
         SELECT
            1
         ,  bav.BuyAuctionVehicleID
         ,  SYSDATETIME()
         ,  SYSDATETIME()
         ,  NULL
         ,  bs.InspectionDateTime
         ,  bs.ManualBookValue
         ,  bs.InspectorName
         ,  bs.InspectorEmail
         ,  bs.InspectorEmployeeID
         ,  0
         FROM
                     dbo.tblBuyStage            bs
         INNER JOIN  dbo.tblBuyVehicle          bv    ON    bs.VIN                     = bv.VIN
		   LEFT JOIN   @BuyAuctionListType        balt  ON    bs.AuctionName             = balt.AuctionListKey
         INNER JOIN  dbo.tblBuyAuctionVehicle   bav   ON    bav.BuyVehicleID           = bv.BuyVehicleID
                                                      AND   bs.SaleDate                = bav.SaleDate
													               AND   balt.BuyAuctionListTypeID  = bav.BuyAuctionListTypeID
         LEFT JOIN   dbo.tblBuyAuctionDecode    bd    ON    bd.BuyAuctionVehicleID     = bav.BuyAuctionVehicleID
                                                      AND   bs.InspectionDateTime      = bd.DecodeDateTime
                                                      AND   bd.BuyDecodeTypeID         = 1
         WHERE
               bd.BuyAuctionDecodeID   IS NULL
         AND   bs.IsAIMInspection      = 1
         ORDER BY
            bv.BuyVehicleID;


         ----UPDATE CHANGES TO TBLBUYAUCTIONDECODE NEW 7/11
         UPDATE
            bd
         SET
            bd.RowUpdatedDateTime   = SYSDATETIME()
         ,  bd.DecodeDateTime       = bs.InspectionDateTime
         ,  bd.DecodeAmount         = bs.ManualBookValue
         ,  bd.DecodedBy            = bs.InspectorName
         ,  bd.DecodedByEmail       = bs.InspectorEmail
         ,  bd.DecodedByEmployeeID  = bs.InspectorEmployeeID
         --Select bs.InspectionDateTime, bd.DecodeDateTime,bv.vin,bs.AuctionName,bav.SaleDate,*
         FROM
                     dbo.tblBuyAuctionDecode    bd
         INNER JOIN  dbo.tblBuyAuctionVehicle   bav   ON    bav.BuyAuctionVehicleID    = bd.BuyAuctionVehicleID
         LEFT JOIN   @BuyAuctionListType        balt  ON    balt.BuyAuctionListTypeID  = bav.BuyAuctionListTypeID
         INNER JOIN  dbo.tblBuyVehicle          bv    ON    bv.BuyVehicleID            = bav.BuyVehicleID
         INNER JOIN  dbo.tblBuyStage            bs    ON    bs.VIN                     = bv.VIN
                                                      AND   bs.AuctionName             = balt.AuctionListKey
                                                      AND   bs.SaleDate                = bav.SaleDate
         WHERE
            (
                  COALESCE(bd.DecodeDateTime, '')        <> COALESCE(bs.InspectionDateTime, '')
               OR COALESCE(bd.DecodeAmount, 0)           <> COALESCE(bs.ManualBookValue, 0)
               OR COALESCE(bd.DecodedBy, '')             <> COALESCE(bs.InspectorName, '')
               OR COALESCE(bd.DecodedByEmail, '')        <> COALESCE(bs.InspectorEmail, '')
               OR COALESCE(bd.DecodedByEmployeeID, '')   <> COALESCE(bs.InspectorEmployeeID, '')
            )
         AND   bd.BuyDecodeTypeID      = 1
         AND   bs.InspectionDateTime   IS NOT NULL;



      END TRY


      /*------------------------------------------------------
      Special catch logic only good for SELECT type procedures
      Because it does not contain rollback code.
      ------------------------------------------------------*/
      BEGIN CATCH
         DECLARE
            @ErrorNumber    INT
         ,  @ErrorSeverity  INT
         ,  @ErrorState     INT
         ,  @ErrorLine      INT
         ,  @ErrorProcedure NVARCHAR(200)
         ,  @ErrorMessage   VARCHAR(4000);

         -- Assign variables to error-handling functions that capture information for RAISERROR.
         SELECT
            @ErrorNumber    = ERROR_NUMBER()
         ,  @ErrorSeverity  = ERROR_SEVERITY()
         ,  @ErrorState     = ERROR_STATE()
         ,  @ErrorLine      = ERROR_LINE()
         ,  @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');

         -- Building the message string that will contain original error information.
         SELECT
            @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, ' + 'Message: ' + ERROR_MESSAGE();

         -- Use RAISERROR inside the CATCH block to return error
         -- information about the original error that caused
         -- execution to jump to the CATCH block.
         RAISERROR(  @ErrorMessage     -- Message text.
                  ,  16                -- must be 16 for Informatica to pick it up
                  ,  1
                  ,  @ErrorNumber
                  ,  @ErrorSeverity    -- Severity.
                  ,  @ErrorState       -- State.
                  ,  @ErrorProcedure
                  ,  @ErrorLine
                  );

         -- Return a negative number so that if the calling code is using a LINK server, it will
         -- be able to test that the procedure failed.  Without this, there are some lower type of 
         -- errors that do not show up across the LINK as an error.  This causes ProcessControl 
         -- in particular to not see that the procedure failed which is bad.
         RETURN -1;
      END CATCH;
   END;

