CREATE TABLE [mybuys].[tblBuyAuctionFeeType] (
    [BuyAuctionFeeTypeID]         BIGINT          IDENTITY (1, 1) NOT NULL,
    [BuyAuctionHouseTypeID]       BIGINT          NOT NULL,
    [BuyAuctionFeeCategoryTypeID] BIGINT          NOT NULL,
    [BuyAuctionListTypeID]        BIGINT          NULL,
    [RowLoadedDateTime]           DATETIME2 (7)   NOT NULL,
    [RowUpdatedDateTime]          DATETIME2 (7)   NULL,
    [LastChangedByEmpID]          VARCHAR (128)   NULL,
    [BuyAuctionFeeKey]            VARCHAR (50)    NOT NULL,
    [BuyAuctionFeeDescription]    VARCHAR (200)   NULL,
    [MinPurchasePrice]            DECIMAL (10, 4) NULL,
    [MaxPurchasePrice]            DECIMAL (10, 4) NULL,
    [FeeAmount]                   DECIMAL (10, 4) NULL,
    [IsActive]                    TINYINT         DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblBuyAuctionFeeType_BuyAuctionFeeTypeID] PRIMARY KEY CLUSTERED ([BuyAuctionFeeTypeID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblBuyAuctionFeeType_BuyAuctionFeeCategoryTypeID] FOREIGN KEY ([BuyAuctionFeeCategoryTypeID]) REFERENCES [mybuys].[tblBuyAuctionFeeCategoryType] ([BuyAuctionFeeCategoryTypeID]),
    CONSTRAINT [AK_tblBuyAuctionFeeType_BuyAuctionFeeTypeKey] UNIQUE NONCLUSTERED ([BuyAuctionFeeKey] ASC) WITH (FILLFACTOR = 90)
);

