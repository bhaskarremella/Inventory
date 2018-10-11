CREATE TABLE [dbo].[tblBuyAuctionActionItemType] (
    [BuyAuctionActionItemTypeID]      BIGINT        IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]               DATETIME2 (7) CONSTRAINT [DF_tblBuyAuctionActionItemType_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]              DATETIME2 (7) NULL,
    [LastChangedByEmpID]              VARCHAR (128) NULL,
    [BuyAuctionActionItemKey]         VARCHAR (50)  NULL,
    [BuyAuctionActionItemDescription] VARCHAR (200) NULL,
    [BuyAuctionActionItemPriority]    INT           NULL,
    [IsActive]                        TINYINT       CONSTRAINT [DF_tblBuyAuctionActionItemType_IsActive] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblBuyAuctionActionItemType_BuyAuctionActionItemTypeID] PRIMARY KEY CLUSTERED ([BuyAuctionActionItemTypeID] ASC) WITH (FILLFACTOR = 90)
);

