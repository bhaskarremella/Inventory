CREATE TABLE [mybuys].[tblBuyAuctionPurchaseChannelType] (
    [BuyAuctionPurchaseChannelTypeID] TINYINT       IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]               DATETIME2 (7) CONSTRAINT [DF_RowLoadedDateTime_tblBuyAuctionPurchaseChannelType] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]              DATETIME2 (7) NULL,
    [LastChangedByEmpID]              VARCHAR (128) NULL,
    [PurchaseChannelKey]              VARCHAR (50)  NOT NULL,
    [PurchaseChannelDescription]      VARCHAR (200) NULL,
    [IsActive]                        TINYINT       NOT NULL,
    CONSTRAINT [PK_tblBuyAuctionPurchaseChannelType] PRIMARY KEY CLUSTERED ([BuyAuctionPurchaseChannelTypeID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [AK_tblBuyAuctionPurchaseChannelType_PurchaseChannelKey] UNIQUE NONCLUSTERED ([PurchaseChannelKey] ASC) WITH (FILLFACTOR = 90)
);

