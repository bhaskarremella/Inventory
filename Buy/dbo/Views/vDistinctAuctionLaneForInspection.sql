

CREATE VIEW [dbo].[vDistinctAuctionLaneForInspection]
AS

/* 
Created By:		Viv Shah
Created On:		Feb 23rd, 2018
Description:	This view is used to select the distinct combination of saledate, lane and auctions for the inspection app.

Updated By:		Denis Fonjga
Updated On:		2/23/2018
Description:	Updated SaleDate logic to be between today's date and 14 days in the future

*/

SELECT DISTINCT
    alt.AuctionListKey,
    bav.SaleDate,
    bav.Lane,
    aht.AuctionHouseKey
FROM dbo.tblBuyAuctionVehicle BAV
    INNER JOIN dbo.tblBuyAuctionListType alt			WITH (NOLOCK)		        ON alt.BuyAuctionListTypeID = BAV.BuyAuctionListTypeID
    INNER JOIN dbo.tblBuyAuctionHouseType aht			WITH (NOLOCK)				ON aht.BuyAuctionHouseTypeID = alt.BuyAuctionHouseTypeID	
WHERE BAV.SaleDate BETWEEN CONVERT(DATE, GETDATE()) AND DATEADD(DAY,14,CAST(GETDATE() AS DATE))
      AND (BAV.IsDecommissionedInspectionDateTime >= BAV.SaleDate OR BAV.IsDecommissionedInspection = 0)
	  AND bav.IsInspectorAppVehicle = 1;

