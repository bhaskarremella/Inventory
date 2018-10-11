


   CREATE   VIEW [dbo].[vBuyVehicleDataPull]
   AS
   /*
   -------------------------------------------------------------------------------------------------------------------------------------------
      CREATED BY:	   TRAVIS BLEILE
      CREATED ON:	   10/05/2017
      DESCRIPTION:	VIEW FOR SSIS PULL OF VEHILCE DATA TO DATAMART

      UPDATED BY:	   TRAVIS BLEILE
      UPDATED ON:	   1/9/2018
      DESCRIPTION:	Update to hit new decode tables to pull in decode values

      UPDATED BY:	   TRAVIS BLEILE
      UPDATED ON:	   3/20/2018
      DESCRIPTION:	Adding ProxyBidAmountDateTime & PreviewBidAmount/DateTime Columns for PULL ETL

      UPDATED BY:	   TRAVIS BLEILE
      UPDATED ON:	   4/10/2018
      DESCRIPTION:	Adding Join to bid.TblProxyBid to pull in ProxyBidEnteredBy for PULL ETL

      UPDATED BY:	   TRAVIS BLEILE
      UPDATED ON:	   06/11/2018
      DESCRIPTION:	Adding IsReconciledDateTime/IsReconciledBy from tblBuy for PULL ETL

      UPDATED BY:	   TRAVIS BLEILE
      UPDATED ON:	   07/11/2018
      DESCRIPTION:	Updates to tie Inspections/Decodes to a sale date - new tables tblBuyAuctionInspection and tblBuyAuctionDecode

      UPDATED BY:	   TRAVIS BLEILE
      UPDATED ON:	   09/26/2018
      DESCRIPTION:	Updaes to pull odometer and size values from tblBuyAuctionVehicleAttributes table
   -------------------------------------------------------------------------------------------------------------------------------------------
   */

      WITH Today
      AS
      (
         --This Current Date is used in multiple places, since I cant create the variable in a view, this is the next best thing
         --The requested behavior is 5 days back, so going 6 days back so I can evaluate using GT (>) rather than GTE (>=)
         SELECT [Date] = CAST(DATEADD(DAY, -6, GETDATE()) AS DATE)
      )
      -- 7/11 - This CTE logic is still needed because we need to split out the buyer/AIM decodes to determine what to place
      --		  in the Manual/KBB decode columns in the main query to ETL to DM. HOWEVER - I did get rid of a subquery in the  
      --		  JOIN conditions for both ManualDecodes and KBBDecodes CTE now that I do not need to look up the most recent decode.
      ,  Decodes
      AS
      (
         SELECT
            d.BuyAuctionVehicleID
         ,  d.DecodeDateTime
         ,  dt.BuyDecodeKey
         ,  d.DecodeAmount
         --CASE WHEN dt.BuyDecodeKey LIKE '%Manual%' THEN d.DecodeAmount ELSE 0 END AS ManualDecodeAmount,
         --CASE WHEN dt.BuyDecodeKey LIKE '%KBB%' THEN d.DecodeAmount Else 0 END AS KBBDecodeAmount
         FROM
                     dbo.tblBuyAuctionDecode d  WITH (NOLOCK)
         INNER JOIN  dbo.tblBuyDecodeType    dt WITH (NOLOCK) ON dt.BuyDecodeTypeID = d.BuyDecodeTypeID
         WHERE
            d.RowUpdatedDateTime > (SELECT [Date] FROM Today)
      )
      , ManualDecodes
      AS
      (
         SELECT
            d.BuyAuctionVehicleID
         ,  d.DecodeDateTime
         ,  d.DecodeAmount
         FROM
            Decodes d
         WHERE
            d.BuyDecodeKey IN ('INSPECTORMANUAL', 'ONLINEBUYERMANUAL', 'INLANEBUYERMANUAL')
      )
      , KBBDecodes
      AS
      (
         SELECT
            d.BuyAuctionVehicleID
         ,  d.DecodeDateTime
         ,  d.DecodeAmount
         FROM
            Decodes d
         WHERE
            d.BuyDecodeKey IN ('INSPECTORKBB', 'ONLINEBUYERKBB', 'INLANEBUYERKBB')
      )
      SELECT DISTINCT
         --bv.BuyVehicleID,
         VIN                           = CONVERT(NVARCHAR(50), bv.VIN)
      ,  bav.SaleDate
      ,  Lane                          = CONVERT(NVARCHAR(20), bav.Lane)
      ,  Run                           = CONVERT(NVARCHAR(20), bav.Run)
      ,  [Year]                        = CONVERT(NVARCHAR(10), bv.[Year])
      ,  Make                          = CONVERT(NVARCHAR(100), bv.Make)
      ,  Model                         = CONVERT(NVARCHAR(100), bv.Model)
      ,  Color                         = CONVERT(NVARCHAR(100), bv.Color)
      ,  Odometer					   = ISNULL(bava.BuyerOdometer,bava.Odometer) --Buyer Odo over Analyst
      ,  Announcement                  = CONVERT(NVARCHAR(100), bav.PreSaleAnnouncement)
      ,  Size                          = CONVERT(NVARCHAR(100), ISNULL(bava.Size,bava.BuyerSize)) --Analyst Size over Buyer
      ,  SellerName                    = CONVERT(NVARCHAR(20), bav.SellerName)
      ,  bav.IsPreviousDTVehicle
      ,  VehicleLink                   = CONVERT(NVARCHAR(500), bav.VehicleLink)
      ,  CRLink                        = CONVERT(NVARCHAR(100), bav.CRLink)
      ,  bav.CRScore
      ,  ManualBookValue               = md.DecodeAmount
      ,  KBBValue                      = kd.DecodeAmount
      --bi.ManualBookValue,
      --bi.KBBValue,
      ,  BuyerBucket                   = CONVERT( NVARCHAR(100)
                                                , CASE
                                                     WHEN bt.BuyKey = 'NOACTIVITY' THEN 'No Activity'
                                                     WHEN bt.BuyKey = 'WON' THEN 'Won'
                                                     WHEN bt.BuyKey = 'LOST' THEN 'Lost'
                                                     WHEN bt.BuyKey = 'NOBID' THEN 'No Bid'
                                                  END
                                                )
      ,  bi.EstimatedReconTotal
      ,  bav.PriceCap
      ,  NoBidReason                   = CONVERT(NVARCHAR(220), nbrt.BuyNoBidReasonDescription)
      ,  bav.ProxyBidAmount
      ,  bav.ProxyBidAmountDateTime
      ,  bav.PreviewBidAmount
      ,  bav.PreviewBidAmountDateTime
      ,  b.LastBidAmount
      ,  BuyerDispositionDateTime      = CONVERT(DATETIME2(3), b.RowUpdatedDateTime)
      ,  BuyerName                     = CONVERT(NVARCHAR(220), b.BuyerName)
      ,  BuyerEmail                    = CONVERT(NVARCHAR(220), b.BuyerEmail)
      ,  BuyerEmployeeID               = CONVERT(NVARCHAR(15), b.BuyerEmployeeID)
      ,  AuctionName                   = CONVERT(NVARCHAR(100), balt.AuctionListDescription)
      --IsReviewed/ReviewedBy/DateTime
      --,  IsReviewed                    = CASE WHEN bi.BuyInspectionTypeID IN (2, 3) THEN 1 ELSE 0 END
      ,  ir.IsReviewed
      --,  ReviewedBy                    = CONVERT(NVARCHAR(50), CASE WHEN bi.BuyInspectionTypeID IN (2, 3) THEN bi.InspectorName ELSE NULL END)
      ,  ReviewedBy                    = CONVERT(NVARCHAR(50), CASE WHEN ir.IsReviewed = 1 THEN bi.InspectorName ELSE NULL END)
      --,  ReviewedByDateTime            = CASE WHEN bi.BuyInspectionTypeID IN (2, 3) THEN CONVERT(DATETIME2(3), bi.RowUpdatedDateTime) ELSE NULL END
      ,  ReviewedByDateTime            = CASE WHEN ir.IsReviewed = 1 THEN CONVERT(DATETIME2(3), bi.RowUpdatedDateTime) ELSE NULL END
      ,  bav.IsDecommissioned          
      ,  IsDecommissionedDateTime      = CONVERT(DATETIME2(3), bav.IsDecommissionedDateTime)
      ,  IsDTInspectionRequested       = CONVERT(TINYINT, bav.IsDTInspectionRequested)
      --bi.InspectorName,              
      --bi.InspectorEmail,             
      --bi.InspectorEmployeeID,        
      ,  IsInspectionFailed            = CONVERT(TINYINT, bi.IsInspectionFailed)
      --bifrt.BuyInspectionFailReasonDescription,
      ,  IsDTPreferred                 = CONVERT(TINYINT, bi.IsDTPreferred)
      ,  bi.DashboardLights
      ,  bi.InspectionNotes
      ,  bi.EstimatedReconTireGlass
      ,  bi.EstimatedReconExteriorCosmetic
      ,  bi.EstimatedReconInterior
      ,  bi.EstimatedReconOther
      ,  pb.ProxyBidEnteredBy
      ,  b.IsReconciledDateTime
      ,  b.IsReconciledBy
      FROM
                  dbo.tblBuyVehicle                   bv    WITH (NOLOCK) 
      INNER JOIN  dbo.tblBuyAuctionVehicle            bav   WITH (NOLOCK) ON bav.BuyVehicleID                    = bv.BuyVehicleID
	  INNER JOIN  dbo.tblBuyAuctionVehicleAttributes  bava	WITH (NOLOCK) ON bava.BuyAuctionVehicleID			 = bav.BuyAuctionVehicleID
      INNER JOIN  dbo.tblBuyAuctionListType           balt  WITH (NOLOCK) ON balt.BuyAuctionListTypeID           = bav.BuyAuctionListTypeID
      LEFT JOIN   dbo.tblBuy                          b     WITH (NOLOCK) ON b.BuyAuctionVehicleID               = bav.BuyAuctionVehicleID
      LEFT JOIN   dbo.tblBuyType                      bt    WITH (NOLOCK) ON bt.BuyTypeID                        = b.BuyTypeID
      LEFT JOIN   dbo.tblBuyNoBidReasonType           nbrt  WITH (NOLOCK) ON nbrt.BuyNoBidReasonTypeID           = b.BuyNoBidReasonTypeID
      LEFT JOIN   dbo.tblBuyAuctionInspection         bi    WITH (NOLOCK) ON bi.BuyAuctionVehicleID              = bav.BuyAuctionVehicleID
																				AND bi.BuyInspectionTypeID IN (2,3)
      OUTER APPLY (SELECT IsReviewed = CASE WHEN bi.BuyInspectionTypeID IN (2, 3) THEN 1 ELSE 0 END) ir
      LEFT JOIN   dbo.tblBuyInspectionFailReasonType  bifrt WITH (NOLOCK) ON bifrt.BuyInspectionFailReasonTypeID = bi.BuyInspectionFailReasonTypeID
      LEFT JOIN   dbo.tblBuyInspectionType            it    WITH (NOLOCK) ON it.BuyInspectionTypeID              = bi.BuyInspectionTypeID
      LEFT JOIN   KBBDecodes                          kd    WITH (NOLOCK) ON kd.BuyAuctionVehicleID              = bav.BuyAuctionVehicleID
      LEFT JOIN   ManualDecodes                       md    WITH (NOLOCK) ON md.BuyAuctionVehicleID              = bav.BuyAuctionVehicleID
      LEFT JOIN   bid.tblProxyBid                     pb    WITH (NOLOCK) ON pb.BuyAuctionVehicleID              = bav.BuyAuctionVehicleID
      WHERE
         /*Vehicles that were dispositioned in the past 5 days (QuickBuyDateTime)*/
         b.RowUpdatedDateTime > (SELECT [Date] FROM Today)

      /*If inspection is done by an online/inlanebuyer...Then give me the inspections for the the past 5 days (ReviewedByDateTime)*/
      --OR CASE WHEN bi.BuyInspectionTypeID IN (2, 3) THEN bi.RowUpdatedDateTime ELSE NULL END > (SELECT [Date] FROM Today)
      OR (CASE WHEN ir.IsReviewed = 1 THEN bi.RowUpdatedDateTime ELSE NULL END) > (SELECT [Date] FROM Today)

      /*All inspection requested/proxied/previewed vehicles within 5 days of their saledate */
      OR
      (
            (
                  bav.IsDTInspectionRequested   = 1
               OR bav.ProxyBidAmount            IS NOT NULL
               OR bav.PreviewBidAmount          IS NOT NULL
            ) 
         AND   bav.SaleDate  > (SELECT [Date] FROM Today)
      )

      /*Decodes on vehicles that have a saledate after or on the same day as the decode was completed*/
      OR (bav.SaleDate  >= CAST(kd.DecodeDateTime AS DATE))
      OR (bav.SaleDate  >= CAST(md.DecodeDateTime AS DATE))

	  /*Buyer has updated the vehicle size or or odometer in the past 5 days*/
	  OR (bava.BuyerSizeUpdatedDateTime > (SELECT [Date] FROM Today))
	  OR (bava.BuyerOdometerUpdatedDateTime > (SELECT [Date] FROM Today))
