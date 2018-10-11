CREATE TABLE [mybuys].[tblBuyAuctionGuaranteeType] (
    [BuyAuctionGuaranteeTypeID]   TINYINT       NOT NULL,
    [RowLoadedDateTime]           DATETIME2 (7) NOT NULL,
    [RowUpdatedDateTime]          DATETIME2 (7) NULL,
    [LastChangedByEmpID]          VARCHAR (128) NULL,
    [AuctionGuaranteeKey]         VARCHAR (50)  NOT NULL,
    [AuctionGuaranteeDescription] VARCHAR (200) NULL,
    [IsActive]                    TINYINT       NOT NULL,
    CONSTRAINT [PK_tblBuyAuctionGuaranteeType] PRIMARY KEY CLUSTERED ([BuyAuctionGuaranteeTypeID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [AK_tblBuyAuctionGuaranteeType_AuctionGuaranteeKey] UNIQUE NONCLUSTERED ([AuctionGuaranteeKey] ASC) WITH (FILLFACTOR = 90)
);

