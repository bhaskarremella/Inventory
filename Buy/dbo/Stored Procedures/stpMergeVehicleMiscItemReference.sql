
CREATE PROCEDURE [dbo].[stpMergeVehicleMiscItemReference]
AS
	MERGE AuctionEdge.tblVehicleMiscItemReference AS t
	USING
	(	SELECT
			*
		FROM
			AuctionEdge.tblVehicleMiscItemReference_stage) AS s
	ON (t.VehicleMiscItemsReferenceId = s.VehicleMiscItemsReferenceId)
	WHEN MATCHED THEN UPDATE SET
						  t.VehicleMiscItemsReferenceId = s.VehicleMiscItemsReferenceId
						 ,t.VehicleReferenceId = s.VehicleReferenceId
	WHEN NOT MATCHED BY TARGET THEN INSERT (VehicleMiscItemsReferenceId
									   ,VehicleReferenceId)
									VALUES (
										s.VehicleMiscItemsReferenceId, s.VehicleReferenceId);

