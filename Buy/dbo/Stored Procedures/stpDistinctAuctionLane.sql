





CREATE PROCEDURE [dbo].[stpDistinctAuctionLane]
    (
        @SaleDateStart DATE ,
        @SaleDateEnd DATE
    )

/*----------------------------------------------------------------------------------------
Created By  : Viv shah
Created On  : March 05 2018

UPDATED By  : Travis Bleile
UPDATED On  : 3/27/18
Description	: Adding commented out accucheck logic in #AllInspectionsFailed and including isactive flag on auctionlisttypetable in queries
------------------------------------------------------------------------------------------
*/
WITH RECOMPILE
AS
    BEGIN;
        BEGIN TRY;



            ----DECLARE @SaleDateStart DATE 
            ----DECLARE @SaleDateEnd DATE

            DECLARE @SaleDateStartVariable DATE;
            DECLARE @SaleDateEndVariable DATE;

            SET @SaleDateStartVariable = @SaleDateStart;
            SET @SaleDateEndVariable = @SaleDateEnd;

            IF @SaleDateStartVariable IS NULL
                SELECT @SaleDateStartVariable = DATEADD(
                                                           DAY ,
                                                           -3,
                                                           CAST(GETDATE() AS DATE)
                                                       );

            IF @SaleDateEndVariable IS NULL
                SELECT @SaleDateEndVariable = DATEADD(
                                                         DAY ,
                                                         14 ,
                                                         CAST(GETDATE() AS DATE)
                                                     );

            --Give me all of the distinct auction/saledate/lane combinations that only have failed inspections in them

            IF OBJECT_ID('tempdb.dbo.#AllInspectionsFailed') IS NOT NULL
                DROP TABLE #AllInspectionsFailed;
            SELECT   DISTINCT CONCAT(balt.AuctionListKey, bav.SaleDate, Lane) AS aifkey
            INTO     #AllInspectionsFailed
            FROM     dbo.tblBuyAuctionVehicle bav
                     INNER JOIN dbo.tblBuyAuctionListType balt ON balt.BuyAuctionListTypeID = bav.BuyAuctionListTypeID
                     LEFT JOIN dbo.tblBuyInspection bi ON bi.BuyVehicleID = bav.BuyVehicleID
            WHERE    bav.SaleDate >= @SaleDateStartVariable
                     AND balt.IsActive = 1
            GROUP BY balt.AuctionListKey ,
                     bav.SaleDate ,
                     Lane
            HAVING   COUNT(*) = SUM(   CASE WHEN bi.IsInspectionFailed = 1 THEN
                                                1
                                            ELSE 0
                                       END
                                   ) -- When every vehicle in that lane = the number of failed inspections in that lane.
            --			OR COUNT(*) = SUM(   CASE
            --                           WHEN bav.IsAccuCheckIssue = 1 THEN
            --                               1
            --                           ELSE
            --                               0
            --                        END
            --                    ) -- When every vehicle in that lane = the number of AccuCheck Issues in that lane.
			;  


            SELECT DISTINCT alt.AuctionListKey ,
                   BAV.SaleDate ,
                   BAV.Lane ,
                   aht.AuctionHouseKey
            FROM   dbo.tblBuyAuctionVehicle BAV
                   INNER JOIN dbo.tblBuyAuctionListType alt WITH ( NOLOCK ) ON alt.BuyAuctionListTypeID = BAV.BuyAuctionListTypeID
                   INNER JOIN dbo.tblBuyAuctionHouseType aht WITH ( NOLOCK ) ON aht.BuyAuctionHouseTypeID = alt.BuyAuctionHouseTypeID
                   LEFT JOIN #AllInspectionsFailed aif WITH ( NOLOCK ) ON CONCAT(
                                                                                    alt.AuctionListKey ,
                                                                                    BAV.SaleDate,
                                                                                    BAV.Lane
                                                                                ) = aif.aifkey
            WHERE  BAV.SaleDate >= @SaleDateStartVariable
                   AND BAV.SaleDate < @SaleDateEndVariable
                   AND (   BAV.IsDecommissionedDateTime >= BAV.SaleDate
                           OR BAV.IsDecommissioned = 0
                       )
                   AND aif.aifkey IS NULL --Filter out lanes with only failed inspections in them
                   AND alt.IsActive = 1;


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






