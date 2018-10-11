CREATE TABLE [mybuys].[tblBuyAuctionFee] (
    [BuyAuctionFeeID]     BIGINT          IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]   DATETIME2 (7)   NOT NULL,
    [RowUpdatedDateTime]  DATETIME2 (7)   NULL,
    [LastChangedByEmpID]  VARCHAR (128)   NULL,
    [BuyAuctionVehicleID] BIGINT          NOT NULL,
    [BuyAuctionFeeTypeID] BIGINT          NOT NULL,
    [FeeAmount]           DECIMAL (10, 4) NOT NULL,
    CONSTRAINT [PK_tblBuyAuctionFee] PRIMARY KEY CLUSTERED ([BuyAuctionFeeID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblBuyAuctionFee_tblBuyAuctionFeeType_BuyAuctionFeeTypeID] FOREIGN KEY ([BuyAuctionFeeTypeID]) REFERENCES [mybuys].[tblBuyAuctionFeeType] ([BuyAuctionFeeTypeID]),
    CONSTRAINT [FK_tblBuyAuctionFee_tblBuyAuctionVehicle_BuyAuctionVehicleID] FOREIGN KEY ([BuyAuctionVehicleID]) REFERENCES [dbo].[tblBuyAuctionVehicle] ([BuyAuctionVehicleID])
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblBuyAuctionFee_AuctionFeeTypeID]
    ON [mybuys].[tblBuyAuctionFee]([BuyAuctionFeeTypeID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IDX_tblBuyAuctionFee_BuyAuctionVehicleID]
    ON [mybuys].[tblBuyAuctionFee]([BuyAuctionVehicleID] ASC) WITH (FILLFACTOR = 90);

