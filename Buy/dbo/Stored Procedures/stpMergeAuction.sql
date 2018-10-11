
CREATE PROCEDURE [dbo].[stpMergeAuction]
AS
	MERGE AuctionEdge.tblAuction AS t
	USING
	(	SELECT
			*
		FROM
			AuctionEdge.tblAuction_stage) AS s
	ON (t.AuctionRefernceID = s.AuctionRefernceID)
	WHEN MATCHED THEN UPDATE SET
						  t.ExternalAuctionId = s.ExternalAuctionId
						 ,t.AuctionRefernceID = s.AuctionRefernceID
						 ,t.AuctionName = s.AuctionName
						 ,t.City = s.City
						 ,t.State = s.State
						 ,t.Zip = s.Zip
	WHEN NOT MATCHED BY TARGET THEN INSERT (ExternalAuctionId
									   ,AuctionRefernceID
									   ,AuctionName
									   ,City
									   ,State
									   ,Zip)
									VALUES (
										s.ExternalAuctionId, s.AuctionRefernceID, s.AuctionName, s.City, s.State, s.Zip);


