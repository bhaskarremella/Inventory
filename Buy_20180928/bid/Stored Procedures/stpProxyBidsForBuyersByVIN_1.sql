
   CREATE   PROCEDURE [bid].[stpProxyBidsForBuyersByVIN]
   (
      @VIN  NVARCHAR(MAX)
   )
   /*
      Created By:		Daniel Folz
      Created On:		05/21/2018
      Description:	Proxy Bid details - Specific to Buyers By VIN

	  Updated By:		Daniel Folz
      Updated On:		06/06/2018
      Description:	Returning additional column - auctionhousetypeid 

      Sample Execution:
                        USE [Buy]
                        GO

                        EXEC	[bid].[stpProxyBidsForBuyersByVIN] N'1W53ATN20GY005253,WBADK8301H9707201,1FDKE37G0KHA34616,JM1NA351XM0228499,JHMEH6260PS007742,JHMCD5650RC071288,1GCEC14Z3SZ158472,1FTJW35F5SEA66700,1FTCR10A4SUA17008,1G4HP52L1SH567837,1GCCS19Z1S8217656,WDBEA32E7SC242538'
   */
   AS
   BEGIN

      BEGIN TRY

         --Set Environment
         SET NOCOUNT ON;
         SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

         IF OBJECT_ID(N'tempdb..#VIN', N'U') IS NOT NULL BEGIN DROP TABLE #VIN END;
         CREATE TABLE #VIN (VIN NVARCHAR(17) PRIMARY KEY CLUSTERED)

         INSERT #VIN
         SELECT
            VIN = ss.[value]
         FROM
            STRING_SPLIT(@VIN, ',') ss

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
			,  t.BuyAuctionHouseTypeID
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
			   ,  PB.BuyAuctionHouseTypeID
               ,  LastProxyBidRequestID = LAST_VALUE(PBR.ProxyBidRequestID) OVER (ORDER BY PB.ProxyBidID DESC)
               ,  LastProxyBidAttemptID = LAST_VALUE(PBA.ProxyBidAttemptID) OVER (ORDER BY PB.ProxyBidID DESC)
               FROM
                           bid.tblProxyBid         PB  WITH (NOLOCK)  
               INNER JOIN  #VIN                    vin                ON PB.VIN                = vin.VIN
               INNER JOIN  bid.tblProxyBidRequest  PBR WITH (NOLOCK)  ON PB.ProxyBidID         = PBR.ProxyBidID
               INNER JOIN  bid.tblProxyBidAttempt  PBA WITH (NOLOCK)  ON PBA.ProxyBidRequestID = PBR.ProxyBidRequestID
               INNER JOIN  bid.tblProxyBidStatus   PBS WITH (NOLOCK)  ON PBS.ProxyBidStatusID  = PB.ProxyBidStatusID
            ) t
            GROUP BY
               t.ProxyBidID, t.ProxyBidStagingId, t.AuctionID, t.Channel, t.VIN, t.FinalAmount, t.CustomerId, t.AccountNumber, t.RepName, t.RepNumber, t.[Status], t.RowLoadedDateTime, t.RowUpdatedDateTime, t.ProxyBidPlaced, t.BidId, t.ProxyBidEnteredBy, t.BuyAuctionVehicleID, t.LastProxyBidRequestID, t.LastProxyBidAttemptID, t.BuyAuctionHouseTypeID
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
		 ,  summ.BuyAuctionHouseTypeID
         FROM
                     cteSummary                       summ
         INNER JOIN  Buy.bid.tblProxyBidRequest       PBR   WITH (NOLOCK) ON summ.LastProxyBidRequestID = PBR.ProxyBidRequestID
         INNER JOIN  Buy.bid.tblProxyBidAttempt       PBA   WITH (NOLOCK) ON summ.LastProxyBidAttemptID = PBA.ProxyBidAttemptID
         INNER JOIN  Buy.bid.tblProxyBidRequestType   PBRT  WITH (NOLOCK) ON PBRT.ProxyBidRequestTypeID = PBR.ProxyBidRequestTypeID
         INNER JOIN  Buy.bid.tblProxyBidOriginType    PBOT  WITH (NOLOCK) ON PBOT.ProxyBidOriginTypeID  = PBR.ProxyBidOriginTypeID;

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

