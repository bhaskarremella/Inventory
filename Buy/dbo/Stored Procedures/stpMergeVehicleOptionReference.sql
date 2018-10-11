
CREATE PROCEDURE [dbo].[stpMergeVehicleOptionReference]
AS
	MERGE AuctionEdge.tblVehicleOptionReference AS t
	USING
	(	SELECT
			*
		FROM
			AuctionEdge.tblVehicleOptionReference_stage) AS s
	ON (t.VehicleOptionsReferenceId = s.VehicleOptionsReferenceId)
	WHEN MATCHED THEN UPDATE SET
						  t.VehicleOptionsReferenceId = s.VehicleOptionsReferenceId
						 ,t.VehicleReferenceId = s.VehicleReferenceId
	WHEN NOT MATCHED BY TARGET THEN INSERT (VehicleOptionsReferenceId
									   ,VehicleReferenceId)
									VALUES (
										s.VehicleOptionsReferenceId, s.VehicleReferenceId);


