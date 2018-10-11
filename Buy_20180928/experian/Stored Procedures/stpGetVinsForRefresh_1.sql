


CREATE PROCEDURE [experian].[stpGetVinsForRefresh] 
@MinAccuCheckDate DATETIME,
@MaxSaleDate DATE

/*----------------------------------------------------------------------------------------
Created By  : Jeremy Johnson/Gwen Lukemire
Created On  : 01/18/2018
Application : Accucheck
Description : Identify the vehicles that need to have Experian Accucheck pulled for the
              first time, or have it pulled again

Updated By  : Gwendolyn Lukemire
Update On   : 2/09/2018
Description : Added logic to also pick up vehicles whose sale date is today
              Modified logic to check the RowUpdateDateTime is the last X hours instead
              of the RowLoadedDateTime, as the table gets updated instead of inserted
------------------------------------------------------------------------------------------*/
AS
   BEGIN
        BEGIN TRY;

   ;WITH VINs AS (
   SELECT bv.VIN, acc.RowLoadedDateTime, acc.RowUpdatedDateTime, bav.SaleDate
	FROM dbo.tblBuyVehicle bv				   WITH (NOLOCK)
	JOIN dbo.tblBuyAuctionVehicle bav		WITH (NOLOCK) ON bv.BuyVehicleID = bav.BuyVehicleID
                                                         AND bav.SaleDate <= @MaxSaleDate
                                                         AND bav.SaleDate >= CAST(SYSDATETIME() AS DATE)
                                                         AND bav.IsDecommissioned <> 1
	   LEFT JOIN experian.tblAccuCheck acc		WITH (NOLOCK) ON bv.VIN = acc.VINDecodeVIN	

   )
   SELECT VINs.VIN
   FROM VINs
   WHERE VINs.RowUpdatedDateTime <= @MinAccuCheckDate
   OR VINs.RowLoadedDateTime IS NULL
   OR VINs.SaleDate = CAST(SYSDATETIME() AS DATE);
	
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
            SELECT  @ErrorNumber = ERROR_NUMBER() ,
                    @ErrorSeverity = ERROR_SEVERITY() ,
                    @ErrorState = ERROR_STATE() ,
                    @ErrorLine = ERROR_LINE() ,
                    @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');

    -- Building the message string that will contain original error information.
            SELECT  @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, '
                    + 'Message: ' + ERROR_MESSAGE();

    -- Use RAISERROR inside the CATCH block to return error
    -- information about the original error that caused
    -- execution to jump to the CATCH block.
            RAISERROR (@ErrorMessage, -- Message text.
               16,  -- must be 16 for Informatica to pick it up
               1,
               @ErrorNumber,
               @ErrorSeverity, -- Severity.
               @ErrorState, -- State.
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

