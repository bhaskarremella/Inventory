


CREATE PROCEDURE [dbo].[stpDistinctAuctionLaneForInspection]
(
@SaleDateStart DATE = NULL,
@SaleDateEnd DATE = NULL
)

/*----------------------------------------------------------------------------------------
Created By  : Viv shah
Created On  : Feb 28th 2018

Updated By	: Travis Bleile
Updated On	: 3/8/2018
Description	: Removing BETWEEN in where clause and updating with >= and <

Updated By	: Ian Beer
Updated On	: 3/9/2018
Description	: Removing BAV.IsDecommissionedInspectionDateTime >= BAV.SaleDate in where clause

Updated By  : Jason Barnes
Updated On	: 3/16/2018
Description : Filtered out CRCOMPLETED to exclude auction lanes only containing those vehicles

Updated By  : Travis Bleile
Updated On	: 3/27/2018
Description : Adding filter to only include IsActive auctions
------------------------------------------------------------------------------------------
*/
AS
    BEGIN;
        BEGIN TRY;

----DECLARE @SaleDateStart DATE 
----DECLARE @SaleDateEnd DATE
DECLARE @SaleDateStartVariable DATE 
DECLARE @SaleDateEndVariable DATE

SET @SaleDateStartVariable = @SaleDateStart
SET @SaleDateEndVariable = @SaleDateEnd

IF @SaleDateStartVariable IS NULL
SELECT @SaleDateStartVariable = CAST(GETDATE() AS DATE)

IF @SaleDateEndVariable IS NULL
SELECT @SaleDateEndVariable = DATEADD(DAY,14,CAST(GETDATE() AS DATE))

		

SELECT DISTINCT
    alt.AuctionListKey,
    bav.SaleDate,
    bav.Lane,
    aht.AuctionHouseKey
FROM dbo.tblBuyAuctionVehicle BAV
    INNER JOIN dbo.tblBuyAuctionListType alt			    WITH (NOLOCK)		        ON alt.BuyAuctionListTypeID = BAV.BuyAuctionListTypeID
    INNER JOIN dbo.tblBuyAuctionHouseType aht			    WITH (NOLOCK)				ON aht.BuyAuctionHouseTypeID = alt.BuyAuctionHouseTypeID
	LEFT JOIN dbo.tblBuyAuctionVehicleInspectionStatus sta  WITH (NOLOCK)				ON sta.BuyAuctionVehicleID = BAV.BuyAuctionVehicleID
WHERE BAV.SaleDate  >= @SaleDateStartVariable AND BAV.SaleDate < @SaleDateEndVariable
      AND BAV.IsDecommissionedInspection = 0
	  AND BAV.IsInspectorAppVehicle = 1
	  AND (sta.InspectionStatusKey IS NULL OR sta.InspectionStatusKey <> 'CRCOMPLETED' OR BAV.IsDTInspectionRequested = 1)
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







