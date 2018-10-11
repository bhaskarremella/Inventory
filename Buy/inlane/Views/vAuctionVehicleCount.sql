



CREATE VIEW [inlane].[vAuctionVehicleCount]
/*
Created By: Lisa Aguilera
Created On: 10/26/2016
Created For: Created for InLane PowerApp to get Count of Vehicles per Auction for today
*/
AS 

	SELECT a.AuctionID
			, a.AuctionName
			,CAST(a.AuctionNameShort AS VARCHAR(50)) AS AuctionNameShort
			, COUNT(DISTINCT vl.VIN) AS VehicleCount
	FROM inlane.tblVehicleList vl WITH (NOLOCK)
	JOIN inlane.tblAuction a WITH (NOLOCK) ON vl.AuctionID = a.AuctionID
	WHERE SaleDate = CAST(GETDATE() AS DATE)
		AND IsInspectionComplete = 0
	GROUP BY a.AuctionID, a.AuctionName, a.AuctionNameShort


