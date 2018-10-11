
CREATE PROCEDURE [dbo].[stpMergeAuctionReference]
AS
	MERGE AuctionEdge.tblAuctionReference AS t
	USING
	(	SELECT
			*
		FROM
			AuctionEdge.tblAuctionReference_stage) AS s
	ON (t.VehicleReferenceId = s.VehicleReferenceId)
	WHEN MATCHED THEN UPDATE SET
						  t.AuctionReferenceId = s.AuctionReferenceId
						 ,t.VehicleReferenceId = s.VehicleReferenceId
	WHEN NOT MATCHED BY TARGET THEN INSERT (AuctionReferenceId
									   ,VehicleReferenceId)
									VALUES (
										s.AuctionReferenceId, s.VehicleReferenceId);


