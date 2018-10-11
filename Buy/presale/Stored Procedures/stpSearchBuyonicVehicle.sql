   
   CREATE   PROCEDURE [presale].[stpSearchBuyonicVehicle] 
   (
      @VIN VARCHAR(17)
   )
   /*
   ------------------------------------------------------------
   Created By:       Daniel Folz
   Created On:       Oct 4 2018
   Procedure Name:   presale.stpSearchBuyonicVehicle
   Application:      Buyonic Vehicle Search
   Description:      Determine if a vehicle exists in Buyonic
   ------------------------------------------------------------
   */
   AS
   BEGIN
      --Set Environment
      SET NOCOUNT ON;
      SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
      DECLARE @Today DATE = CAST(GETDATE() AS DATE);

      BEGIN TRY;
            
            SELECT TOP 1
               bv.VIN
            ,  f.AuctionHouse
            ,  f.AuctionName
            ,  bv.[Year]
            ,  bv.Make
            ,  bv.Model
            ,  bv.Color
            ,  bav.SaleDate
            ,  f.Mileage
            ,  bav.Lane
            ,  bav.Run
            FROM
                        dbo.tblBuyVehicle                   bv
            JOIN        dbo.tblBuyAuctionVehicle            bav   ON    bv.BuyVehicleID            = bav.BuyVehicleID
                                                                  AND   bv.VIN                     = @VIN
            JOIN        dbo.tblBuyAuctionVehicleAttributes  bava  ON    bav.BuyAuctionVehicleID    = bava.BuyAuctionVehicleID
            LEFT JOIN   dbo.tblBuyAuctionListType           balt  ON    bav.BuyAuctionListTypeID   = balt.BuyAuctionListTypeID
            LEFT JOIN   dbo.tblBuyAuctionHouseType          baht  ON    balt.BuyAuctionHouseTypeID = baht.BuyAuctionHouseTypeID
            OUTER APPLY
            (
               SELECT 
                  AuctionHouse = ISNULL(baht.AuctionHouseKey, 'Unknown')
               ,  AuctionName  = ISNULL(balt.AuctionListKey,  'Unknown')
               ,  Mileage      = COALESCE(bava.BuyerOdometer, bava.Odometer, 0)
            ) f
            WHERE
               bav.SaleDate >= @Today
            ORDER BY
               bav.SaleDate
            ,  f.AuctionHouse
 
      END TRY
      BEGIN CATCH

         THROW;
         RETURN -1;

      END CATCH;
   END
