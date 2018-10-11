

CREATE PROCEDURE [dbo].[stpMergeVehicleMiscItem]
AS
	MERGE AuctionEdge.tblVehicleMiscItem AS t
	USING
	(	SELECT
			tblVehicleMiscItem_Stage.VehicleMiscItemReferenceId
		   ,tblVehicleMiscItem_Stage.ItemType
		   ,tblVehicleMiscItem_Stage.SecurityLevel
		   ,MAX(tblVehicleMiscItem_Stage.ItemValue) AS ItemValue
		FROM
			AuctionEdge.tblVehicleMiscItem_Stage
		GROUP BY
			tblVehicleMiscItem_Stage.VehicleMiscItemReferenceId
		   ,tblVehicleMiscItem_Stage.ItemType
		   ,tblVehicleMiscItem_Stage.SecurityLevel) AS s
	ON (t.VehicleMiscItemReferenceId = s.VehicleMiscItemReferenceId
		AND
		t.ItemType = s.ItemType)
	WHEN MATCHED THEN UPDATE SET
						  t.VehicleMiscItemReferenceId = s.VehicleMiscItemReferenceId
						 ,t.ItemType = s.ItemType
						 ,t.SecurityLevel = s.SecurityLevel
						 ,t.ItemValue = s.ItemValue
	WHEN NOT MATCHED BY TARGET THEN INSERT (VehicleMiscItemReferenceId
									   ,ItemType
									   ,SecurityLevel
									   ,ItemValue)
									VALUES (
										s.VehicleMiscItemReferenceId, s.ItemType, s.SecurityLevel, s.ItemValue);



