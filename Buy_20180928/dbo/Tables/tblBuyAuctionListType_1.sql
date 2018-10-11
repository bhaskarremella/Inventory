CREATE TABLE [dbo].[tblBuyAuctionListType] (
    [BuyAuctionListTypeID]   BIGINT        IDENTITY (1, 1) NOT NULL,
    [BuyAuctionHouseTypeID]  BIGINT        NOT NULL,
    [RowLoadedDateTime]      DATETIME2 (7) CONSTRAINT [DF_tblAuctionListType_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]     DATETIME2 (7) NULL,
    [LastChangedByEmpID]     VARCHAR (128) NULL,
    [AuctionListKey]         VARCHAR (50)  NULL,
    [AuctionListDescription] VARCHAR (200) NULL,
    [Address]                VARCHAR (50)  NULL,
    [City]                   VARCHAR (50)  NULL,
    [State]                  VARCHAR (20)  NULL,
    [ZipCode]                VARCHAR (20)  NULL,
    [IsActive]               TINYINT       DEFAULT ((0)) NOT NULL,
    [ExternalAuctionID]      VARCHAR (50)  NULL,
    CONSTRAINT [PK_tblAuctionListType_BuyAuctionListTypeID] PRIMARY KEY CLUSTERED ([BuyAuctionListTypeID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblBuyAuctionListType_BuyAuctionHouseTypeID] FOREIGN KEY ([BuyAuctionHouseTypeID]) REFERENCES [dbo].[tblBuyAuctionHouseType] ([BuyAuctionHouseTypeID]),
    CONSTRAINT [AK_tblBuyAuctionListType_AuctionListKey] UNIQUE NONCLUSTERED ([AuctionListKey] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [idx_tblBuyAuctionListType_BuyAuctionListTypeID]
    ON [dbo].[tblBuyAuctionListType]([BuyAuctionListTypeID] ASC)
    INCLUDE([AuctionListDescription]) WITH (FILLFACTOR = 90);

