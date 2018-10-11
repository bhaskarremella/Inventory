

   CREATE  PROCEDURE [dbo].[stpGetActionableVehicles]
   (
      @EmployeeID  VARCHAR(250),
	  @FutureDate VARCHAR(250)
   )


    /*
      Created By:		Jeremy Johnson
      Created On:		10/01/2018
      Description:		Grabs vehicles for action items section of Buyonic Application

      Sample Execution:
                        USE [Buy]
                        GO

                        EXEC	[dbo].[stpGetActionableVehicles] 
   */
AS 

 
BEGIN
	Begin TRY	

		SELECT
				bav.BuyAuctionVehicleID 
				,bav.BuyVehicleID 
				,bav.BuyAuctionListTypeID 
				,bav.RowLoadedDateTime
				,bav.RowUpdatedDateTime
				,bav.LastChangedByEmpID 
				,bav.SaleDate 
				,bav.Lane 
				,bav.Run 
				,bav.Odometer 
				,bav.SellerName 
				,bav.VehicleLink 
				,bav.CRLink 
				,bav.CRScore 
				,bav.PreSaleAnnouncement 
				,bav.PriceCap
				,bav.IsPreviousDTVehicle 
				,bav.IsDTInspectionRequested 
				,bav.IsDecommissioned 
				,bav.IsDecommissioned 
				,bav.IsDecommissionedDate 
				,bav.KBBMultiplier 
				,bav.KBBDTAdjustmentValue 
				,bav.ProxyBidAmount 
				,bav.ProxyBidAmount 
				,bav.PreviewBidAmount 
				,bav.PreviewBidAmount 
				,bav.MMRValue 
				,bav.BuyStrategyID 
				,bav.Images 
				,bav.IsAccuCheckIssue 
				,bav.IsAccuCheckIssue 
				,bav.IsInspectorAppVehicle 
				,bav.IsBuyerAppVehicle 
				,bav.IsDecommissionedInspection 
				,bav.IsDecommissionedInspection 
				,bav.DestinationConfirmationDateTime
				,bav.ExternalLocationTypeID 
				,bav.DestinationLastChangedByEmpID 
				,bav.BuyAuctionGuaranteeTypeID
				,balt.BuyAuctionListTypeID 
				,balt.BuyAuctionHouseTypeID 
				,balt.RowLoadedDateTime 
				,balt.RowUpdatedDateTime 
				,balt.LastChangedByEmpID 
				,balt.AuctionListKey 
				,balt.AuctionListDescription 
				,balt.Address 
				,balt.City 
				,balt.State 
				,balt.ZipCode 
				,balt.IsActive 
				,balt.ExternalAuctionID 
				,baht.BuyAuctionHouseTypeID 
				,baht.RowLoadedDateTime 
				,baht.RowUpdatedDateTime 
				,baht.LastChangedByEmpID 
				,baht.AuctionHouseKey 
				,baht.AuctionHouseDescription 
				,baht.IsActive 

		FROM Buy..tblBuyVehicle  bv 
		LEFT JOIN Buy..tblBuyAuctionVehicle bav on bv.BuyVehicleID = bav.BuyVehicleID 
		LEFT JOIN BUy..tblBuy b on b.BuyAuctionVehicleID = bav.BuyAuctionVehicleID 
		LEFT JOIN Buy..tblBuyAuctionActionItem BAAI on BAAI.BuyAuctionVehicleID = bav.BuyAuctionVehicleID
		LEFT JOIN Buy..tblBuyAuctionListType balt on balt.BuyAuctionListTypeID = bav.BuyAuctionListTypeID 
		LEFT JOIN Buy..tblBuyAuctionHouseType baht on baht.BuyAuctionHouseTypeID = balt.BuyAuctionHouseTypeID 
		LEFT JOIN buy.bid.tblExternalLocationType elt on elt.ExternalLocationTypeID = bav.ExternalLocationTypeID 
		LEFT JOIN Buy..tblBuyType bt on bt.BuyTypeID = b.BuyTypeID 
		WHERE bav.SaleDate >= GetDate() AND bav.SaleDate <= @FutureDate 
		AND (bav.IsAccuCheckIssue = 1 OR bav.IsDecommissioned = 1 AND bav.IsDecommissionedDate <= bav.SaleDate) 
		AND bav.ProxyBidAmount > 1 
		AND bav.SaleDate >= GETDATE() 
		AND b.BuyID IS NULL 
		AND BAAI.ActionedByEmployeeID = @EmployeeID 
		AND BAAI.IsActive = 1


		END TRY


      BEGIN CATCH
      /*------------------------------------------------------
      Special catch logic only good for SELECT type procedures
      Because it does not contain rollback code.
      ------------------------------------------------------*/
          DECLARE 
              @ErrorNumber     INT,
              @ErrorSeverity   INT,
              @ErrorState      INT,
              @ErrorLine       INT,
              @ErrorProcedure  NVARCHAR(200),
              @ErrorMessage    VARCHAR(4000)

          -- Assign variables to error-handling functions that capture information for RAISERROR.
          SELECT 
              @ErrorNumber    = ERROR_NUMBER(),
              @ErrorSeverity  = ERROR_SEVERITY(),
              @ErrorState     = ERROR_STATE(),
              @ErrorLine      = ERROR_LINE(),
              @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');

          -- Building the message string that will contain original error information.
          SELECT @ErrorMessage = 
              N'Error %d, Level %d, State %d, Procedure %s, Line %d, ' + 
                  'Message: '+ ERROR_MESSAGE();

          -- Use RAISERROR inside the CATCH block to return error
          -- information about the original error that caused
          -- execution to jump to the CATCH block.
          RAISERROR (@ErrorMessage, -- Message text.
                     16,  -- must be 16 for Informatica to pick it up
                     1,
                     @ErrorNumber,
                     @ErrorSeverity, -- Severity.
                     @ErrorState, -- State.
                     @ErrorProcedure,
                     @ErrorLine
                     );

          -- Return a negative number so that if the calling code is using a LINK server, it will
          -- be able to test that the procedure failed.  Without this, there are some lower type of 
          -- errors that do not show up across the LINK as an error.  This causes ProcessControl 
          -- in particular to not see that the procedure failed which is bad.
          RETURN -1;
      END CATCH
   END;


