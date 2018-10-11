CREATE TABLE [dbo].[tblBuy] (
    [BuyID]                BIGINT          IDENTITY (1, 1) NOT NULL,
    [BuyAuctionVehicleID]  BIGINT          NOT NULL,
    [BuyTypeID]            BIGINT          NOT NULL,
    [BuyNoBidReasonTypeID] BIGINT          CONSTRAINT [DF_tblBuy_NoBidReason] DEFAULT ((0)) NOT NULL,
    [RowLoadedDateTime]    DATETIME2 (7)   CONSTRAINT [DF_tblBuy_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]   DATETIME2 (7)   NULL,
    [LastChangedByEmpID]   VARCHAR (128)   NULL,
    [BuyerName]            VARCHAR (100)   NULL,
    [BuyerEmail]           VARCHAR (100)   NULL,
    [LastBidAmount]        DECIMAL (10, 4) NULL,
    [BuyLatitude]          FLOAT (53)      NULL,
    [BuyLongitude]         FLOAT (53)      NULL,
    [BuyerEmployeeID]      VARCHAR (20)    NOT NULL,
    [IsDeleted]            BIT             DEFAULT ((0)) NOT NULL,
    [IsReconciledDateTime] DATETIME2 (7)   NULL,
    [IsReconciledBy]       VARCHAR (100)   NULL,
    [BuyNetID]             BIGINT          NULL,
    CONSTRAINT [PK_tblBuy_BuyID] PRIMARY KEY CLUSTERED ([BuyID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblBuy_BuyAuctionVehicleID] FOREIGN KEY ([BuyAuctionVehicleID]) REFERENCES [dbo].[tblBuyAuctionVehicle] ([BuyAuctionVehicleID]),
    CONSTRAINT [FK_tblBuy_BuyNoBidReasonTypeID] FOREIGN KEY ([BuyNoBidReasonTypeID]) REFERENCES [dbo].[tblBuyNoBidReasonType] ([BuyNoBidReasonTypeID]),
    CONSTRAINT [FK_tblBuy_BuyTypeID] FOREIGN KEY ([BuyTypeID]) REFERENCES [dbo].[tblBuyType] ([BuyTypeID]),
    CONSTRAINT [FK_tblBuy_tblBuyNet_BuyNetID] FOREIGN KEY ([BuyNetID]) REFERENCES [mybuys].[tblBuyNet] ([BuyNetID])
);


GO
CREATE NONCLUSTERED INDEX [idx_tblBuy_BuyID]
    ON [dbo].[tblBuy]([BuyAuctionVehicleID] ASC)
    INCLUDE([BuyTypeID], [BuyNoBidReasonTypeID], [RowUpdatedDateTime], [BuyerName], [LastBidAmount], [BuyerEmployeeID]) WITH (FILLFACTOR = 90);

