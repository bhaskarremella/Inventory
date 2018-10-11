
   CREATE   PROCEDURE [presale].[stpPurgePresaleManheimFeed]
   (
      @TurnLoggingOn TINYINT = 0
   )
   /*----------------------------------------------------------------------------------------
   Created By :   Daniel Folz
   Created On :   Jul 27, 2018
   Application:   Called by SQLPRODPC\PROCESSCONTROL SQL Agent Job
                  _InventoryDM - Presale_stpPurgePresaleManheimFeed
   Description:   Process to purge IsDeleted Presale Manheim Feed records from
                  SQLPRODDM\DATAMART.InventoryDM.presale.tblManheimFeed.  This first requires
                  Image records to be removed, followed by the Feed record.  Since the 
                  VIN was indexed, elements of the VIN were used to create small randomly
                  sized datasets indicating which rows are deleted at one time.  There is
                  a one second delay between each deletion set.  This logic was enlisted
                  to prevent blocking to other applications needing access to the data.
                  In addition to purging IsDeleted = 1 records, also purge IsDeleted = 0 and
                  SaleDate has passed by more than a month.
   ------------------------------------------------------------------------------------------
   */
   AS
   BEGIN

      --Set Enviornment
      SET NOCOUNT, XACT_ABORT ON;
      DECLARE @ID                INTEGER
      DECLARE @PartitionRID      CHAR(1)
      DECLARE @PartitionMLID     CHAR(1)
      DECLARE @PartitionMRID     CHAR(1)
      DECLARE @PartitionLID      CHAR(1)
      DECLARE @Count             INTEGER
      DECLARE @StatusMsg         VARCHAR(1000)

      --Truncate the working table to reseed the identity field
      TRUNCATE TABLE presale.tblPurgePresaleManheimFeed

      --Populate the working table
      INSERT presale.tblPurgePresaleManheimFeed (PartitionRID, PartitionMLID, PartitionMRID, PartitionLID, [Count])
      SELECT
         p.PartitionRID
      ,  p.PartitionMLID
      ,  p.PartitionMRID
      ,  p.PartitionLID
      ,  [Count]        = COUNT(1)
      FROM
         presale.tblManheimFeed f WITH (NOLOCK)
      CROSS APPLY
      (
         SELECT 
            PartitionRID   = RIGHT(VIN, 1)
         ,  PartitionMLID  = LEFT(RIGHT(VIN, 8), 1)
         ,  PartitionMRID  = RIGHT(LEFT(VIN, 8), 1)
         ,  PartitionLID   = LEFT(VIN, 1)
      ) p
      WHERE
         f.IsDeleted = 1
      OR f.SaleDate < CAST(DATEADD(MONTH, -1, GETDATE()) AS DATE)
      GROUP BY
         p.PartitionRID
      ,  p.PartitionMLID
      ,  p.PartitionMRID
      ,  p.PartitionLID

      --Cursor through the selection and perform the deletion of records.
      DECLARE cur CURSOR FOR 
      SELECT
         PurgePresaleManheimFeedID
      ,  PartitionRID
      ,  PartitionMLID
      ,  PartitionMRID
      ,  PartitionLID
      ,  [Count]
      FROM
         presale.tblPurgePresaleManheimFeed
      ORDER BY
         PurgePresaleManheimFeedID

      OPEN cur

      FETCH NEXT FROM cur INTO @ID, @PartitionRID, @PartitionMLID, @PartitionMRID, @PartitionLID, @Count

         WHILE @@FETCH_STATUS = 0
         BEGIN
            BEGIN TRY
               BEGIN TRANSACTION

                  --Identify and delete presale.tblManheimFeedImages associated with the ListingID in records being deleted.
                  DELETE
                     i
                  FROM
                        presale.tblManheimFeed        f WITH (NOLOCK)
                  JOIN  presale.tblManheimFeedImage   i WITH (ROWLOCK)  ON f.ListingID = i.ListingID
                  CROSS APPLY
                  (
                     SELECT 
                        PartitionRID   = RIGHT(VIN, 1)
                     ,  PartitionMLID  = LEFT(RIGHT(VIN, 8), 1)
                     ,  PartitionMRID  = RIGHT(LEFT(VIN, 8), 1)
                     ,  PartitionLID   = LEFT(VIN, 1)
                  ) p
                  WHERE
                  ( 
                        f.IsDeleted       = 1
                     OR f.SaleDate < CAST(DATEADD(MONTH, -1, GETDATE()) AS DATE)
                  )   
                  AND   p.PartitionRID    = @PartitionRID
                  AND   p.PartitionMLID   = @PartitionMLID
                  AND   p.PartitionMRID   = @PartitionMRID
                  AND   p.PartitionLID    = @PartitionLID


                  DELETE
                     f
                  FROM
                     presale.tblManheimFeed f WITH (ROWLOCK)
                  CROSS APPLY
                  (
                     SELECT 
                        PartitionRID   = RIGHT(VIN, 1)
                     ,  PartitionMLID  = LEFT(RIGHT(VIN, 8), 1)
                     ,  PartitionMRID  = RIGHT(LEFT(VIN, 8), 1)
                     ,  PartitionLID   = LEFT(VIN, 1)
                  ) p
                  WHERE
                  ( 
                        f.IsDeleted       = 1
                     OR f.SaleDate < CAST(DATEADD(MONTH, -1, GETDATE()) AS DATE)
                  )   
                  AND   p.PartitionRID    = @PartitionRID
                  AND   p.PartitionMLID   = @PartitionMLID
                  AND   p.PartitionMRID   = @PartitionMRID
                  AND   p.PartitionLID    = @PartitionLID

               COMMIT TRANSACTION
   
               IF @TurnLoggingOn = 1
               BEGIN
                  SET @StatusMsg = CAST(@Count AS VARCHAR(10)) + ' Row(s) Deleted. ' + CAST((SELECT [Count] = SUM([Count]) FROM presale.tblPurgePresaleManheimFeed c WHERE c.PurgePresaleManheimFeedID > @ID) AS VARCHAR(10)) + ' Row(s) remaining.' 
                  RAISERROR(@StatusMsg, 10, 1) WITH NOWAIT;
               END;

            END TRY
            BEGIN CATCH
               IF @@ERROR != 0
               BEGIN
                  DECLARE @ErrorMessage   VARCHAR(300)   = ERROR_MESSAGE();
                  DECLARE @ErrorSeverity  SMALLINT       = ERROR_SEVERITY();
                  DECLARE @ErrorState     SMALLINT       = ERROR_STATE();
                  SELECT
                     ErrorNumber    = ERROR_NUMBER()
                  ,  ErrorMessage   = @ErrorMessage
                  ,  ErrorSeverity  = @ErrorSeverity
                  ,  ErrorState     = @ErrorState
                  ,  ErrorProcedure = ISNULL(ERROR_PROCEDURE(), 'Manheim Feed IsDelete Purge')
                  ,  ErrorLine      = ERROR_LINE();
               END;

               IF @@TRANCOUNT > 0
                  ROLLBACK TRANSACTION;

               RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
            END CATCH

            --Provide a 1 second delay between random delete segments so the CPU is not hogged.
            WAITFOR DELAY '00:00:00.1'; 

            FETCH NEXT FROM cur INTO @ID, @PartitionRID, @PartitionMLID, @PartitionMRID, @PartitionLID, @Count
         END 

      CLOSE cur
      DEALLOCATE cur

   END
