
CREATE PROCEDURE [dbo].[stpMergeVehicleTireReference]
AS
	MERGE AuctionEdge.tblVehicleTireReference AS t
	USING
	(	SELECT
			*
		FROM
			AuctionEdge.tblVehicleTireReference_stage) AS s
	ON (t.VehicleTiresReferenceId = s.VehicleTiresReferenceId)
	WHEN MATCHED THEN UPDATE SET
						  t.VehicleTiresReferenceId = s.VehicleTiresReferenceId
						 ,t.VehicleReferenceId = s.VehicleReferenceId
	WHEN NOT MATCHED BY TARGET THEN INSERT (VehicleTiresReferenceId
									   ,VehicleReferenceId)
									VALUES (
										s.VehicleTiresReferenceId, s.VehicleReferenceId);


