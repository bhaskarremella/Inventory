
CREATE   PROCEDURE dbo.stpBuyDestinationPriority

/*********************************************************************************
Created By: Gwendolyn Lukemire
Created On: July 27, 2018
Description: This stored procedure does insert/update/delete logic using MERGE
			 to move records from a stage table to a final table for use by Buyonic		 	 
***********************************************************************************/

AS 

BEGIN
BEGIN TRY
SET NOCOUNT ON

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
            SAVE TRANSACTION stpBuyDestinationPriority; 

IF OBJECT_ID(N'tempdb..#DestinationMergeSource', N'U') IS NOT NULL BEGIN DROP TABLE #DestinationMergeSource END;

CREATE TABLE #DestinationMergeSource (BuyAuctionVehicleID BIGINT, VIN VARCHAR(17), AuctionName VARCHAR(50), SaleDate DATE, CRLLT INT, LocationPriority SMALLINT, IDNumber INT)

CREATE NONCLUSTERED INDEX idx_DestinationMergeSource_MergeColumns ON #DestinationMergeSource (VIN, AuctionName,SaleDate, CRLLT)

/*
	1. Create a temp table to use as a source
		a. Select from the stage, then do a cross apply to get the BAVID
	2. Perform the merge below
		a. Match on VIN/Auction/SaleDate
		b. Update if the CRLLT or Priority changed
		c. Insert if no match
		d. delete if target has it but source does not (this indicates that analytics removed it)

*/
INSERT #DestinationMergeSource
(
    BuyAuctionVehicleID,
    VIN,
    AuctionName,
    SaleDate,
    CRLLT,
    LocationPriority,
	IDNumber
)

SELECT 
       bav.BuyAuctionVehicleID,
       s.VIN,
       s.AuctionName,
       s.SaleDate,
       s.CRLLT,
       s.LocationPriority,
	   s.IDNumber 
FROM dbo.tblBuyDestinationPriorityStage s
CROSS APPLY (
				SELECT bav.BuyAuctionVehicleID
				FROM dbo.tblBuyVehicle bv
				JOIN dbo.tblBuyAuctionVehicle bav ON bav.BuyVehicleID = bv.BuyVehicleID
				JOIN dbo.tblBuyAuctionListType balt ON balt.BuyAuctionListTypeID = bav.BuyAuctionListTypeID
				WHERE s.SaleDate = bav.SaleDate
								AND s.VIN = bv.VIN
								AND s.AuctionName = balt.AuctionListKey
				
			)bav

			----SELECT * FROM #DestinationMergeSource WHERE VIN = '4T1BF1FK8FU916959'

			----SELECT dms.*, bdp.VIN, bdp.AuctionName, bdp.SaleDate, bdp.CRLLT, bdp.LocationPriority, bdp.IDNumber
			----FROM #DestinationMergeSource dms
			---- JOIN dbo.tblBuyDestinationPriority bdp ON bdp.VIN = dms.VIN
			----										AND bdp.AuctionName = dms.AuctionName
			----										AND bdp.SaleDate = dms.SaleDate
			----										AND bdp.CRLLT = dms.CRLLT
			----										AND bdp.LocationPriority = dms.LocationPriority

	
MERGE INTO dbo.tblBuyDestinationPriority AS tgt
USING #DestinationMergeSource AS src ON tgt.VIN			= src.VIN
									AND tgt.AuctionName = src.AuctionName
									AND tgt.SaleDate	= src.SaleDate
									AND tgt.CRLLT		= src.CRLLT
									--AND tgt.LocationPriority = src.LocationPriority
WHEN MATCHED AND tgt.LocationPriority <> src.LocationPriority
			 OR tgt.IDNumber <> src.IDNumber
THEN UPDATE SET tgt.LocationPriority = src.LocationPriority
			   ,tgt.IDNumber = src.IDNumber
			   ,tgt.RowUpdatedDateTime = SYSDATETIME()
WHEN NOT MATCHED BY SOURCE THEN DELETE 
WHEN NOT MATCHED THEN 	
INSERT (BuyAuctionVehicleID, VIN, AuctionName, SaleDate, CRLLT, LocationPriority, IDNumber)

VALUES (
	src.BuyAuctionVehicleID,
    src.VIN,
    src.AuctionName,
    src.SaleDate,
    src.CRLLT,
    src.LocationPriority,
	src.IDNumber
)
;

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
               ROLLBACK TRANSACTION stpBuyDestinationPriority;

         --Rethrow the error -- use throw in lieu of RAISERROR, the THROW behavior is needed for the .NET app
         THROW

         -- Return a negative number so that if the calling code is using a LINK server, it will
         -- be able to test that the procedure failed.  Without this, there are some lower type of 
         -- errors that do not show up across the LINK as an error.  This causes ProcessControl 
         -- in particular to not see that the procedure failed which is bad.
         RETURN -1;

      END CATCH;
   END;
