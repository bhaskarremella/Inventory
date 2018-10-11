CREATE TABLE [dbo].[tblBuyAuctionActionItem] (
    [BuyAuctionActionItemID]     BIGINT        IDENTITY (1, 1) NOT NULL,
    [BuyAuctionActionItemTypeID] BIGINT        NOT NULL,
    [BuyAuctionVehicleID]        BIGINT        NOT NULL,
    [RowLoadedDateTime]          DATETIME2 (7) CONSTRAINT [DF_tblBuyAuctionActionItem_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]         DATETIME2 (7) NULL,
    [LastChangedByEmpID]         VARCHAR (128) NULL,
    [IsActive]                   TINYINT       DEFAULT ((0)) NOT NULL,
    [ActionedByDateTime]         DATETIME2 (7) NOT NULL,
    [ActionedByEmployeeID]       VARCHAR (20)  NULL,
    CONSTRAINT [PK_tblBuyAuctionActionItem_BuyAuctionActionItemID] PRIMARY KEY CLUSTERED ([BuyAuctionActionItemID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblBuyAuctionActionItem_BuyAuctionActionItemTypeID] FOREIGN KEY ([BuyAuctionActionItemTypeID]) REFERENCES [dbo].[tblBuyAuctionActionItemType] ([BuyAuctionActionItemTypeID]),
    CONSTRAINT [FK_tblBuyAuctionActionItem_BuyAuctionVehicleID] FOREIGN KEY ([BuyAuctionVehicleID]) REFERENCES [dbo].[tblBuyAuctionVehicle] ([BuyAuctionVehicleID])
);

