
CREATE PROCEDURE [dbo].[stpMergeVehicleConditionFlagsReference]
AS
	MERGE AuctionEdge.tblVehicleConditionFlagsReference AS t
	USING
	(	SELECT
			*
		FROM
			AuctionEdge.tblVehicleConditionFlagsReference_stage) AS s
	ON (t.VehicleConditionFlagsReferenceId = s.VehicleConditionFlagsReferenceId)
	WHEN MATCHED THEN UPDATE SET
						  t.VehicleConditionFlagsReferenceId = s.VehicleConditionFlagsReferenceId
						 ,t.VehicleReferenceId = s.VehicleReferenceId
	WHEN NOT MATCHED BY TARGET THEN INSERT (VehicleConditionFlagsReferenceId
									   ,VehicleReferenceId)
									VALUES (
										s.VehicleConditionFlagsReferenceId, s.VehicleReferenceId);


