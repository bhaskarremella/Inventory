
CREATE   PROCEDURE [presale].[zzzstpLoadAdesaPresaleTrend] 
	AS

/*******************************************************************************************************
Created By: Viv Shah
CreateDate: 11/28/2016

Purpose: Inserts a records into tblAdesaPresaleTrend. Called source pre load from INformatica: m_buy_AdesaPreSale.
		This takes all previous data from presale table and loads it into the trend table.
			
*******************************************************************************************************/

	BEGIN
	BEGIN TRY
	  SET NOCOUNT ON

	/*Add presale data into trend*/	

	DECLARE @MaxRowLoad DATETIME

	SET @MaxRowLoad = (SELECT ISNULL(MAX(TrendLoadedDateTime),CAST(GETDATE() AS DATE)) FROM buy.Presale.tblAdesaPreSaleTrend)



	----DELETE  FROM buy.Presale.tblAdesaPreSaleTrend
	----WHERE TrendLoadedDateTime < '2014-01-01'

									
	INSERT INTO [buy].[Presale].[tblAdesaPreSaleTrend]
		 ([pkAdesaPreSaleID]
		 ,[SaleDate]
		 ,[SaleType]
		 ,[OwnerID]
		 ,[ConsignorType]
		 ,[Consignor]
		 ,[Location]
		 ,[Lot]
		 ,[RunNumber]
		 ,[Year]
		 ,[Make]
		 ,[Model]
		 ,[Body]
		 ,[Series]
		 ,[Engine]
		 ,[Color]
		 ,[Odometer]
		 ,[OdometerType]
		 ,[VIN]
		 ,[OpenSale]
		 ,[Transmission]
		 ,[Options]
		 ,[Announcement]
		 ,[RowLoadTimeStamp]
		 ,[RowUpdateTimeStamp]
		 ,[TrendLoadedDateTime]
		 --New Fields
		,[OpenLaneVehicleID] 
		,[Status]
		,[Displacement] 
		,[Cylinders]
		,[DriveTrain]
		,[ChromeStyleID]
		,[InteriorColor] 
		,[VehicleType] 
		,[State] 
		,[ZipCode] 
		,[CurrentHighBid] 
		,[BINPrice] 
		,[AuctionEndDateTime]
		,[TotalDamages] 
		,[VehicleDetailURL] 
		,[ImageViewerURL] 
		,[DealerCodes] 
		,[ImageURL] 
		,[Lane] 
		,[IsRunListVehicle] 
		,[IsLiveBlockVehicle] 
		,[IsDealerBlockVehicle] 
		,[AssetType] 
		,[EqualsReserve] 
		,[VehicleListingCategory] 
		,[VehicleGrade] 
		,[ProcessingAuctionOrgID] -- 19-Jan-2016 new column (previously this was Reserved1
		,[IsAutograde]            -- 19-Jan-2016 new column (previously this was Reserved2
		,[Comment]                -- 19-Jan-2016 new column (previously this was Reserved3
		,[ChromeYear]             -- 19-Jan-2016 new column
		,[ChromeMake]             -- 19-Jan-2016 new column
		,[ChromeModel]            -- 19-Jan-2016 new column
		,[ChromeSeries]           -- 19-Jan-2016 new column
		,[TitleState]             -- 19-Jan-2016 new column
		,[Tires]                  -- 19-Jan-2016 new column
		,[InspectionDate]         -- 19-Jan-2016 new column
		,[InspectionCompany]      -- 19-Jan-2016 new column
		,[InspectionComments]     -- 19-Jan-2016 new column
		,[PriorPaint]             -- 19-Jan-2016 new column
		,[Reserved1]              -- 19-Jan-2016 new column
		,[Reserved2]              -- 19-Jan-2016 new column
		 )

		 SELECT [pkAdesaPreSaleID]
			  ,[SaleDate]
			  ,[SaleType]
			  ,[OwnerID]
			  ,[ConsignorType]
			  ,[Consignor]
			  ,[Location]
			  ,[Lot]
			  ,[RunNumber]
			  ,[Year]
			  ,[Make]
			  ,[Model]
			  ,[Body]
			  ,[Series]
			  ,[Engine]
			  ,[Color]
			  ,[Odometer]
			  ,[OdometerType]
			  ,[VIN]
			  ,[OpenSale]
			  ,[Transmission]
			  ,[Options]
			  ,[Announcement]
			  ,[RowLoadTimeStamp]
			  ,[RowUpdateTimeStamp]
			  ,GETDATE()
			,[OpenLaneVehicleID] 
			,[Status]
			,[Displacement] 
			,[Cylinders]
			,[DriveTrain]
			,[ChromeStyleID]
			,[InteriorColor] 
			,[VehicleType] 
			,[State] 
			,[ZipCode] 
			,[CurrentHighBid] 
			,[BINPrice] 
			,[AuctionEndDateTime]
			,[TotalDamages] 
			,[VehicleDetailURL] 
			,[ImageViewerURL] 
			,[DealerCodes] 
			,[ImageURL] 
			,[Lane] 
			,[IsRunListVehicle] 
			,[IsLiveBlockVehicle] 
			,[IsDealerBlockVehicle] 
			,[AssetType] 
			,[EqualsReserve] 
			,[VehicleListingCategory] 
			,[VehicleGrade] 
			,[ProcessingAuctionOrgID] -- 19-Jan-2016 new column (previously this was Reserved1
			,[IsAutograde]            -- 19-Jan-2016 new column (previously this was Reserved2
			,[Comment]                -- 19-Jan-2016 new column (previously this was Reserved3
			,[ChromeYear]             -- 19-Jan-2016 new column
			,[ChromeMake]             -- 19-Jan-2016 new column
			,[ChromeModel]            -- 19-Jan-2016 new column
			,[ChromeSeries]           -- 19-Jan-2016 new column
			,[TitleState]             -- 19-Jan-2016 new column
			,[Tires]                  -- 19-Jan-2016 new column
			,[InspectionDate]         -- 19-Jan-2016 new column
			,[InspectionCompany]      -- 19-Jan-2016 new column
			,[InspectionComments]     -- 19-Jan-2016 new column
			,[PriorPaint]             -- 19-Jan-2016 new column
			,[Reserved1]              -- 19-Jan-2016 new column
			,[Reserved2]              -- 19-Jan-2016 new column 
		  FROM [buy].[Presale].[tblAdesaPreSale] A 
		  WHERE ( A.RowLoadTimeStamp > @MaxRowLoad OR A.RowUpdateTimeStamp > @MaxRowLoad)

		  ----WHERE CONVERT(DATETIME, SaleDate) <= (SELECT CAST(AsOfDate AS DATE)
				----     FROM ODS.Presale.tblCurrent_System_Information)

	 --DELETE
	 --   FROM [buy].[Presale].[tblAdesaPreSale]
	 --  WHERE (Status = 'Removed' AND SaleDate <= (SELECT CAST(AsOfDate - 2 AS DATE) FROM ODS.Presale.tblCurrent_System_Information))
	 --  OR
	 --  (Status = 'Removed' AND IsDealerBlockVehicle IS NOT NULL AND CAST(RowLoadTimeStamp AS DATE) <= (SELECT CAST(AsOfDate - 2 AS DATE) FROM ODS.Presale.tblCurrent_System_Information))
		

	 ----DELETE
	 ----   FROM [buy].[Presale].[tblAdesaPreSale]
	 ----  WHERE (Status = 'Removed' )

	END TRY

	BEGIN CATCH
	    DECLARE @ErrorNumber    INT,
		  @ErrorSeverity  INT,
		  @ErrorState     INT,
		  @ErrorLine      INT,
		  @ErrorProcedure NVARCHAR(200),
		  @ErrorMessage   VARCHAR(4000)

	    -- Assign variables to error-handling functions that capture information for RAISERROR.
	    SELECT @ErrorNumber = ERROR_NUMBER(),
		 @ErrorSeverity = ERROR_SEVERITY(),
		 @ErrorState = ERROR_STATE(),
		 @ErrorLine = ERROR_LINE(),
		 @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');

	    -- Building the message string that will contain original error information.
	    SELECT @ErrorMessage =
		 N'Error %d, Level %d, State %d, Procedure %s, Line %d, ' +
		        'Message: ' +
		        ERROR_MESSAGE();

	    -- Use RAISERROR inside the CATCH block to return error
	    -- information about the original error that caused
	    -- execution to jump to the CATCH block.
	    RAISERROR (@ErrorMessage,-- Message text.
		     16,-- must be 16 for Informatica to pick it up
		     1,
		     @ErrorNumber,
		     @ErrorSeverity,-- Severity.
		     @ErrorState,-- State.
		     @ErrorProcedure,
		     @ErrorLine );
	END CATCH
	END  



	
