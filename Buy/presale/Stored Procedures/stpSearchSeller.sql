

CREATE   PROCEDURE presale.stpSearchSeller
(
   @VIN VARCHAR(17)
)
   /*----------------------------------------------------------------------------------------
   Created By  : Andrew Manginelli
   Created On  : Oct 10, 2018
   Application : Buyonic Vehicle Search
   Description : Determine if a vehicle is not in Buyonic due to seller management. Vehicle was an exclusion (RetVal = 1) for the following reasons:
                 - NoBuy seller
                 - Fleet seller and vehicle has less than 75k miles
                 - Previously owned by DT
   ------------------------------------------------------------------------------------------
   */
AS
BEGIN
BEGIN TRY
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

   DECLARE @TodayDate DATE = CAST(GETDATE() AS DATE);

   -- This #likes table is taken from the analytics buy vehicle list proc. These are the GroupID = 2 values used for fleet.
   DROP TABLE IF EXISTS #likes;
   CREATE TABLE #likes
      (
         FilterField    VARCHAR(100)    NOT NULL    PRIMARY KEY CLUSTERED
      );
   INSERT  #likes (FilterField)
           SELECT  '%ARS/AVIS%'
           UNION ALL
           SELECT  'Avis Budget Group'
           UNION ALL
           SELECT  'Avis Corporation'
           UNION ALL
           SELECT  'AVIS RAC'
           UNION ALL
           SELECT  'AVIS RENT'
           UNION ALL
           SELECT  'AVIS TRA'
           UNION ALL
           SELECT  'AVISCAR'
           UNION ALL
           SELECT  'DTG '
           UNION ALL
           SELECT  'Enterprise '
           UNION ALL
           SELECT  'Enterprise-TRA'
           UNION ALL
           SELECT  'Fox Rent A Car'
           UNION ALL
           SELECT  'Hertz'; 


   SELECT TOP(1)
      RetVal = ISNULL(CAST((CASE 
                              WHEN nbs.ManheimNoBuySellersID IS NOT NULL   THEN 1 -- NoBuy seller
                              WHEN fleet.IsFleet = 1                       THEN 1 -- Fleet seller and vehicle has less than 75k miles
                              WHEN s.VIN IS NOT NULL                       THEN 1 -- Previously owned by DT
                              ELSE 0
                            END) AS BIT), 0)
     FROM presale.tblCombinedPresale AS cp
   LEFT JOIN Analytics.tblManheimNoBuySellers AS nbs
      ON cp.Seller = nbs.SellerName
   LEFT JOIN dbo.tblStock AS s
      ON cp.VIN = s.VIN
   OUTER APPLY ( SELECT IsFleet = 1
                 FROM   #likes l
                 WHERE  (cp.Seller LIKE '%' + l.FilterField + '%')
                   AND cp.Mileage < 75000
               ) fleet
    WHERE cp.VIN = @VIN
      AND cp.SaleDate >= @TodayDate
    ORDER BY cp.SaleDate, cp.BuyAuctionHouseTypeID;

END TRY

BEGIN CATCH

    THROW;
    RETURN -1;

END CATCH
END
