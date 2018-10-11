




CREATE PROCEDURE [dbo].[stpLoadBuyAuctionInspectionCheckboxData]
/*----------------------------------------------------------------------------------------
Created By  : Travis Bleile
Created On  : 10/4/2018
Description : ETL for Checkbox data to final table
------------------------------------------------------------------------------------------
*/
AS
BEGIN
BEGIN TRY
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED



------------------Soft Delete


    UPDATE  F
    SET     IsDeleted = 1 ,
            RowUpdatedDateTime = GETDATE()
 --SELECT F.ResponseID,S.ResponseID,*
    FROM    dbo.tblBuyAuctionInspectionCheckboxData F
            JOIN dbo.tblBuyAuctionInspectionCheckboxDataStage S ON F.VIN = S.VIN AND F.ResponseID <> S.ResponseID --AND s.ResponseID IS NOT NULL --F.Category = S.Category AND S.Question = F.Question
                                  
    WHERE   F.VIN IS NOT NULL --AND F.IsDeleted <> 1
	----AND f.VIN = 'WBAPK53529A643659'


--------------Insert 


INSERT INTO dbo.tblBuyAuctionInspectionCheckboxData
        ( VIN ,
          Category ,
          Question ,
          Answer ,
          RepairEstimate ,
          SurveyCompletedBy ,
          CheckboxSurveyStartDT ,
          CheckboxSurveyEndDT ,
		  ResponseID ,
		  AnswerID
        )


SELECT 
       S.VIN ,
       S.Category ,
       S.Question ,
       S.Answer ,
       S.RepairEstimate ,
       S.SurveyCompletedBy ,
       S.CheckboxSurveyStartDT ,
       S.CheckboxSurveyEndDT ,
	   S.ResponseID ,
	   S.AnswerID
 FROM dbo.tblBuyAuctionInspectionCheckboxDataStage S
 LEFT JOIN dbo.tblBuyAuctionInspectionCheckboxData F ON F.VIN = S.VIN AND F.ResponseID = S.ResponseID
 WHERE F.Vin IS NULL 
	


 
----------------Update

 
    UPDATE  F
	      SET F.Category = S.Category
		  , F.Question = S.Question
		  , F.Answer = S.Answer
		  , F.RepairEstimate = S.RepairEstimate
		  , F.RowUpdatedDateTime = GETDATE()

--SELECT *
    FROM    dbo.tblBuyAuctionInspectionCheckboxData F
            JOIN dbo.tblBuyAuctionInspectionCheckboxDataStage S ON F.VIN = S.VIN AND F.AnswerID = S.AnswerID 
			------AND ( s.vin not in (
			------			'1B3LC46KX8N663631',
			------			'1FAHP281X6G132180',
			------			'1FMCU0EG0AKC43428',
			------			'1N4AL21E58N425560',
			------			'1NXBR32EX8Z008213',
			------			'2C3CA5CV4AH201402',
			------			'2FMDK4KC5BBA77633',
			------			'2FMGK5DC8BBD02711',
			------			'2G1WG5E30D1161814')) 
						 ----F.Category = S.Category AND S.Question = F.Question

    WHERE   COALESCE(F.Category, '') <> COALESCE(S.Category, '')				OR 
			COALESCE(F.Question, '') <> COALESCE(S.Question, '')				OR
			COALESCE(F.Answer, '') <> COALESCE(S.Answer, '')					OR
			COALESCE(F.RepairEstimate, 0) <> COALESCE(S.RepairEstimate, 0)	

			
			






	
END TRY

/*------------------------------------------------------
Special catch logic only good for SELECT type procedures
Because it does not contain rollback code.
------------------------------------------------------*/
BEGIN CATCH
    DECLARE 
        @ErrorNumber     INT,
        @ErrorSeverity   INT,
        @ErrorState      INT,
        @ErrorLine       INT,
        @ErrorProcedure  NVARCHAR(200),
        @ErrorMessage    VARCHAR(4000)

    -- Assign variables to error-handling functions that capture information for RAISERROR.
    SELECT 
        @ErrorNumber = ERROR_NUMBER(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE(),
        @ErrorLine = ERROR_LINE(),
        @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');

    -- Building the message string that will contain original error information.
    SELECT @ErrorMessage = 
        N'Error %d, Level %d, State %d, Procedure %s, Line %d, ' + 
            'Message: '+ ERROR_MESSAGE();

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
END CATCH
END



