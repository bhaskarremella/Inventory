
create PROCEDURE [dbo].[stpMergeVehicleOption]
AS
	MERGE AuctionEdge.tblVehicleOption AS t
	USING
	(	SELECT
			tblVehicleOption_Stage.VehicleOptionReferenceId
		   ,tblVehicleOption_Stage.VehicleOption
		FROM
			AuctionEdge.tblVehicleOption_Stage
		GROUP BY
			tblVehicleOption_Stage.VehicleOptionReferenceId
		   ,tblVehicleOption_Stage.VehicleOption) AS s
	ON (t.VehicleOption = s.VehicleOption
		AND t.VehicleOptionReferenceId = s.VehicleOptionReferenceId)
	WHEN MATCHED THEN UPDATE SET
						  t.VehicleOptionReferenceId = s.VehicleOptionReferenceId
						 ,t.VehicleOption = s.VehicleOption
	WHEN NOT MATCHED BY TARGET THEN INSERT (VehicleOptionReferenceId
									   ,VehicleOption)
									VALUES (
										s.VehicleOptionReferenceId, s.VehicleOption);


