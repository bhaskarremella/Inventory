
   CREATE   VIEW [dbo].[vBuyInspectionDataPull]
   /*
   ------------------------------------------------------------------------------------------------
      CREATED BY:	   TRAVIS BLEILE
      CREATED ON:	   2/20/2018
      DESCRIPTION:   VIEW FOR SSIS PULL OF BUYONIC INSPECTION DATA TO DATAMART

      UPDATED BY:	   TRAVIS BLEILE
      UPDATED ON:	   7/11/2018
      DESCRIPTION:	Updating logic to utilize tblBuyAuctionInspection instead of our AVIS table
   ------------------------------------------------------------------------------------------------
   */
   AS

      SELECT
         bav.BuyAuctionVehicleID
      ,  VIN                        = CAST(bv.VIN                      AS NVARCHAR(50))
      ,  AuctionName                = CAST(balt.AuctionListDescription AS NVARCHAR(100))
      ,  bav.SaleDate
      ,  Color                      = CAST(bv.Color            AS NVARCHAR(100))
      ,  InspectorName              = CAST(bi.InspectorName    AS NVARCHAR(220))
      ,  InspectorEmail             = CAST(bi.InspectorEmail   AS NVARCHAR(220))
      ,  InspectionBucket           = CAST(CASE bi.InspectionStatusKey
                                              WHEN 'CRCOMPLETED'     THEN 'Has Manheim CR'
                                              WHEN 'VEHICLENOTFOUND' THEN 'Vehicle Not Found'
                                              WHEN 'NOTSTARTED'      THEN 'Inspection Not Started'
                                              WHEN 'STARTED'         THEN 'Inspection Started'
                                              WHEN 'COMPLETED'       THEN 'Inspection Complete'
                                           END AS NVARCHAR(220))
      ,  InspectionSurveyStartDT    = bi.InspectionStartedDateTime
      ,  InspectionSurveyEndDT      = bi.InspectionCompletedDateTime
      ,  bi.VehicleNotFoundDateTime
      FROM
            dbo.tblBuyAuctionVehicle      bav
      JOIN  dbo.tblBuyVehicle             bv    ON    bv.BuyVehicleID            = bav.BuyVehicleID
    --JOIN dbo.tblBuyInspection           i     ON    i.BuyVehicleID             = bv.BuyVehicleID
      JOIN  dbo.tblBuyAuctionInspection   bi    ON    bi.BuyAuctionVehicleID     = bav.BuyAuctionVehicleID
      JOIN  dbo.tblBuyAuctionListType     balt  ON    balt.BuyAuctionListTypeID  = bav.BuyAuctionListTypeID
      JOIN  dbo.tblBuyInspectionType      it    ON    it.BuyInspectionTypeID     = bi.BuyInspectionTypeID
                                                AND   it.BuyInspectionKey        = 'AIMINSPECTOR'           --<---7/11: Need this because we only pull down AIM Inspector data into DM for this pipeline
      WHERE
         bi.RowUpdatedDateTime > DATEADD(DAY, -6, CAST(GETDATE() AS DATE));

