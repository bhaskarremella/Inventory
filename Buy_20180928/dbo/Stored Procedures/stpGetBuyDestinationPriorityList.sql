
CREATE   PROCEDURE [dbo].[stpGetBuyDestinationPriorityList]

(@BuyAuctionVehicleID BIGINT)

/*********************************************************************************
Created By: Gwendolyn Lukemire
Created On: July 27, 2018
Description: This stored procedure provides the list of destinations for a 
			 given BuyAuctionVehicleID in order of priority		 	 

Updated By: Travis Bleile
Updated On: August 24, 2018
Description: Updated return type to provide Analytics ID number 
***********************************************************************************/
AS
   BEGIN

      --Set Environment
      SET NOCOUNT ON;
      SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

      BEGIN TRY   
--DECLARE @BuyAuctionVehicleID BIGINT

--SET @BuyAuctionVehicleID = 1352074


SELECT bdps.BuyAuctionVehicleID, elt.ExternalLocationKey, elt.ExternalLocationDescription, bdps.LocationPriority, bdps.CRLLT, elt.ExternalLocationTypeID, bdps.IDNumber
FROM dbo.tblBuyDestinationPriority bdps
LEFT JOIN bid.tblExternalLocationType elt ON elt.CRLLT = bdps.CRLLT
WHERE bdps.BuyAuctionVehicleID = @BuyAuctionVehicleID
ORDER BY bdps.LocationPriority


      END TRY
      BEGIN CATCH
         IF @@ERROR != 0
         BEGIN
            DECLARE @ErrorMessage   VARCHAR(300)   = ERROR_MESSAGE() + CHAR(13)
            DECLARE @ErrorSeverity  SMALLINT       = ERROR_SEVERITY();
            DECLARE @ErrorState     SMALLINT       = ERROR_STATE();
            SELECT
               ErrorNumber    = ERROR_NUMBER()
            ,  ErrorMessage   = @ErrorMessage
            ,  ErrorSeverity  = @ErrorSeverity
            ,  ErrorState     = @ErrorState
            ,  ErrorProcedure = ISNULL(ERROR_PROCEDURE(), 'dbo.stpGetBuyDestinationPriorityList')
            ,  ErrorLine      = ERROR_LINE();
         END;

         RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
      END CATCH;

   END;
