CREATE TABLE [mybuys].[tblBuyAuctionFeeCategoryType] (
    [BuyAuctionFeeCategoryTypeID]      BIGINT        IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]                DATETIME2 (7) NOT NULL,
    [RowUpdatedDateTime]               DATETIME2 (7) NULL,
    [LastChangedByEmpID]               VARCHAR (128) NULL,
    [BuyAuctionFeeCategoryKey]         VARCHAR (50)  NOT NULL,
    [BuyAuctionFeeCategoryDescription] VARCHAR (200) NULL,
    [IsActive]                         TINYINT       DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblBuyAuctionFeeCategoryType_BuyAuctionFeeCategoryTypeID] PRIMARY KEY CLUSTERED ([BuyAuctionFeeCategoryTypeID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [AK_tblBuyAuctionFeeCategoryType_BuyAuctionFeeCategoryKey] UNIQUE NONCLUSTERED ([BuyAuctionFeeCategoryKey] ASC) WITH (FILLFACTOR = 90)
);

