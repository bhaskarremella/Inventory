

CREATE PROCEDURE [Presale].[stpDeletetblAdesaPresale]
AS

/*******************************************************************************************************
Created By: Viv Shah
CreateDate: 11/28/2016

Purpose: Deletes the rows at the end of the day that are in the Status = REMOVED. Called from the job in Repo that would run at .
		
			
*******************************************************************************************************/

BEGIN
    BEGIN TRY
        SET NOCOUNT ON;


        ----DELETE
        ----   FROM [buy].[Presale].[tblAdesaPreSale]
        ----  WHERE (Status = 'Removed' AND SaleDate <= (SELECT CAST(AsOfDate - 2 AS DATE) FROM ODS.Presale.tblCurrent_System_Information))
        ----  OR
        ----  (Status = 'Removed' AND IsDealerBlockVehicle IS NOT NULL AND CAST(RowLoadTimeStamp AS DATE) <= (SELECT CAST(AsOfDate - 2 AS DATE) FROM ODS.Presale.tblCurrent_System_Information))


        DELETE FROM [buy].[Presale].[tblAdesaPreSale]
        WHERE (Status = 'Removed');

    END TRY
    BEGIN CATCH
        DECLARE @ErrorNumber INT,
            @ErrorSeverity INT,
            @ErrorState INT,
            @ErrorLine INT,
            @ErrorProcedure NVARCHAR(200),
            @ErrorMessage VARCHAR(4000);

        -- Assign variables to error-handling functions that capture information for RAISERROR.
        SELECT @ErrorNumber = ERROR_NUMBER(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE(),
            @ErrorLine = ERROR_LINE(),
            @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');

        -- Building the message string that will contain original error information.
        SELECT @ErrorMessage
            = N'Error %d, Level %d, State %d, Procedure %s, Line %d, '
              + 'Message: ' + ERROR_MESSAGE();

        -- Use RAISERROR inside the CATCH block to return error
        -- information about the original error that caused
        -- execution to jump to the CATCH block.
        RAISERROR(@ErrorMessage, -- Message text.
            16,                  -- must be 16 for Informatica to pick it up
            1,
            @ErrorNumber,
            @ErrorSeverity,      -- Severity.
            @ErrorState,         -- State.
            @ErrorProcedure,
            @ErrorLine
                 );
    END CATCH;
END;




