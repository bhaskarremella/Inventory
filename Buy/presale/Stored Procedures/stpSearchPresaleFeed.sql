

   CREATE   PROCEDURE [presale].[stpSearchPresaleFeed]      (@VIN VARCHAR(17)) 

      /*
   ------------------------------------------------------------
   Created By:       Gwendolyn Lukemire
   Created On:       Oct 9 2018
   Procedure Name:   presale.stpSearchBuyonicVehicle
   Application:      Buyonic Vehicle Search
   Description:      Determine if a vehicle exists in the
					 combined presale table
   ------------------------------------------------------------
   */

   AS 

   BEGIN
      --Set Environment
      SET NOCOUNT ON;
      SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

      DECLARE @TodayDate DATE = CAST(GETDATE() AS DATE);

      BEGIN TRY;

	  SELECT TOP (1)
		  cp.VIN
		, AuctionHouse = ISNULL(baht.AuctionHouseKey, 'Unknown')
		, cp.AuctionName
		, cp.[Year]
		, cp.Make
		, cp.Model
		, Color = cp.ExteriorColor 
		, cp.SaleDate
		, cp.Mileage
		, Lane = cp.LaneNumber
		, Run = cp.RunNumber

	  FROM presale.tblCombinedPresale cp
	  LEFT JOIN dbo.tblBuyAuctionHouseType baht ON baht.BuyAuctionHouseTypeID = cp.BuyAuctionHouseTypeID
	  WHERE cp.VIN = @VIN
	  AND cp.SaleDate >= @TodayDate
	  ORDER BY cp.SaleDate, cp.BuyAuctionHouseTypeID

END TRY
      BEGIN CATCH

         THROW;
         RETURN -1;

      END CATCH;
   END
