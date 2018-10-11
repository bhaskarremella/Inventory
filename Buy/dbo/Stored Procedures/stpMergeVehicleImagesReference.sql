
CREATE PROCEDURE [dbo].[stpMergeVehicleImagesReference]
AS
	MERGE AuctionEdge.tblVehicleImagesReference AS t
	USING
	(	SELECT
			*
		FROM
			AuctionEdge.tblVehicleImagesReference_stage) AS s
	ON (t.VehicleImagesReferenceId = s.VehicleImagesReferenceId)
	WHEN MATCHED THEN UPDATE SET
						  t.VehicleImagesReferenceId = s.VehicleImagesReferenceId
						 ,t.VehicleReferenceId = s.VehicleReferenceId
	WHEN NOT MATCHED BY TARGET THEN INSERT (VehicleImagesReferenceId
									   ,VehicleReferenceId)
									VALUES (
										s.VehicleImagesReferenceId, s.VehicleReferenceId);


