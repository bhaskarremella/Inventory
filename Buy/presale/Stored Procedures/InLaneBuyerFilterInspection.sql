
         CREATE PROCEDURE [presale].[InLaneBuyerFilterInspection]
		 (
			@in_SaleDate DATE
			,@in_AuctionNameSlicer VARCHAR(255)
			,@in_Lane INT
		 )
         AS
         /**********************************************************************************************************************************************************************
         **
         **    Name:          presale.InLaneBuyerFilterInspection '2016-10-24', 'Tampa', 24
         **
         **    Description:   This proc will take filter the list of Auctions and Sale Dates for the In Lane Buying App
         **
         **    Parameters:    
         **
         **    How To Call:   
         **
         **    Created:       10/24/2016
         **    Author:        Lisa Aguilera
         **    Group:         Inventory
         **
         **    History:
         **
         **    Change Date          Author                                                         Reason
         **    -------------------- -------------------------------------------------------------- -------------------------------------------------------------------------
         **
         **********************************************************************************************************************************************************************/
   
			DECLARE @SaleDate DATE = @in_SaleDate
					,@AuctionNameSlicer VARCHAR(255) = @in_AuctionNameSlicer
					,@Lane INT = @in_Lane

			SELECT ID ,
                   VehicleID ,
                   AuctionID ,
                   SaleDate ,
                   Lane ,
                   Run ,
                   VIN ,
                   VehicleYear ,
                   Make ,
                   Model ,
                   Color ,
                   Odometer ,
                   DTValue ,
                   BookValue ,
                   Announcement ,
                   InspectorName ,
                   InspectorEmail ,
                   InspectionBucket ,
                   InspectionSurveyStart ,
                   InspectionSurveyEnd ,
                   BuyerBucket ,
                   CapAmount ,
                   OverAllowance ,
                   InspectionLink ,
                   InspectionSummary ,
                   ETLRowLoadedDateTime ,
                   ETLRowUpdatedDateTime ,
                   YearMakeModel ,
                   Size ,
                   VehicleLink ,
                   Seller ,
                   EstimatedRecon ,
                   LaneVINColor ,
                   RunVIN6 ,
                   CheckBoxURL ,
                   CustomSort ,
                   YMM ,
                   MakeModel ,
                   RunVIN ,
                   AuctionName ,
                   AuctionIDLane ,
                   IsDecommissioned ,
                   VehicleNotFoundDateTime ,
                   SaleDateFormatted ,
                   AuctionIDSaleDateKey ,
                   AuctionNameLaneRun ,
                   AuctionIDSaleDateLaneKey ,
                   LaneString ,
                   AuctionNameSlicer ,
                   IsInspectionComplete ,
                   IsVehicleDispositioned ,
                   SaleDateFilter ,
                   IsLaneSelected ,
                   LaneSelectedBy ,
                   IsBuyerPreferred ,
                   IsInspectionFailed ,
                   IsVehicleNotFound
			  FROM [Buy].[Access].[Vehicle]
			 WHERE (IsInspectionComplete = 0 OR IsInspectionComplete IS NULL)
				 AND @SaleDate = CAST(SaleDate AS DATE)
				 AND @AuctionNameSlicer = AuctionNameSlicer
				 AND @Lane = Lane
