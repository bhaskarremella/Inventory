

CREATE PROCEDURE [dbo].[stpInsertUpdateBuyNetEntry]

/*********************************************************************************
Created By: Travis Bleile
Created On: 8/29/2018
Description: Stored proc that Insert/Updates data into dbo.tblBuyNetEntry to be
				Replicated to DWH	 	 
***********************************************************************************/

AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON;

        -- Get if the session is in transaction state yet or not
        -- Detect if the procedure was called from an active transaction and save that for later use. In the procedure, 
        -- @TranCount = 0 means there was no active transaction and the procedure started one. @TranCount > 0 means 
        -- an active transaction was started before the procedure was called.
        -- No active transaction so begin one
        -- Create a savepoint to be able to roll back only the work done in the procedure if there is an error
        -- use first or last 32 BUT KEEP IT THE SAME NAME FOR THE ROLLBACK BELOW;
        DECLARE @TranCount INTEGER = @@TRANCOUNT;
		DECLARE @DateFilter DATE

		SET @DateFilter = DATEADD(d, -11, CAST(GETDATE() AS DATE))

        IF @TranCount = 0
            BEGIN TRANSACTION;
        ELSE
            SAVE TRANSACTION stpInsertUpdateBuyNetEntry;

        --GET Comparison Data
        IF OBJECT_ID('tempdb..#GetCompareData') IS NOT NULL
            DROP TABLE #GetCompareData;


        --Declare TempTable & Make Vin/AuctionName/Saledate PK
        CREATE TABLE #GetCompareData
        (
            VIN VARCHAR(17),
            AuctionName VARCHAR(200),
            PurchaseDate DATE
                PRIMARY KEY CLUSTERED
                (
                    VIN,
                    AuctionName,
                    PurchaseDate
                )
        );

        INSERT INTO #GetCompareData
        (
            VIN,
            AuctionName,
            PurchaseDate
        )
        SELECT VIN,
               AuctionName,
               PurchaseDate
        --INTO #GetCompareData
        FROM dbo.tblBuyNetEntry
        WHERE PurchaseDate > @DateFilter; -- DECLARE VARIABLE

        --GET FEES
        IF OBJECT_ID('tempdb..#GetFees') IS NOT NULL
            DROP TABLE #GetFees;

        --Declare TempTable

		        CREATE TABLE #GetFees
        (
            BuyAuctionVehicleID BIGINT,
            FeeAmount DECIMAL(10,4),
            BuyAuctionFeeCategoryTypeID BIGINT
        );

		INSERT INTO #GetFees
		(
		    BuyAuctionVehicleID,
		    FeeAmount,
		    BuyAuctionFeeCategoryTypeID
		)
        SELECT
               baf.BuyAuctionVehicleID,
               baf.FeeAmount,
               ft.BuyAuctionFeeCategoryTypeID
        FROM mybuys.tblBuyAuctionFee baf
            JOIN Buy.mybuys.tblBuyAuctionFeeType ft
                ON ft.BuyAuctionFeeTypeID = baf.BuyAuctionFeeTypeID;

        --GET BUYER FEES
        IF OBJECT_ID('tempdb..#GetBuyerFees') IS NOT NULL
            DROP TABLE #GetBuyerFees;

        SELECT DISTINCT
            GF.BuyAuctionVehicleID,
            SUM(GF.FeeAmount) OVER (PARTITION BY GF.BuyAuctionVehicleID) AS BuyerFee
        INTO #GetBuyerFees
        FROM #GetFees GF
        WHERE GF.BuyAuctionFeeCategoryTypeID = 1;

        --GET OTHER FEES
        IF OBJECT_ID('tempdb..#GetOtherFees') IS NOT NULL
            DROP TABLE #GetOtherFees;

        SELECT DISTINCT
            GF.BuyAuctionVehicleID,
            SUM(GF.FeeAmount) OVER (PARTITION BY GF.BuyAuctionVehicleID) AS OtherFee
        INTO #GetOtherFees
        FROM #GetFees GF
        WHERE GF.BuyAuctionFeeCategoryTypeID IN ( 2, 5 );


        --#SEMIFINAL

        IF OBJECT_ID('tempdb..#SemiFinal') IS NOT NULL
            DROP TABLE #SemiFinal;

        SELECT --b.BuyAuctionVehicleID,
            RecordLocator = 3090000000 + b.BuyNetID,
            bv.VIN,
            bv.Year,
            bv.Make,
            bv.Model,
            bav.Odometer,
            bv.Size,
            b.BuyerName,
            b.BuyerEmployeeID,
            elt.SourcingRegion,
            elt.CRLLT,
            PurchaseDate = bav.SaleDate,
            AuctionHouse = baht.AuctionHouseKey,
            AuctionName = balt.AuctionListKey,
            BidTypeKey = CASE
                             WHEN COALESCE(bav.ProxyBidAmountDateTime, '') > COALESCE(bav.PreviewBidAmountDateTime, '') THEN
                                 'PROXY'
                             WHEN COALESCE(bav.PreviewBidAmountDateTime, '') > COALESCE(bav.ProxyBidAmountDateTime, '') THEN
                                 'PREVIEW'
                             ELSE
                                 'UNDEFINED'
                         END,
            PurchaseChannel = NULL,
            bav.IsPreviousDTVehicle,
            bav.SellerName,
            b.LastBidAmount,
            BuyerFee = COALESCE(gbf.BuyerFee,0),
            OtherFee = COALESCE(gof.OtherFee,0),
            IsIfBid = 0,
            IsDeleted = CASE
                            WHEN b.IsReconciledDateTime IS NULL THEN
                                1
                            ELSE
                                0
                        END,
            IsInsert = 0
        INTO #SemiFinal
        FROM dbo.tblBuyAuctionVehicle bav
            JOIN dbo.tblBuyVehicle bv
                ON bv.BuyVehicleID = bav.BuyVehicleID
                   AND bav.SaleDate > @DateFilter --DECLARE VARIABLE
                   AND bav.DestinationConfirmationDateTime IS NOT NULL
            JOIN dbo.tblBuy b
                ON b.BuyAuctionVehicleID = bav.BuyAuctionVehicleID
                   AND b.BuyNetID IS NOT NULL
                   AND b.BuyTypeID = 1
            JOIN mybuys.tblBuyNet bn
                ON bn.BuyNetID = b.BuyNetID
            LEFT JOIN dbo.tblBuyAuctionListType balt
                ON balt.BuyAuctionListTypeID = bav.BuyAuctionListTypeID
            LEFT JOIN dbo.tblBuyAuctionHouseType baht
                ON baht.BuyAuctionHouseTypeID = balt.BuyAuctionHouseTypeID
            LEFT JOIN bid.tblExternalLocationType elt
                ON elt.ExternalLocationTypeID = bav.ExternalLocationTypeID
            LEFT JOIN #GetBuyerFees gbf
                ON gbf.BuyAuctionVehicleID = bav.BuyAuctionVehicleID
            LEFT JOIN #GetOtherFees gof
                ON gof.BuyAuctionVehicleID = bav.BuyAuctionVehicleID;


        UPDATE sf
        SET IsInsert = 1
        --SELECT *
        FROM #SemiFinal sf
            LEFT JOIN #GetCompareData gcd
                ON gcd.VIN = sf.VIN
                   AND gcd.AuctionName = sf.AuctionName
                   AND gcd.PurchaseDate = sf.PurchaseDate
        WHERE gcd.VIN IS NULL;

