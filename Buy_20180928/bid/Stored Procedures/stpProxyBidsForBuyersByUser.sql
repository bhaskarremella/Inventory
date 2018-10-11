
   CREATE   PROCEDURE [bid].[stpProxyBidsForBuyersByUser]
   (
      @User  VARCHAR(250)
   )
   /*
      Created By:		Daniel Folz
      Created On:		05/21/2018
      Description:	Proxy Bid details - Specific to Buyers By User

      Sample Usage:
                     USE [Buy]
                     GO

                     EXEC	[bid].[stpProxyBidsForBuyersByUser] N'Brandon Forrest'
   */
   AS
   BEGIN

      BEGIN TRY

         --Set Environment
         SET NOCOUNT ON;
         SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

         ;
         WITH cteSummary
         AS
         (
            SELECT
               t.ProxyBidID
            ,  t.ProxyBidStagingId
            ,  t.AuctionID
            ,  t.Channel
            ,  t.VIN
            ,  t.FinalAmount
            ,  t.CustomerId
            ,  t.AccountNumber
            ,  t.RepName
            ,  t.RepNumber
            ,  t.[Status]
            ,  t.RowLoadedDateTime
            ,  t.RowUpdatedDateTime
            ,  t.ProxyBidPlaced
            ,  t.BidId
            ,  t.ProxyBidEnteredBy
            ,  t.BuyAuctionVehicleID
            ,  t.LastProxyBidRequestID
            ,  t.LastProxyBidAttemptID
            FROM
            (
               SELECT 
                  PB.ProxyBidID
               ,  PB.ProxyBidStagingId
               ,  PB.AuctionID
               ,  PB.Channel
               ,  PB.VIN
               ,  FinalAmount           = PB.Amount
               ,  PB.CustomerId
               ,  PB.AccountNumber
               ,  PB.RepName
               ,  PB.RepNumber
               ,  [Status]              = PBS.[Description]
               ,  PB.RowLoadedDateTime
               ,  PB.RowUpdatedDateTime
               ,  PB.ProxyBidPlaced
               ,  PB.BidId
               ,  PB.ProxyBidEnteredBy
               ,  PB.BuyAuctionVehicleID
               ,  LastProxyBidRequestID = LAST_VALUE(PBR.ProxyBidRequestID) OVER (ORDER BY PB.ProxyBidID DESC)
               ,  LastProxyBidAttemptID = LAST_VALUE(PBA.ProxyBidAttemptID) OVER (ORDER BY PB.ProxyBidID DESC)
               FROM
                           bid.tblProxyBid         PB  WITH (NOLOCK)  
               INNER JOIN  bid.tblProxyBidRequest  PBR WITH (NOLOCK)  ON   PB.ProxyBidID         = PBR.ProxyBidID
                                                                      AND  PB.ProxyBidEnteredBy  = @User
               INNER JOIN  bid.tblProxyBidAttempt  PBA WITH (NOLOCK)  ON   PBA.ProxyBidRequestID = PBR.ProxyBidRequestID
               INNER JOIN  bid.tblProxyBidStatus   PBS WITH (NOLOCK)  ON   PBS.ProxyBidStatusID  = PB.ProxyBidStatusID
            ) t
            GROUP BY
               t.ProxyBidID, t.ProxyBidStagingId, t.AuctionID, t.Channel, t.VIN, t.FinalAmount, t.CustomerId, t.AccountNumber, t.RepName, t.RepNumber, t.[Status], t.RowLoadedDateTime, t.RowUpdatedDateTime, t.ProxyBidPlaced, t.BidId, t.ProxyBidEnteredBy, t.BuyAuctionVehicleID, t.LastProxyBidRequestID, t.LastProxyBidAttemptID 
         )
         SELECT
            summ.ProxyBidID
         ,  summ.ProxyBidStagingId
         ,  summ.AuctionID
         ,  summ.Channel
         ,  summ.VIN
         ,  summ.FinalAmount
         ,  summ.CustomerId
         ,  summ.AccountNumber
         ,  summ.RepName
         ,  summ.RepNumber
         ,  summ.[Status]
         ,  summ.RowLoadedDateTime
         ,  summ.RowUpdatedDateTime
         ,  summ.ProxyBidPlaced
         ,  summ.BidId
         ,  summ.LastProxyBidRequestID
         ,  summ.LastProxyBidAttemptID
         ,  LastRequestType       = PBRT.[Description]
         ,  LastRequestSuccessful = PBR.CompletedSuccessfully
         ,  LastOutcomeError      = PBA.OutcomeErrorMessage
         ,  LastOutcomeStatus     = PBA.OutcomeStatusCode
         ,  LastOutcomeUrl        = PBA.BidUrl
         ,  ProxyBidOriginKey     = PBOT.ProxyBidOriginKey
         ,  ProxyBidEnteredBy     = summ.ProxyBidEnteredBy
         ,  BuyAuctionVehicleID   = summ.BuyAuctionVehicleID
         FROM
                     cteSummary                       summ
         INNER JOIN  Buy.bid.tblProxyBidRequest       PBR   WITH (NOLOCK) ON summ.LastProxyBidRequestID = PBR.ProxyBidRequestID
         INNER JOIN  Buy.bid.tblProxyBidAttempt       PBA   WITH (NOLOCK) ON summ.LastProxyBidAttemptID = PBA.ProxyBidAttemptID
         INNER JOIN  Buy.bid.tblProxyBidRequestType   PBRT  WITH (NOLOCK) ON PBRT.ProxyBidRequestTypeID = PBR.ProxyBidRequestTypeID
         INNER JOIN  Buy.bid.tblProxyBidOriginType    PBOT  WITH (NOLOCK) ON PBOT.ProxyBidOriginTypeID  = PBR.ProxyBidOriginTypeID
      END TRY
      BEGIN CATCH
      /*------------------------------------------------------
      Special catch logic only good for SELECT type procedures
      Because it does not contain rollback code.
      ------------------------------------------------------*/
          DECLARE 
              @ErrorNumber     INT,
              @ErrorSeverity   INT,
              @ErrorState      INT,
              @ErrorLine       INT,
              @ErrorProcedure  NVARCHAR(200),
              @ErrorMessage    VARCHAR(4000)

          -- Assign variables to error-handling functions that capture information for RAISERROR.
          SELECT 
              @ErrorNumber    = ERROR_NUMBER(),
              @ErrorSeverity  = ERROR_SEVERITY(),
              @ErrorState     = ERROR_STATE(),
              @ErrorLine      = ERROR_LINE(),
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

          -- Return a negative number so that if the calling code is using a LINK server, it will
          -- be able to test that the procedure failed.  Without this, there are some lower type of 
          -- errors that do not show up across the LINK as an error.  This causes ProcessControl 
          -- in particular to not see that the procedure failed which is bad.
          RETURN -1;

      END CATCH
   END;
