

CREATE PROCEDURE [dbo].[stpMergeVehicleConditions]
AS
	MERGE AuctionEdge.tblVehicleConditions AS t 
	USING
	(	SELECT 
			*
		FROM
			AuctionEdge.tblVehicleConditions_Stage) AS s
	ON (t.VehicleConditionsReferenceId = s.VehicleConditionsReferenceId
		AND t.Damage = s.Damage
		AND t.DamageItem = s.DamageItem
		AND t.Severity = ISNULL(s.Severity,0))
	WHEN MATCHED THEN UPDATE SET
						  t.VehicleConditionsReferenceId = s.VehicleConditionsReferenceId
						 ,t.Action = s.Action
						 ,t.BodyHours = s.BodyHours
						 ,t.BodyLaborCost = s.BodyLaborCost
						 ,t.Chargeable = s.Chargeable
						 ,t.Comments = s.Comments
						 ,t.CreatedBy = s.CreatedBy
						 ,t.Damage = s.Damage
						 ,t.DamageItem = s.DamageItem
						 ,t.DateCreated = s.DateCreated
						 ,t.ImageName = s.ImageName
						 ,t.PaintHours = s.PaintHours
						 ,t.PaintLaborCost = s.PaintLaborCost
						 ,t.PartAmount = s.PartAmount
						 ,t.PartHours = s.PartHours
						 ,t.PartLaborCost = s.PartLaborCost
						 ,t.isRepairSuggested = s.isRepairSuggested
						 ,t.isRepairedByAuction = s.isRepairedByAuction
						 ,t.Severity = ISNULL(s.Severity, 0)
						 ,t.ShowRepaired = s.ShowRepaired
						 ,t.RepairAmount = s.RepairAmount
	WHEN NOT MATCHED BY TARGET THEN INSERT (VehicleConditionsReferenceId
									   ,Action
									   ,BodyHours
									   ,BodyLaborCost
									   ,Chargeable
									   ,Comments
									   ,CreatedBy
									   ,Damage
									   ,DamageItem
									   ,DateCreated
									   ,ImageName
									   ,PaintHours
									   ,PaintLaborCost
									   ,PartAmount
									   ,PartHours
									   ,PartLaborCost
									   ,isRepairSuggested
									   ,isRepairedByAuction
									   ,Severity
									   ,ShowRepaired
									   ,RepairAmount)
									VALUES (
										s.VehicleConditionsReferenceId, s.Action, s.BodyHours, s.BodyLaborCost, s.Chargeable, s.Comments, s.CreatedBy, s.Damage, s.DamageItem, s.DateCreated, s.ImageName, s.PaintHours, s.PaintLaborCost, s.PartAmount, s.PartHours, s.PartLaborCost, s.isRepairSuggested, s.isRepairedByAuction, ISNULL(s.Severity, 0), s.ShowRepaired, s.RepairAmount);