-- SELECT * FROM #SemiFinal

        ----BEGIN INSERT/UPDATE
        INSERT INTO dbo.tblBuyNetEntry
        (
            RecordLocator,
            RowLoadedDateTime,
            RowUpdatedDateTime,
            LastChangedByEmpID,
            VIN,
            Year,
            Make,
            Model,
            Mileage,
            Size,
            BuyerName,
            BuyerEmpID,
            SourcingRegion,
            CRLLT,
            PurchaseDate,
            AuctionHouse,
            AuctionName,
            BidTypeKey,
            PurchaseChannel,
            IsPreviousDTVehicle,
            SellerName,
            BaseCost,
            BuyerFee,
            OtherFee,
            IsIfBid,
            IsDeleted
        )
        SELECT RecordLocator,
               SYSDATETIME(),
               SYSDATETIME(),
               NULL,
               VIN,
               Year,
               Make,
               Model,
               Odometer,
               Size,
               BuyerName,
               BuyerEmployeeID,
               SourcingRegion,
               CRLLT,
               PurchaseDate,
               AuctionHouse,
               AuctionName,
               BidTypeKey,
               PurchaseChannel,
               IsPreviousDTVehicle,
               SellerName,
               LastBidAmount,
               BuyerFee,
               OtherFee,
               IsIfBid,
               IsDeleted
        FROM #SemiFinal
        WHERE IsInsert = 1;


        --Update records that already exist if they need to be updated

        UPDATE bne
        SET bne.RecordLocator = sf.RecordLocator,
            bne.RowUpdatedDateTime = SYSDATETIME(),
            bne.VIN = sf.VIN,
            bne.Year = sf.Year,
            bne.Make = sf.Make,
            bne.Model = sf.Model,
            bne.Mileage = sf.Odometer,
            bne.Size = sf.Size,
            bne.BuyerName = sf.BuyerName,
            bne.BuyerEmpID = sf.BuyerEmployeeID,
            bne.SourcingRegion = sf.SourcingRegion,
            bne.CRLLT = sf.CRLLT,
            bne.PurchaseDate = sf.PurchaseDate,
            bne.AuctionHouse = sf.AuctionHouse,
            bne.AuctionName = sf.AuctionName,
            bne.BidTypeKey = sf.BidTypeKey,
            bne.PurchaseChannel = sf.PurchaseChannel,
            bne.IsPreviousDTVehicle = sf.IsPreviousDTVehicle,
            bne.SellerName = sf.SellerName,
            bne.BaseCost = sf.LastBidAmount,
            bne.BuyerFee = sf.BuyerFee,
            bne.OtherFee = sf.OtherFee,
            bne.IsIfBid = sf.IsIfBid,
            bne.IsDeleted = sf.IsDeleted
        FROM dbo.tblBuyNetEntry bne
            JOIN #SemiFinal sf
                ON sf.VIN = bne.VIN
                   AND sf.AuctionName = bne.AuctionName
                   AND sf.PurchaseDate = bne.PurchaseDate
                   AND sf.IsInsert = 0
        WHERE EXISTS
        (
            SELECT bne.RecordLocator,
                   bne.VIN,
                   bne.Year,
                   bne.Make,
                   bne.Model,
                   bne.Mileage,
                   bne.Size,
                   bne.BuyerName,
                   bne.BuyerEmpID,
                   bne.SourcingRegion,
                   bne.CRLLT,
                   bne.PurchaseDate,
                   bne.AuctionHouse,
                   bne.AuctionName,
                   bne.BidTypeKey,
                   bne.PurchaseChannel,
                   bne.IsPreviousDTVehicle,
                   bne.SellerName,
                   bne.BaseCost,
                   bne.BuyerFee,
                   bne.OtherFee,
                   bne.IsIfBid,
                   bne.IsDeleted
            EXCEPT
            SELECT sf.RecordLocator,
                   sf.VIN,
                   sf.Year,
                   sf.Make,
                   sf.Model,
                   sf.Odometer,
                   sf.Size,
                   sf.BuyerName,
                   sf.BuyerEmployeeID,
                   sf.SourcingRegion,
                   sf.CRLLT,
                   sf.PurchaseDate,
                   sf.AuctionHouse,
                   sf.AuctionName,
                   sf.BidTypeKey,
                   sf.PurchaseChannel,
                   sf.IsPreviousDTVehicle,
                   sf.SellerName,
                   sf.LastBidAmount,
                   sf.BuyerFee,
                   sf.OtherFee,
                   sf.IsIfBid,
                   sf.IsDeleted
        );


        --SELECT * FROM Buy.dbo.tblBuyNetEntry


        -- @TranCount = 0 means no transaction was started before the procedure was called.
        -- The procedure must commit the transaction it started.
        IF @TranCount = 0
            COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        DECLARE @XactState INTEGER,
                @CurrTranCount INTEGER;

        -- Get the state of the existing transaction so we can tell what type of rollback needs to occur
        --    If 1, the transaction is committable.  
        --    If -1, the transaction is uncommittable and should   
        --        be rolled back but only if it is a Full roll back.  Rollback for a save point will not work.
        --    XACT_STATE = 0 means that there is no transaction and  
        --        a commit or rollback operation would generate an error. 
        SET @XactState = XACT_STATE();

        -- Get the current transaction count 
        -- It is possible for the @TranCount value to be set, but a transaction to not be opened 
        --    when an error occurs. When this happens, we cannot call the rollback statement as there is no
        --    transaction to rollback. An example of this is when the executing account does not have
        --    permissions to the underlying objects, but does have authorization to execute the procedure.  
        SET @CurrTranCount = @@TRANCOUNT;

        -- @TranCount = 0 means no transaction was started before the procedure was called.
        -- The procedure must rollback the transaction it started.
        -- If the state of the transaction is stable, then rollback just the current save point work
        IF @TranCount = 0
           AND @CurrTranCount > 0
           AND @XactState <> 0
            ROLLBACK TRANSACTION;
        ELSE IF @TranCount > 0
                AND @CurrTranCount > 0
                AND @XactState = 1
            ROLLBACK TRANSACTION stpInsertUpdateBuyNetEntry;

        --Rethrow the error -- use throw in lieu of RAISERROR, the THROW behavior is needed for the .NET app
        THROW;

        -- Return a negative number so that if the calling code is using a LINK server, it will
        -- be able to test that the procedure failed.  Without this, there are some lower type of 
        -- errors that do not show up across the LINK as an error.  This causes ProcessControl 
        -- in particular to not see that the procedure failed which is bad.
        RETURN -1;

    END CATCH;
END;
