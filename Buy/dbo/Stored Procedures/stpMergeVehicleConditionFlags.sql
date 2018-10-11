
CREATE PROCEDURE [dbo].[stpMergeVehicleConditionFlags]
AS
	MERGE AuctionEdge.tblVehicleConditionFlags AS t
	USING
	(	SELECT
			*
		FROM
			AuctionEdge.tblVehicleConditionFlags_stage) AS s
	ON (t.VehicleConditionFlagsReferenceId = s.VehicleConditionFlagsReferenceId)
	WHEN MATCHED THEN UPDATE SET
						  t.VehicleConditionFlagsReferenceId = s.VehicleConditionFlagsReferenceId
						 ,t.isAirbagDeployed = s.isAirbagDeployed
						 ,t.isCanadianImport = s.isCanadianImport
						 ,t.isFireDamage = s.isFireDamage
						 ,t.isFloodDamage = s.isFloodDamage
						 ,t.isFrameDamage = s.isFrameDamage
						 ,t.isGrayMarket = s.isGrayMarket
						 ,t.isHailDamage = s.isHailDamage
						 ,t.isJunk = s.isJunk
						 ,t.isLemon = s.isLemon
						 ,t.isNonOp = s.isNonOp
						 ,t.isOdoBroken = s.isOdoBroken
						 ,t.isOdoEML = s.isOdoEML
						 ,t.isOdoExempt = s.isOdoExempt
						 ,t.isOdoNAM = s.isOdoNAM
						 ,t.isOdoReplaced = s.isOdoReplaced
						 ,t.isOdoTMU = s.isOdoTMU
						 ,t.isPoliceUse = s.isPoliceUse
						 ,t.isRebuilt = s.isRebuilt
						 ,t.isSalvaged = s.isSalvaged
						 ,t.isStolen = s.isStolen
						 ,t.isTaxi = s.isTaxi
	WHEN NOT MATCHED BY TARGET THEN INSERT (VehicleConditionFlagsReferenceId
									   ,isAirbagDeployed
									   ,isCanadianImport
									   ,isFireDamage
									   ,isFloodDamage
									   ,isFrameDamage
									   ,isGrayMarket
									   ,isHailDamage
									   ,isJunk
									   ,isLemon
									   ,isNonOp
									   ,isOdoBroken
									   ,isOdoEML
									   ,isOdoExempt
									   ,isOdoNAM
									   ,isOdoReplaced
									   ,isOdoTMU
									   ,isPoliceUse
									   ,isRebuilt
									   ,isSalvaged
									   ,isStolen
									   ,isTaxi)
									VALUES (
										s.VehicleConditionFlagsReferenceId, s.isAirbagDeployed, s.isCanadianImport, s.isFireDamage, s.isFloodDamage, s.isFrameDamage, s.isGrayMarket, s.isHailDamage, s.isJunk, s.isLemon, s.isNonOp, s.isOdoBroken, s.isOdoEML, s.isOdoExempt, s.isOdoNAM, s.isOdoReplaced, s.isOdoTMU, s.isPoliceUse, s.isRebuilt, s.isSalvaged, s.isStolen, s.isTaxi);


