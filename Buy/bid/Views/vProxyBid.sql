



CREATE VIEW [bid].[vProxyBid]
AS

    /*

Created By:		Justin Crandall
Created On:		???
Description:	View for Proxy Bid details

Updated By:		Travis Bleile
Updated On:		January 2018
Description:	Updating view to include new ProxyBidOriginType Table details

Updated By:		Travis Bleile
Updated On:		2/12/2018
Description:	Updated view to create table aliases and remove SELECT * from the Summary Subquery



*/

    SELECT Summary.ProxyBidID ,
           Summary.ProxyBidStagingId ,
           Summary.AuctionID ,
           Summary.Channel ,
           Summary.VIN ,
           Summary.FinalAmount ,
           Summary.CustomerId ,
           Summary.AccountNumber ,
           Summary.RepName ,
           Summary.RepNumber ,
           Summary.Status ,
           Summary.RowLoadedDateTime ,
           Summary.RowUpdatedDateTime ,
           Summary.ProxyBidPlaced ,
           Summary.BidId ,
           Summary.LastProxyBidRequestID ,
           Summary.LastProxyBidAttemptID ,
           PBRT.[Description] AS LastRequestType ,
           PBR.CompletedSuccessfully AS LastRequestSuccessful ,
           PBA.OutcomeErrorMessage AS LastOutcomeError ,
           PBA.OutcomeStatusCode AS LastOutcomeStatus ,
           PBA.BidUrl AS LastOutcomeUrl ,
           PBOT.ProxyBidOriginKey AS ProxyBidOriginKey
    FROM   (   SELECT DISTINCT PB.[ProxyBidID] ,
                      PB.[ProxyBidStagingId] ,
                      PB.[AuctionID] ,
                      PB.[Channel] ,
                      PB.[VIN] ,
                      PB.[Amount] AS FinalAmount ,
                      PB.[CustomerId] ,
                      PB.[AccountNumber] ,
                      PB.[RepName] ,
                      PB.[RepNumber] ,
                      PBS.[Description] AS Status ,
                      PB.[RowLoadedDateTime] ,
                      PB.[RowUpdatedDateTime] ,
                      PB.[ProxyBidPlaced] ,
                      PB.[BidId] ,
                      LAST_VALUE(PBR.[ProxyBidRequestID]) OVER ( ORDER BY PB.[ProxyBidID] DESC ) AS LastProxyBidRequestID ,
                      LAST_VALUE(PBA.[ProxyBidAttemptID]) OVER ( ORDER BY PB.[ProxyBidID] DESC ) AS LastProxyBidAttemptID
               FROM   [Buy].[bid].[tblProxyBid] AS PB
                      INNER JOIN [Buy].[bid].[tblProxyBidRequest] PBR ON PB.ProxyBidID = PBR.ProxyBidID
                      INNER JOIN [Buy].[bid].[tblProxyBidAttempt] PBA ON PBA.[ProxyBidRequestID] = PBR.[ProxyBidRequestID]
                      INNER JOIN [Buy].[bid].[tblProxyBidStatus] PBS ON PBS.ProxyBidStatusID = PB.ProxyBidStatusID
               WHERE  PB.[IsDeleted] = 0
                      AND PB.[IsAbandoned] = 0
           ) AS Summary
           INNER JOIN [Buy].[bid].[tblProxyBidRequest] PBR ON Summary.LastProxyBidRequestID = PBR.ProxyBidRequestID
           INNER JOIN [Buy].[bid].[tblProxyBidAttempt] PBA ON Summary.LastProxyBidAttemptID = PBA.ProxyBidAttemptID
           INNER JOIN [Buy].[bid].[tblProxyBidRequestType] PBRT ON PBRT.ProxyBidRequestTypeID = PBR.ProxyBidRequestTypeID
           INNER JOIN [Buy].[bid].[tblProxyBidOriginType] PBOT ON PBOT.ProxyBidOriginTypeID = PBR.ProxyBidOriginTypeID;


