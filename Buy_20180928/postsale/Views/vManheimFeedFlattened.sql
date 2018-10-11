
         
   CREATE   VIEW [postsale].[vManheimFeedFlattened] WITH SCHEMABINDING 
   AS
   /*-------------------------------------------------------------------------------------------------------
   Created By  : Andrew Manginelli
   Created On  : Feb 10, 2017
   Description : This view takes all of the fields from all of the Postsale tables and combines
                 them into a flat result set for data validations.

   Modified By : Andrew Manginelli
   Modified On : May 8, 2018
   Description : Commented out tables that Analytics does not need. Also casting varchar columns containing
                 date/time data to datetime2. This view will now be used as the source to the Informatica
                 workflow wf_InventoryDM_postsale_tblManheimFeed to ETL the data to DM.
   ---------------------------------------------------------------------------------------------------------
   */
   
   SELECT
        MF.ManheimFeedID 
      , MF.ListingID 
      , CAST(MF.CreatedOn AS DATETIME2(7))                                       AS CreatedOn 
      , CAST(MF.PurchaseDate AS DATETIME2(3))                                    AS ManheimFeedPurchaseDate
      , MF.Channel 
      , MF.VIN                                                                   AS ManheimFeedVIN
      , MF.[Status]                                                              AS ManheimFeedStatus
      , MFL.UniqueID 
      , CAST(MFL.PurchaseDate AS DATETIME2(3))                                   AS ManheimFeedListingPurchaseDate
      , CAST(MFL.BlockTimestamp AS DATETIME2(3))                                 AS BlockTimestamp
      , MFL.PurchaseOfferExists 
      , MFL.PurchasePrice 
      , MFL.Currency 
      , MFL.VehicleStatus 
      , MFL.PurchaseApplication 
      , MFL.PurchaseMethod 
      , FLC.WorkOrderNumber                                                      AS ManheimFeedListingConsignmentWorkOrderNumber
      , CAST(FLO.StartDate AS DATETIME2(3))                                      AS StartDate 
      , CAST(FLO.EndDate AS DATETIME2(3))                                        AS EndDate
      , CAST(FLO.RegistrationDate AS DATETIME2(3))                               AS RegistrationDate
      , FLO.OfferingApplication 
      , FLO.OfferMethod 
      , FLO.SaleType 
      , FLO.AsIs 
      , FLO.Salvage 
      , FLO.ConsignorCode 
      , FLO.BidRestriction 
      , FLO.OfferingStatus 
      , FLO.OfferingStatusReason 
      , FLB.DealerNumber                                                         AS ManheimFeedListingBuyerDealerNumber
      , FLB.DealerName                                                           AS ManheimFeedListingBuyerDealerName
      , FLB.BidderBadge 
      , FLB.Href                                                                 AS ManheimFeedListingBuyerHref
      --, FLI.Href                                                                 AS ManheimFeedListingInvoiceHref
      , CAST(REPLACE(FLT.ReceivedOn, '+0000', '') AS DATETIME2(3))               AS ReceivedOn
      , CAST(REPLACE(FLT.UpdatedOn, '+0000', '') AS DATETIME2(3))                AS UpdatedOn
      , FLT.[Status]                                                             AS ManheimFeedListingTitleStatus
      , FLT.TitleNotRequired 
      , FLT.VIN                                                                  AS ManheimFeedListingTitleVIN
      , FLT.[Year]                                                               AS ManheimFeedListingTitleYear
      , FLT.Make                                                                 AS ManheimFeedListingTitleMake
      , FLT.Model                                                                AS ManheimFeedListingTitleModel
      , FLT.BodyStyle 
      , FLT.Href                                                                 AS ManheimFeedListingTitleHref
      , CAST(PSI.StatusTimestamp AS DATETIME2(3))                                AS StatusTimestamp
      , PSI.[Status]                                                             AS ManheimFeedListingPostSaleInspectionStatus
      , PSI.StatusReason 
      , PSI.InspectionType 
      , PSI.LegacyPSICode 
      , PSI.LegacyDay14Flag 
      , PSI.Href                                                                 AS ManheimFeedListingPostSaleInspectionHref
      , LCM.[Count] 
      , LCM.Href                                                                 AS ManheimFeedListingCommentsHref
      , LCU.VIN                                                                  AS ManheimFeedListingConsignmentUnitVIN
      , LCU.ModelYear                                                            AS ManheimFeedListingConsignmentUnitModelYear
      , LCU.Make                                                                 AS ManheimFeedListingConsignmentUnitMake
      , LCU.Model                                                                AS ManheimFeedListingConsignmentUnitModel
      , LCU.[Trim]
      , LCU.Body 
      , LCU.EngineDescription 
      , LCU.OdometerReading 
      , LCU.OdometerUnits 
      , LCU.VehicleType 
      , LCU.InteriorColor 
      , LCU.ExteriorColor 
      , LCS.DealerNumber                                                         AS ManheimFeedListingConsignmentSellerDealerNumber
      , LCS.DealerName                                                           AS ManheimFeedListingConsignmentSellerDealerName
      , OOL.LocationName                                                         AS ManheimFeedListingOfferingOperatingLocationLocationName
      , OOL.LocationCode                                                         AS ManheimFeedListingOfferingOperatingLocationLocationCode
      , OOL.Href                                                                 AS ManheimFeedListingOfferingOperatingLocationHref
      , OSK.SaleYear 
      , OSK.SaleNumber 
      , OSK.LaneNumber 
      , OSK.RunNumber 
      , LBR.RepNumber 
      , LBR.RepName 
      , LBR.Href                                                                 AS ManheimFeedListingBuyerRepHref
      , LTO.Reading 
      , LTO.Units 
      , TOL.LocationName                                                         AS ManheimFeedListingTitleOperatingLocationLocationName
      , TOL.LocationCode                                                         AS ManheimFeedListingTitleOperatingLocationLocationCode
      , TOL.Href                                                                 AS ManheimFeedListingTitleOperatingLocationHref
      --, IOL.LocationName                                                         AS ManheimFeedListingPostSaleInspectionOperatingLocationLocationName
      --, IOL.LocationCode                                                         AS ManheimFeedListingPostSaleInspectionOperatingLocationLocationCode
      --, IOL.Href                                                                 AS ManheimFeedListingPostSaleInspectionOperatingLocationHref
      --, SIC.WorkOrderNumber                                                      AS ManheimFeedListingPostSaleInspectionConsignmentWorkOrderNumber
      , UPL.Offsite 
      , UPL.LocationName                                                         AS ManheimFeedListingConsignmentUnitPhysicalLocationLocationName
      , UPL.LocationCode                                                         AS ManheimFeedListingConsignmentUnitPhysicalLocationLocationCode
      , UPL.Href                                                                 AS ManheimFeedListingConsignmentUnitPhysicalLocationHref
      --, ICU.VIN                                                                  AS ManheimFeedListingPostSaleInspectionConsignmentUnitVIN
      --, ICU.ModelYear                                                            AS ManheimFeedListingPostSaleInspectionConsignmentUnitModelYear
      --, ICU.Make                                                                 AS ManheimFeedListingPostSaleInspectionConsignmentUnitMake
      --, ICU.Model                                                                AS ManheimFeedListingPostSaleInspectionConsignmentUnitModel
      , PLA.Address1 
      , PLA.City 
      , PLA.StateProvinceRegion 
      , PLA.Country 
      , PLA.PostalCode
      --, MFL.ManheimFeedListingID 
      --, FLC.ManheimFeedListingConsignmentID 
      --, FLO.ManheimFeedListingOfferingID 
      --, FLB.ManheimFeedListingBuyerID 
      --, FLI.ManheimFeedListingInvoiceID 
      --, FLT.ManheimFeedListingTitleID 
      --, PSI.ManheimFeedListingPostSaleInspectionID 
      --, LCM.ManheimFeedListingCommentsID 
      --, LCU.ManheimFeedListingConsignmentUnitID 
      --, LCS.ManheimFeedListingConsignmentSellerID 
      --, OOL.ManheimFeedListingOfferingOperatingLocationID 
      --, OSK.ManheimFeedListingOfferingSaleKeyID 
      --, LBR.ManheimFeedListingBuyerRepID 
      --, LTO.ManheimFeedListingTitleOdometerID 
      --, TOL.ManheimFeedListingTitleOperatingLocationID 
      --, IOL.ManheimFeedListingPostSaleInspectionOperatingLocationID 
      --, SIC.ManheimFeedListingPostSaleInspectionConsignmentID 
      --, UPL.ManheimFeedListingConsignmentUnitPhysicalLocationID 
      --, ICU.ManheimFeedListingPostSaleInspectionConsignmentUnitID 
      --, PLA.ManheimFeedListingConsignmentUnitPhysicalLocationAddressID 
      , MF.RowLoadedDateTime
   FROM
      postsale.tblManheimFeed AS MF
      INNER JOIN postsale.tblManheimFeedListing AS MFL
         ON MFL.ManheimFeedID = MF.ManheimFeedID
      INNER JOIN postsale.tblManheimFeedListingConsignment AS FLC
         ON FLC.ManheimFeedListingID = MFL.ManheimFeedListingID
      INNER JOIN postsale.tblManheimFeedListingOffering AS FLO
         ON FLO.ManheimFeedListingID = MFL.ManheimFeedListingID
      INNER JOIN postsale.tblManheimFeedListingBuyer AS FLB
         ON FLB.ManheimFeedListingID = MFL.ManheimFeedListingID
      --INNER JOIN postsale.tblManheimFeedListingInvoice AS FLI
      --   ON FLI.ManheimFeedListingID = MFL.ManheimFeedListingID
      INNER JOIN postsale.tblManheimFeedListingTitle AS FLT
         ON FLT.ManheimFeedListingID = MFL.ManheimFeedListingID
      INNER JOIN postsale.tblManheimFeedListingPostSaleInspection AS PSI
         ON PSI.ManheimFeedListingID = MFL.ManheimFeedListingID
      INNER JOIN postsale.tblManheimFeedListingComments AS LCM
         ON LCM.ManheimFeedListingID = MFL.ManheimFeedListingID
      INNER JOIN postsale.tblManheimFeedListingConsignmentUnit AS LCU
         ON LCU.ManheimFeedListingConsignmentID = FLC.ManheimFeedListingConsignmentID
      INNER JOIN postsale.tblManheimFeedListingConsignmentSeller AS LCS
         ON LCS.ManheimFeedListingConsignmentID = FLC.ManheimFeedListingConsignmentID
      INNER JOIN postsale.tblManheimFeedListingOfferingOperatingLocation AS OOL
         ON OOL.ManheimFeedListingOfferingID = FLO.ManheimFeedListingOfferingID
      INNER JOIN postsale.tblManheimFeedListingOfferingSaleKey AS OSK
         ON OSK.ManheimFeedListingOfferingID = FLO.ManheimFeedListingOfferingID
      INNER JOIN postsale.tblManheimFeedListingBuyerRep AS LBR
         ON LBR.ManheimFeedListingBuyerID = FLB.ManheimFeedListingBuyerID
      INNER JOIN postsale.tblManheimFeedListingTitleOdometer LTO
         ON LTO.ManheimFeedListingTitleID = FLT.ManheimFeedListingTitleID
      INNER JOIN postsale.tblManheimFeedListingTitleOperatingLocation AS TOL
         ON TOL.ManheimFeedListingTitleID = FLT.ManheimFeedListingTitleID
      --INNER JOIN postsale.tblManheimFeedListingPostSaleInspectionOperatingLocation AS IOL
      --   ON IOL.ManheimFeedListingPostSaleInspectionID = PSI.ManheimFeedListingPostSaleInspectionID
      --INNER JOIN postsale.tblManheimFeedListingPostSaleInspectionConsignment AS SIC
      --   ON SIC.ManheimFeedListingPostSaleInspectionID = PSI.ManheimFeedListingPostSaleInspectionID
      INNER JOIN postsale.tblManheimFeedListingConsignmentUnitPhysicalLocation AS UPL
         ON UPL.ManheimFeedListingConsignmentUnitID = LCU.ManheimFeedListingConsignmentUnitID
      --INNER JOIN postsale.tblManheimFeedListingPostSaleInspectionConsignmentUnit AS ICU
      --   ON ICU.ManheimFeedListingPostSaleInspectionConsignmentID = SIC.ManheimFeedListingPostSaleInspectionConsignmentID
      INNER JOIN postsale.tblManheimFeedListingConsignmentUnitPhysicalLocationAddress AS PLA
         ON PLA.ManheimFeedListingConsignmentUnitPhysicalLocationID = UPL.ManheimFeedListingConsignmentUnitPhysicalLocationID;

