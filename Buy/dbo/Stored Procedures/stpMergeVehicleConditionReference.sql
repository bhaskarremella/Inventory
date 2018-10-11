
CREATE PROCEDURE [dbo].[stpMergeVehicleConditionReference]
AS
	MERGE AuctionEdge.tblVehicleConditionReference AS t
	USING
	(	SELECT
			*
		FROM
			AuctionEdge.tblVehicleConditionReference_stage) AS s
	ON (t.VehicleReferenceId = s.VehicleReferenceId)
	WHEN MATCHED THEN UPDATE SET
						  t.VehicleConditionsReferenceId = s.VehicleConditionsReferenceId
						 ,t.VehicleReferenceId = s.VehicleReferenceId
	WHEN NOT MATCHED BY TARGET THEN INSERT (VehicleConditionsReferenceId
									   ,VehicleReferenceId)
									VALUES (
										s.VehicleConditionsReferenceId, s.VehicleReferenceId);


