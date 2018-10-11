





CREATE PROCEDURE [dbo].[stpBuyInsertUpdateVehicleDetail]




/*----------------------------------------------------------------------------------------
Created By  : Travis Bleile
Created On  : 2017-9-19
Application : New Buyer App
Description : Insert/Update data from tblBuyStage to new buy schema

Updated By	: Travis Bleile
Updated On	: 2018-1-16
Description	: Decode Table Logic

Updated By  : Gwendolyn Lukemire
Updated On  : 1/30/2018
Description : Added new column IsAccuCheckIssue and IsAccuCheckIssueDateTime

EXEC [dbo].[stpBuyInsertUpdateVehicleDetail]
------------------------------------------------------------------------------------------
*/
AS
    BEGIN;
        BEGIN TRY;



            ----INSERT NEW VEHICLES INTO TBLBUYVEHICLE

            IF OBJECT_ID('tempdb.dbo.#DistinctVIN') IS NOT NULL
                DROP TABLE #DistinctVIN;
            SELECT   DISTINCT VIN ,
                     MAX(SaleDate) AS SaleDate ,
                     COALESCE(MAX(InspectionDateTime), '') AS InspectionDateTime
            INTO     #DistinctVIN
            FROM     dbo.tblBuyStage
            GROUP BY VIN;


            INSERT INTO dbo.tblBuyVehicle (   RowLoadedDateTime ,
                                              LastChangedByEmpID ,
                                              VIN
                                          )
                        SELECT SYSDATETIME() ,
                               NULL ,
                               dv.VIN
                        FROM   #DistinctVIN dv
                               LEFT JOIN dbo.tblBuyVehicle bv ON bv.VIN = dv.VIN
                        WHERE  bv.VIN IS NULL;

            ----UPDATE COLUMN CHANGES TO TBLBUYVEHICLE

            UPDATE bv
            SET    bv.RowUpdatedDateTime = SYSDATETIME() ,
                   bv.Year = bs.Year ,
                   bv.Make = bs.Make ,
                   bv.Model = bs.Model ,
                   bv.Color = bs.Color ,
                   bv.BodyStyle = bs.BodyStyle ,
                   bv.Size = CASE WHEN bs.Size LIKE 'Salmon%' THEN bs.Size
                                  ELSE bs.Size
                             END
            --Select bv.*
            FROM   dbo.tblBuyVehicle bv
                   INNER JOIN #DistinctVIN dv ON dv.VIN = bv.VIN
                   INNER JOIN dbo.tblBuyStage bs ON bs.VIN = dv.VIN
                                                    AND bs.SaleDate = dv.SaleDate
                                                    AND COALESCE(bs.InspectionDateTime, '') = dv.InspectionDateTime
            WHERE  COALESCE(bv.Year, '') <> COALESCE(bs.Year, '')
                   OR COALESCE(bv.Make, '') <> COALESCE(bs.Make, '')
                   OR COALESCE(bv.Model, '') <> COALESCE(bs.Model, '')
                   OR COALESCE(bv.Color, '') <> COALESCE(bs.Color, '')
                   OR COALESCE(bv.BodyStyle, '') <> COALESCE(bs.BodyStyle, '')
                   OR COALESCE(bv.Size, '') <> COALESCE(bs.Size, '');


            ----INSERT DATA INTO TBLBUYAUCTIONVEHICLE

            INSERT INTO dbo.tblBuyAuctionVehicle (   BuyVehicleID ,
                                                     BuyAuctionListTypeID ,
                                                     RowLoadedDateTime ,
                                                     RowUpdatedDateTime ,
                                                     LastChangedByEmpID ,
                                                     SaleDate ,
                                                     Lane ,
                                                     Run ,
                                                     Odometer ,
                                                     SellerName ,
                                                     VehicleLink ,
                                                     CRLink ,
                                                     CRScore ,
                                                     PreSaleAnnouncement ,
                                                     PriceCap ,
                                                     IsPreviousDTVehicle ,
                                                     IsDTInspectionRequested ,
                                                     IsDecommissioned ,
                                                     IsDecommissionedDateTime ,
                                                     KBBMultiplier ,
                                                     KBBDTAdjustmentValue ,
                                                     MMRValue ,
                                                     BuyStrategyID ,
                                                     Images,
                                                     IsAccuCheckIssue,
                                                     IsAccuCheckIssueDateTime
                                                 )
                        SELECT bv.BuyVehicleID ,
                               balt.BuyAuctionListTypeID ,
                               SYSDATETIME() ,
                               SYSDATETIME() ,
                               NULL ,
                               bs.SaleDate ,
                               bs.Lane ,
                               bs.Run ,
                               bs.Odometer ,
                               bs.SellerName ,
                               bs.VehicleLink ,
                               bs.CRLink ,
                               bs.CRScore ,
                               bs.PreSaleAnnouncement ,
                               bs.PriceCap ,
                               bs.IsPreviousDTVehicle ,
                               bs.IsDTInspectionRequested ,
                               bs.IsDecommissioned ,
                               bs.IsDecommissionedDateTime ,
                               bs.KBBMultiplier ,
                               bs.KBBDTAdjustmentValue ,
                               bs.MMRValue ,
                               bs.BuyStrategyID ,
                               bs.Images,
                               bs.IsAccuCheckIssue,
                               bs.IsAccuCheckIssueDateTime
                        FROM   dbo.tblBuyStage bs
                               INNER JOIN dbo.tblBuyVehicle bv ON bv.VIN = bs.VIN
                               LEFT JOIN dbo.tblBuyAuctionListType balt ON bs.AuctionName = balt.AuctionListKey
                               LEFT JOIN dbo.tblBuyAuctionVehicle bav ON bav.BuyVehicleID = bv.BuyVehicleID
                                                                         AND bav.SaleDate = bs.SaleDate
                                                                         AND bav.BuyAuctionListTypeID = balt.BuyAuctionListTypeID
                        WHERE  bav.BuyAuctionVehicleID IS NULL
                               AND balt.BuyAuctionListTypeID IS NOT NULL;


            ----UPDATE COLUMN CHANGES TO TBLBUYAUCTIONVEHICLE

            UPDATE bav
            SET    bav.RowUpdatedDateTime = SYSDATETIME() ,
                   bav.Lane = bs.Lane ,
                   bav.Run = bs.Run ,
                   bav.Odometer = bs.Odometer ,
                   bav.SellerName = bs.SellerName ,
                   bav.VehicleLink = bs.VehicleLink ,
                   bav.CRLink = bs.CRLink ,
                   bav.CRScore = bs.CRScore ,
                   bav.PreSaleAnnouncement = bs.PreSaleAnnouncement ,
                   bav.PriceCap = bs.PriceCap ,
                   bav.IsPreviousDTVehicle = bs.IsPreviousDTVehicle ,
                   bav.IsDTInspectionRequested = CASE WHEN bav.IsDTInspectionRequested = 1 THEN
                                                          1
                                                      ELSE
                                                          bs.IsDTInspectionRequested
                                                 END ,
                   bav.IsDecommissioned = bs.IsDecommissioned ,
                   bav.IsDecommissionedDateTime = bs.IsDecommissionedDateTime ,
                   bav.KBBMultiplier = bs.KBBMultiplier ,
                   bav.KBBDTAdjustmentValue = bs.KBBDTAdjustmentValue ,
                   bav.MMRValue = bs.MMRValue ,
                   bav.BuyStrategyID = bs.BuyStrategyID ,
                   bav.Images = bs.Images,
                   bav.IsAccuCheckIssue = bs.IsAccuCheckIssue,
                   bav.IsAccuCheckIssueDateTime = bs.IsAccuCheckIssueDateTime
            --Select *
            FROM   dbo.tblBuyAuctionVehicle bav
                   INNER JOIN dbo.tblBuyVehicle bv ON bv.BuyVehicleID = bav.BuyVehicleID
                   INNER JOIN dbo.tblBuyStage bs ON bs.VIN = bv.VIN
                                                    AND bs.SaleDate = bav.SaleDate
            WHERE  COALESCE(bav.Lane, '') <> COALESCE(bs.Lane, '')
                   OR COALESCE(bav.Run, '') <> COALESCE(bs.Run, '')
                   OR COALESCE(bav.Odometer, 0) <> COALESCE(bs.Odometer, 0)
                   OR COALESCE(bav.SellerName, '') <> COALESCE(bs.SellerName, '')
                   OR COALESCE(bav.VehicleLink, '') <> COALESCE(bs.VehicleLink, '')
                   OR COALESCE(bav.CRLink, '') <> COALESCE(bs.CRLink, '')
                   OR COALESCE(bav.CRScore, '') <> COALESCE(bs.CRScore, '')
                   OR COALESCE(bav.PreSaleAnnouncement, '') <> COALESCE(bs.PreSaleAnnouncement, '')
                   OR COALESCE(bav.PriceCap, 0) <> COALESCE(bs.PriceCap, 0)
                   OR COALESCE(bav.IsPreviousDTVehicle, '') <> COALESCE(bs.IsPreviousDTVehicle, '')
                   OR COALESCE(bav.IsDTInspectionRequested, '') <> COALESCE(CASE WHEN bav.IsDTInspectionRequested = 1 THEN
                                                                                     1
                                                                                 ELSE
                                                                                     bs.IsDTInspectionRequested
                                                                            END, '')
                   OR COALESCE(bav.IsDecommissioned, '') <> COALESCE(bs.IsDecommissioned, '')
                   OR COALESCE(bav.IsDecommissionedDateTime, '') <> COALESCE(bs.IsDecommissionedDateTime, '')
                   OR COALESCE(bav.KBBMultiplier, 0) <> COALESCE(bs.KBBMultiplier, 0)
                   OR COALESCE(bav.KBBDTAdjustmentValue, 0) <> COALESCE(bs.KBBDTAdjustmentValue, 0)
                   OR COALESCE(bav.MMRValue, 0) <> COALESCE(bs.MMRValue, 0)
                   OR COALESCE(bav.BuyStrategyID, 0) <> COALESCE(bs.BuyStrategyID, 0)
                   OR COALESCE(bav.Images, '') <> COALESCE(bs.Images, '')
                   OR COALESCE(bav.IsAccuCheckIssue, '') <> COALESCE(bs.IsAccuCheckIssue, '')
                   OR COALESCE(bav.IsAccuCheckIssueDateTime,'') <> COALESCE(bs.IsAccuCheckIssueDateTime,'') ;

            ----INSERT AIM INSPECTIONS INTO TBLBUYINSPECTION
            INSERT INTO dbo.tblBuyInspection (   BuyInspectionTypeID ,
                                                 BuyVehicleID ,
                                                 BuyInspectionFailReasonTypeID ,
                                                 RowLoadedDateTime ,
                                                 RowUpdatedDateTime ,
                                                 LastChangedByEmpID ,
                                                 -- ManualBookValue ,
                                                 -- KBBValue ,
                                                 InspectionLatitude ,
                                                 InspectionLongitude ,
                                                 InspectionNotes ,
                                                 IsVehicleNotFound ,
                                                 EstimatedReconTireGlass ,
                                                 EstimatedReconExteriorCosmetic ,
                                                 EstimatedReconInterior ,
                                                 EstimatedReconOther ,
                                                 EstimatedReconTotal ,
                                                 DashboardLights ,
                                                 IsDTPreferred ,
                                                 IsInspectionFailed ,
                                                 InspectorName ,
                                                 InspectorEmail ,
                                                 InspectorEmployeeID ,
                                                 InspectionDateTime ,
                                                 IsDeleted
                                             )
                        SELECT 1 ,
                               bv.BuyVehicleID ,
                               0 ,
                               SYSDATETIME() ,
                               SYSDATETIME() ,
                               NULL ,
                               --,bs.ManualBookValue
                               --,bs.KBBValue
                               bs.InspectionLatitude ,
                               bs.InspectionLongitude ,
                               bs.InspectionNotes ,
                               0 ,
                               bs.EstimatedReconTireGlass ,
                               bs.EstimatedReconExteriorCosmetic ,
                               bs.EstimatedReconInterior ,
                               bs.EstimatedReconOther ,
                               bs.EstimatedReconTotal ,
                               bs.DashboardLights ,
                               bs.IsDTPreferred ,
                               bs.IsInspectionFailed ,
                               bs.InspectorName ,
                               bs.InspectorEmail ,
                               bs.InspectorEmployeeID ,
                               bs.InspectionDateTime ,
                               0
                        FROM   dbo.tblBuyStage bs
                               INNER JOIN dbo.tblBuyVehicle bv ON bv.VIN = bs.VIN
                               LEFT JOIN dbo.tblBuyInspection bi ON bv.BuyVehicleID = bi.BuyVehicleID
                                                                    AND bi.InspectionDateTime = bs.InspectionDateTime
                                                                    AND bi.BuyInspectionTypeID = 1
                        WHERE  bi.BuyInspectionID IS NULL
                               AND bs.IsAIMInspection = 1; --AND bs.InspectionDateTime IS NOT NULL

            ----UPDATE CHANGES TO TBLBUYINSPECTION

            UPDATE bi
            SET    bi.RowUpdatedDateTime = SYSDATETIME() ,
                   --bi.ManualBookValue = CASE WHEN (COALESCE(bi.ManualBookValue, 0) <> COALESCE(bs.ManualBookValue,0)
                   --                          AND bi.ManualBookValue = 0) 
                   --			  THEN bs.ManualBookValue
                   --                          ELSE COALESCE(bi.ManualBookValue, 0) 
                   --			  END,
                   --bi.KBBValue = bs.KBBValue,
                   bi.InspectionNotes = bs.InspectionNotes ,
                   bi.EstimatedReconTireGlass = bs.EstimatedReconTireGlass ,
                   bi.EstimatedReconExteriorCosmetic = bs.EstimatedReconExteriorCosmetic ,
                   bi.EstimatedReconInterior = bs.EstimatedReconInterior ,
                   bi.EstimatedReconOther = bs.EstimatedReconOther ,
                   bi.EstimatedReconTotal = CASE WHEN COALESCE(bi.EstimatedReconTotal, 0) <> COALESCE(bs.EstimatedReconTotal, 0)
                                                      AND bi.BuyInspectionTypeID = 1 THEN
                                                     bs.EstimatedReconTotal
                                                 ELSE
                                                     COALESCE(bi.EstimatedReconTotal, 0)
                                            END ,
                   bi.DashboardLights = bs.DashboardLights ,
                   bi.IsDTPreferred = bs.IsDTPreferred ,
                   bi.IsInspectionFailed = bs.IsInspectionFailed ,
                   bi.InspectionDateTime = bs.InspectionDateTime

            --Select bi.InspectionDateTime, bs.InspectionDateTIme,*
            FROM   dbo.tblBuyInspection bi
                   INNER JOIN dbo.tblBuyVehicle bv ON bv.BuyVehicleID = bi.BuyVehicleID
                   INNER JOIN dbo.tblBuyStage bs ON bs.VIN = bv.VIN
            WHERE  ( --(COALESCE(bi.ManualBookValue, 0) <> COALESCE(bi.ManualBookValue, 0) AND bi.ManualBookValue = 0)
                       --OR COALESCE(bi.KBBValue, 0) <> COALESCE(bs.KBBValue, 0)
                       COALESCE(bi.InspectionNotes, '') <> COALESCE(bs.InspectionNotes, '')
                       OR COALESCE(bi.EstimatedReconTireGlass, 0) <> COALESCE(bs.EstimatedReconTireGlass, 0)
                       OR COALESCE(bi.EstimatedReconExteriorCosmetic, 0) <> COALESCE(bs.EstimatedReconTireGlass, 0)
                       OR COALESCE(bi.EstimatedReconInterior, 0) <> COALESCE(bs.EstimatedReconInterior, 0)
                       OR COALESCE(bi.EstimatedReconOther, 0) <> COALESCE(bs.EstimatedReconOther, 0)
                       OR (   COALESCE(bi.EstimatedReconTotal, 0) <> COALESCE(bs.EstimatedReconTotal, 0)
                              AND bi.BuyInspectionTypeID = 1
                          )
                       OR COALESCE(bi.DashboardLights, '') <> COALESCE(bs.DashboardLights, '')
                       OR COALESCE(bi.IsDTPreferred, '') <> COALESCE(bs.IsDTPreferred, '')
                       OR COALESCE(bi.IsInspectionFailed, '') <> COALESCE(bs.IsInspectionFailed, '')
                       OR COALESCE(bi.InspectionDateTime, '') <> COALESCE(bs.InspectionDateTime, '')
                   )
                   AND bi.BuyInspectionTypeID = 1;


            --INSERT AIM DECODES INTO TBLBUYDECODE

            INSERT INTO dbo.tblBuyDecode (   BuyDecodeTypeID ,
                                             BuyVehicleID ,
                                             RowLoadedDateTime ,
                                             RowUpdatedDateTime ,
                                             LastChangedByEmpID ,
                                             DecodeDateTime ,
                                             DecodeAmount ,
                                             DecodedBy ,
                                             DecodedByEmail ,
                                             DecodedByEmployeeID ,
                                             IsDeleted
                                         )
                        SELECT 1 ,
                               bv.BuyVehicleID ,
                               SYSDATETIME() ,
                               SYSDATETIME() ,
                               NULL ,
                               bs.InspectionDateTime ,
                               bs.ManualBookValue ,
                               bs.InspectorName ,
                               bs.InspectorEmail ,
                               bs.InspectorEmployeeID ,
                               0
                        FROM   dbo.tblBuyStage bs
                               INNER JOIN dbo.tblBuyVehicle bv ON bs.VIN = bv.VIN
                               LEFT JOIN dbo.tblBuyDecode bd ON bd.BuyVehicleID = bv.BuyVehicleID
                                                                AND bs.InspectionDateTime = bd.DecodeDateTime
                                                                AND bd.BuyDecodeTypeID = 1
                        WHERE  bd.BuyDecodeID IS NULL
                               AND bs.IsAIMInspection = 1;


            ----UPDATE CHANGES TO TBLBUYDECODE

            UPDATE bd
            SET    bd.RowUpdatedDateTime = SYSDATETIME() ,
                   bd.DecodeDateTime = bs.InspectionDateTime ,
                   bd.DecodeAmount = bs.ManualBookValue ,
                   bd.DecodedBy = bs.InspectorName ,
                   bd.DecodedByEmail = bs.InspectorEmail ,
                   bd.DecodedByEmployeeID = bs.InspectorEmployeeID

            --Select bd.DecodeDateTime, bd.DecodeDateTime,*
            FROM   dbo.tblBuyDecode bd
                   INNER JOIN dbo.tblBuyVehicle bv ON bv.BuyVehicleID = bd.BuyVehicleID
                   INNER JOIN dbo.tblBuyStage bs ON bs.VIN = bv.VIN
            WHERE  (   COALESCE(bd.DecodeDateTime, '') <> COALESCE(bs.InspectionDateTime, '')
                       OR COALESCE(bd.DecodeAmount, 0) <> COALESCE(bs.ManualBookValue, 0)
                       OR COALESCE(bd.DecodedBy, '') <> COALESCE(bs.InspectorName, '')
                       OR COALESCE(bd.DecodedByEmail, '') <> COALESCE(bs.InspectorEmail, '')
                       OR COALESCE(bd.DecodedByEmployeeID, '') <> COALESCE(bs.InspectorEmployeeID, '')
                   )
                   AND bd.BuyDecodeTypeID = 1;

        END TRY

        /*------------------------------------------------------
Special catch logic only good for SELECT type procedures
Because it does not contain rollback code.
------------------------------------------------------*/
        BEGIN CATCH
            DECLARE @ErrorNumber INT ,
                    @ErrorSeverity INT ,
                    @ErrorState INT ,
                    @ErrorLine INT ,
                    @ErrorProcedure NVARCHAR(200) ,
                    @ErrorMessage VARCHAR(4000);

            -- Assign variables to error-handling functions that capture information for RAISERROR.
            SELECT @ErrorNumber = ERROR_NUMBER() ,
                   @ErrorSeverity = ERROR_SEVERITY() ,
                   @ErrorState = ERROR_STATE() ,
                   @ErrorLine = ERROR_LINE() ,
                   @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');

            -- Building the message string that will contain original error information.
            SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, '
                                   + 'Message: ' + ERROR_MESSAGE();

            -- Use RAISERROR inside the CATCH block to return error
            -- information about the original error that caused
            -- execution to jump to the CATCH block.
            RAISERROR(   @ErrorMessage ,  -- Message text.
                         16 ,             -- must be 16 for Informatica to pick it up
                         1,
                         @ErrorNumber ,
                         @ErrorSeverity , -- Severity.
                         @ErrorState ,    -- State.
                         @ErrorProcedure,
                         @ErrorLine
                     );

            -- Return a negative number so that if the calling code is using a LINK server, it will
            -- be able to test that the procedure failed.  Without this, there are some lower type of 
            -- errors that do not show up across the LINK as an error.  This causes ProcessControl 
            -- in particular to not see that the procedure failed which is bad.
            RETURN -1;

        END CATCH;
    END;






