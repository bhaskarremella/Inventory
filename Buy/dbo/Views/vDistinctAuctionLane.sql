




CREATE VIEW [dbo].[vDistinctAuctionLane]
AS

/* 
Created By:		Viv Shah
Created On:		Sep 12th, 2017
Description:	This View is used to select the distinct combination of saledate, lane and Aucitons.

Updated By:		Travis Bleile
Updated On:		Sep 27, 2017
Description:	Updated WHERE Clause to allow lane details for sale dates 3 days in the past for business requirement.

Updated By:		Travis Bleile
Updated On:		October 3, 2017
Description:	Updated join to tblBuy to use BuyAuctionVehicleID 

Updated By:		Travis Bleile
Updated On:		October 10, 2017
Description:	Removed Buy table logic as requested by Dev Team per the Requirements of the app (See commented below)

Updated By:		Gwendolyn Lukemire
Updated On:		January 5, 2018
Description:	Added logic to show lanes that had vehicles decommissioned if it was on or after sale date

Updated By:		Travis Bleile
Updated On:		1/12/2018
Description:	Failed inspection Logic

*/


--Give me all of the distinct auction/saledate/lane combinations that only have failed inspections in them
WITH AllInspectionsFailed AS 
(
SELECT DISTINCT CONCAT(balt.AuctionListKey,bav.SaleDate, lane) AS aifkey 
				FROM dbo.tblBuyAuctionVehicle bav
					INNER JOIN dbo.tblBuyAuctionListType balt ON balt.BuyAuctionListTypeID = bav.BuyAuctionListTypeID
					LEFT JOIN dbo.tblBuyInspection bi ON bi.BuyVehicleID = bav.BuyVehicleID
				WHERE BAV.SaleDate >= DATEADD(DAY,-3,CAST(GETDATE() AS DATE))
				GROUP BY balt.AuctionListKey,bav.SaleDate, lane
				HAVING COUNT(*) =  SUM(CASE WHEN bi.IsInspectionFailed = 1 THEN 1 ELSE 0 End) -- When every vehicle in that lane = the number of failed inspections in that lane.
)

SELECT DISTINCT
    alt.AuctionListKey,
    bav.SaleDate,
    bav.Lane,
    aht.AuctionHouseKey
FROM dbo.tblBuyAuctionVehicle BAV
    INNER JOIN dbo.tblBuyAuctionListType alt			WITH (NOLOCK)		        ON alt.BuyAuctionListTypeID = BAV.BuyAuctionListTypeID
    INNER JOIN dbo.tblBuyAuctionHouseType aht			WITH (NOLOCK)				ON aht.BuyAuctionHouseTypeID = alt.BuyAuctionHouseTypeID
	LEFT JOIN AllInspectionsFailed aif					WITH (NOLOCK)				ON CONCAT(alt.AuctionListKey,BAV.SaleDate,BAV.Lane) = aif.aifkey
WHERE BAV.SaleDate >= DATEADD(DAY,-3,CAST(GETDATE() AS DATE))
      AND (BAV.IsDecommissionedDateTime >= BAV.SaleDate OR BAV.IsDecommissioned = 0)
	  AND aif.aifkey IS NULL; --Filter out lanes with only failed inspections in them




