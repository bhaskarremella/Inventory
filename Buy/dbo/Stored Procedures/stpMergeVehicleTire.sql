
create PROCEDURE [dbo].[stpMergeVehicleTire]
AS
	MERGE AuctionEdge.tblVehicleTire AS t
	USING
	(	SELECT
			tblVehicleTire_Stage.VehicleTireReferenceId
		   ,tblVehicleTire_Stage.TireRegion
		   ,MAX(tblVehicleTire_Stage.TireBrand)	TireBrand
		   ,MAX(tblVehicleTire_Stage.TireSize)		TireSize
		   ,MAX(tblVehicleTire_Stage.TireCondition)TireCondition
		FROM
			AuctionEdge.tblVehicleTire_Stage
		GROUP BY
			tblVehicleTire_Stage.VehicleTireReferenceId
		   ,tblVehicleTire_Stage.TireRegion) AS s
	ON (t.TireRegion = s.TireRegion
		AND t.VehicleTireReferenceId = s.VehicleTireReferenceId)
	WHEN MATCHED THEN UPDATE SET
						  t.VehicleTireReferenceId = s.VehicleTireReferenceId
						 ,t.TireRegion = s.TireRegion
						 ,t.TireBrand = s.TireBrand
						 ,t.TireSize = s.TireSize
						 ,t.TireCondition = s.TireCondition
	WHEN NOT MATCHED BY TARGET THEN INSERT (VehicleTireReferenceId
									   ,TireRegion
									   ,TireBrand
									   ,TireSize
									   ,TireCondition)
									VALUES (
										s.VehicleTireReferenceId, s.TireRegion, s.TireBrand, s.TireSize, s.TireCondition);


