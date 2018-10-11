
CREATE PROCEDURE [dbo].[stpMergeVehicle]
AS
	MERGE AuctionEdge.tblVehicle AS t
	USING
	(	SELECT
			*
		FROM
			AuctionEdge.tblVehicle_stage) AS s
	ON (t.ExternalVehicleId = s.ExternalVehicleId)
	WHEN MATCHED THEN UPDATE SET
						  t.ExternalVehicleId = s.ExternalVehicleId
						 ,t.VehicleReferenceId = s.VehicleReferenceId
						 ,t.URL = s.URL
						 ,t.SaleEventId = s.SaleEventId
						 ,t.EventId = s.EventId
						 ,t.VIN = s.VIN
						 ,t.Mileage = s.Mileage
						 ,t.UVC = s.UVC
						 ,t.SubUVC = s.SubUVC
						 ,t.Year = s.Year
						 ,t.OYear = s.OYear
						 ,t.MakeModelTrim = s.MakeModelTrim
						 ,t.Make = s.Make
						 ,t.OMake = s.OMake
						 ,t.Model = s.Model
						 ,t.OModel = s.OModel
						 ,t.Trim = s.Trim
						 ,t.OTrim = s.OTrim
						 ,t.BodyStyle = s.BodyStyle
						 ,t.STATFuel = s.STATFuel
						 ,t.BlackBookFuelType = s.BlackBookFuelType
						 ,t.MSRP = s.MSRP
						 ,t.ExtColor = s.ExtColor
						 ,t.IntColor = s.IntColor
						 ,t.IntMaterial = s.IntMaterial
						 ,t.EngineType = s.EngineType
						 ,t.STATCylindars = s.STATCylindars
						 ,t.EngineDisplacement = s.EngineDisplacement
						 ,t.Transmission = s.Transmission
						 ,t.Warranty = s.Warranty
						 ,t.Lights = s.Lights
						 ,t.STATBodyStyle = s.STATBodyStyle
						 ,t.STATEquipment = s.STATEquipment
						 ,t.CleanModel = s.CleanModel
						 ,t.CleanTrim = s.CleanTrim
						 ,t.OdoStatus = s.OdoStatus
						 ,t.TitleState = s.TitleState
						 ,t.HasConditionReport = s.HasConditionReport
						 ,t.CRDate = s.CRDate
						 ,t.IsMechanicallySound = s.IsMechanicallySound
						 ,t.AutoGrade = s.AutoGrade
						 ,t.PriorPaint = s.PriorPaint
						 ,t.CRWriter = s.CRWriter
						 ,t.PARValue = s.PARValue
						 ,t.StockNumber = s.StockNumber
						 ,t.RunNumber = s.RunNumber
						 ,t.ConsignmentDate = s.ConsignmentDate
						 ,t.ShowMakeOffer = s.ShowMakeOffer
						 ,t.STATEventDate = s.STATEventDate
						 ,t.STATSaleStatus = s.STATSaleStatus
						 ,t.SaleStatus = s.SaleStatus
						 ,t.SoldDate = s.SoldDate
						 ,t.SoldAmount = s.SoldAmount
						 ,t.ConsignorId = s.ConsignorId
						 ,t.GlobalConsignorId = s.GlobalConsignorId
						 ,t.GlobalConsignorName = s.GlobalConsignorName
						 ,t.Comment = s.Comment
						 ,t.BlackBookDriveType = s.BlackBookDriveType
						 ,t.SaleDate = s.SaleDate
						 ,t.CROverallGrade = s.CROverallGrade
						 ,t.STATOverallGrade = s.STATOverallGrade
						 ,t.FuelType = s.FuelType
						 ,t.DriveType = s.DriveType
						 ,t.SaleMethod = s.SaleMethod
						 ,t.FloorCode = s.FloorCode
						 ,t.BlackbookValue = s.BlackbookValue
						 ,t.FrameDamage = s.FrameDamage
						 ,t.FileId = s.FileId
	WHEN NOT MATCHED BY TARGET THEN INSERT (ExternalVehicleId
									   ,VehicleReferenceId
									   ,URL
									   ,SaleEventId
									   ,EventId
									   ,VIN
									   ,Mileage
									   ,UVC
									   ,SubUVC
									   ,Year
									   ,OYear
									   ,MakeModelTrim
									   ,Make
									   ,OMake
									   ,Model
									   ,OModel
									   ,Trim
									   ,OTrim
									   ,BodyStyle
									   ,STATFuel
									   ,BlackBookFuelType
									   ,MSRP
									   ,ExtColor
									   ,IntColor
									   ,IntMaterial
									   ,EngineType
									   ,STATCylindars
									   ,EngineDisplacement
									   ,Transmission
									   ,Warranty
									   ,Lights
									   ,STATBodyStyle
									   ,STATEquipment
									   ,CleanModel
									   ,CleanTrim
									   ,OdoStatus
									   ,TitleState
									   ,HasConditionReport
									   ,CRDate
									   ,IsMechanicallySound
									   ,AutoGrade
									   ,PriorPaint
									   ,CRWriter
									   ,PARValue
									   ,StockNumber
									   ,RunNumber
									   ,ConsignmentDate
									   ,ShowMakeOffer
									   ,STATEventDate
									   ,STATSaleStatus
									   ,SaleStatus
									   ,SoldDate
									   ,SoldAmount
									   ,ConsignorId
									   ,GlobalConsignorId
									   ,GlobalConsignorName
									   ,Comment
									   ,BlackBookDriveType
									   ,SaleDate
									   ,CROverallGrade
									   ,STATOverallGrade
									   ,FuelType
									   ,DriveType
									   ,SaleMethod
									   ,FloorCode
									   ,BlackbookValue
									   ,FrameDamage
									   ,FileId)
									VALUES (
										s.ExternalVehicleId, s.VehicleReferenceId, s.URL, s.SaleEventId, s.EventId, s.VIN, s.Mileage, s.UVC, s.SubUVC, s.Year, s.OYear, s.MakeModelTrim, s.Make, s.OMake, s.Model, s.OModel, s.Trim, s.OTrim, s.BodyStyle, s.STATFuel, s.BlackBookFuelType, s.MSRP, s.ExtColor, s.IntColor, s.IntMaterial, s.EngineType, s.STATCylindars, s.EngineDisplacement, s.Transmission, s.Warranty, s.Lights, s.STATBodyStyle, s.STATEquipment, s.CleanModel, s.CleanTrim, s.OdoStatus, s.TitleState, s.HasConditionReport, s.CRDate, s.IsMechanicallySound, s.AutoGrade, s.PriorPaint, s.CRWriter, s.PARValue, s.StockNumber, s.RunNumber, s.ConsignmentDate, s.ShowMakeOffer, s.STATEventDate, s.STATSaleStatus, s.SaleStatus, s.SoldDate, s.SoldAmount, s.ConsignorId, s.GlobalConsignorId, s.GlobalConsignorName, s.Comment, s.BlackBookDriveType, s.SaleDate, s.CROverallGrade, s.STATOverallGrade, s.FuelType, s.DriveType, s.SaleMethod, s.FloorCode, s.BlackbookValue, s.FrameDamage, s.FileId);


