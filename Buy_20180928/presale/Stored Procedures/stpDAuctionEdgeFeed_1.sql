
   CREATE   PROCEDURE [presale].[stpDAuctionEdgeFeed]
   (
      @VIN        VARCHAR(17)
   ,  @SaleDate   DATE
   )
   /*---------------------------------------------------------------------------------------------
   Created By  : Daniel Folz
   Created On  : Aug 15th 2018
   Application : Called by Auction Edge Application
   Description : Mark records for deletion from presale.tblAuctionEdgeFeed
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
            SAVE TRANSACTION stpDAuctionEdgeFeed;

         UPDATE
            a
         SET
            a.IsDeleted          = 1
         ,  a.RowUpdatedDateTime = SYSDATETIME()
         FROM
            presale.tblAuctionEdgeFeed a
         WHERE
               a.VIN       = @VIN
         AND   a.SaleDate  = @SaleDate

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
               ROLLBACK TRANSACTION stpDAuctionEdgeFeed;

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

