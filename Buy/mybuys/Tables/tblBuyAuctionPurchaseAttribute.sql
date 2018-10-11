CREATE TABLE [mybuys].[tblBuyAuctionPurchaseAttribute] (
    [BuyAuctionPurchaseAttributeID]   BIGINT        IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]               DATETIME2 (7) CONSTRAINT [DF_RowLoadedDateTime_tblBuyAuctionPurchaseAttribute] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]              DATETIME2 (7) NULL,
    [LastChangedByEmpID]              VARCHAR (128) NULL,
    [BuyAuctionVehicleID]             BIGINT        NOT NULL,
    [BuyAuctionGuaranteeTypeID]       TINYINT       NOT NULL,
    [BuyAuctionPurchaseChannelTypeID] TINYINT       NOT NULL,
    [ExternalLocationTypeID]          BIGINT        NOT NULL,
    [DestinationConfirmationDateTime] DATETIME2 (7) NULL,
    [DestinationLastChangedByEmpID]   VARCHAR (128) NULL,
    CONSTRAINT [PK_tblBuyAuctionPurchaseAttribute] PRIMARY KEY CLUSTERED ([BuyAuctionPurchaseAttributeID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblBuyAuctionPurchaseAttribute_tblBuyAuctionPurchaseChannelType_BuyAuctionPurchaseChannelTypeID] FOREIGN KEY ([BuyAuctionPurchaseChannelTypeID]) REFERENCES [mybuys].[tblBuyAuctionPurchaseChannelType] ([BuyAuctionPurchaseChannelTypeID]),
    CONSTRAINT [FK_tblBuyAuctionPurchaseAttribute_tblBuyAuctionVehicle_BuyAuctionVehicleID] FOREIGN KEY ([BuyAuctionVehicleID]) REFERENCES [dbo].[tblBuyAuctionVehicle] ([BuyAuctionVehicleID])
);

