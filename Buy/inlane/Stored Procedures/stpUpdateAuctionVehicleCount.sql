
CREATE procedure [inlane].[stpUpdateAuctionVehicleCount]
/*----------------------------------------------------------------------------------------
Created By  : Lisa Aguilera
Created On  :2016-10-27
Application : InLaneBuy
Description : Update Auctions in tblAuctionVehicleCount

EXEC inlane.stpUpdateAuctionVehicleCount
------------------------------------------------------------------------------------------
*/
AS
BEGIN;
SET NOCOUNT ON;

BEGIN TRY;
DECLARE @TranCount int;
      --<other declarations>

-- Get if the session is in transaction state yet or not
SET @TranCount = @@trancount;

-- Detect if the procedure was called from an active transaction and save that for later use. In the procedure, 
-- @TranCount = 0 means there was no active transaction and the procedure started one. @TranCount > 0 means 
-- an active transaction was started before the procedure was called.
IF @TranCount = 0
   -- No active transaction so begin one
   BEGIN TRAN;
ELSE
   -- Create a savepoint to be able to roll back only the work done in the procedure if there is an error
   SAVE TRANSACTION stpUpdateAuctionVehicleCount;

		/* INSERT NEW ROWS */
		INSERT INTO inlane.tblAuctionVehicleCount
		        ( AuctionID ,
		          AuctionName ,
		          AuctionNameShort ,
		          VehicleCount
		        )
		SELECT vavc.AuctionID ,
               vavc.AuctionName ,
               vavc.AuctionNameShort ,
               vavc.VehicleCount
		FROM inlane.vAuctionVehicleCount vavc
		LEFT JOIN inlane.tblAuctionVehicleCount avc ON avc.AuctionID = vavc.AuctionID
		WHERE avc.AuctionVehicleID IS NULL


		/* UPDATE EXISTING ROWS */
		UPDATE avc
		SET    
			 AuctionID = vavc.AuctionID
			 ,AuctionName = vavc.AuctionName
			 ,AuctionNameShort = vavc.AuctionNameShort
			 ,VehicleCount = vavc.VehicleCount
		FROM inlane.vAuctionVehicleCount vavc
		JOIN inlane.tblAuctionVehicleCount avc ON avc.AuctionID = vavc.AuctionID
		WHERE 
			(vavc.AuctionID <> avc.AuctionID
			OR vavc.AuctionName <> avc.AuctionName
			OR vavc.AuctionNameShort <> avc.AuctionNameShort
			OR vavc.VehicleCount <> avc.VehicleCount)


		/* MARK DELETED ROWS INACTIVE */
		UPDATE avc
			SET IsActive = 0
		FROM inlane.tblAuctionVehicleCount avc 
		LEFT JOIN inlane.vAuctionVehicleCount vavc ON avc.AuctionID = vavc.AuctionID
		WHERE vavc.AuctionID IS NULL

-- @TranCount = 0 means no transaction was started before the procedure was called.
-- The procedure must commit the transaction it started.
IF @TranCount = 0
   COMMIT;

END TRY

/*------------------------------------------------------
Special catch logic only good for CUD type procedures
Because it does contains rollback code.
------------------------------------------------------*/
BEGIN CATCH
    DECLARE 
        @ErrorNumber     INT,
        @ErrorSeverity   INT,
        @ErrorState      INT,
        @ErrorLine       INT,
        @ErrorProcedure  NVARCHAR(200),
        @ErrorMessage    VARCHAR(4000),
        @XactState       INT;

    -- Get the state of the existing transaction so we can tell what type of rollback needs to occur
    SET @XactState = XACT_STATE();

    -- @TranCount = 0 means no transaction was started before the procedure was called.
    -- The procedure must rollback the transaction it started.
    IF @TranCount = 0
       ROLLBACK;
    ELSE
       -- If the state of the transaction is stable, then rollback just the current save point work
       IF @XactState <> -1
            ROLLBACK TRANSACTION stpUpdateAuctionVehicleCount;

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
END CATCH;
END;
