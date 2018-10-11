CREATE TABLE [mybuys].[tblBuyAuctionType] (
    [BuyAuctionTypeID]       TINYINT       NOT NULL,
    [RowLoadedDateTime]      DATETIME2 (7) NOT NULL,
    [RowUpdatedDateTime]     DATETIME2 (7) NULL,
    [LastChangedByEmpID]     VARCHAR (128) NULL,
    [AuctionTypeKey]         VARCHAR (50)  NOT NULL,
    [AuctionTypeDescription] VARCHAR (200) NULL,
    [IsActive]               TINYINT       NOT NULL,
    CONSTRAINT [PK_tblBuyAuctionType] PRIMARY KEY CLUSTERED ([BuyAuctionTypeID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [AK_tblBuyAuctionType_AuctionTypeKey] UNIQUE NONCLUSTERED ([AuctionTypeKey] ASC) WITH (FILLFACTOR = 90)
);

