CREATE TABLE [dbo].[tblBuyAuctionHouseType] (
    [BuyAuctionHouseTypeID]   BIGINT        IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]       DATETIME2 (7) CONSTRAINT [DF_tblBuyAuctionHouseType_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]      DATETIME2 (7) NULL,
    [LastChangedByEmpID]      VARCHAR (128) NULL,
    [AuctionHouseKey]         VARCHAR (50)  NULL,
    [AuctionHouseDescription] VARCHAR (200) NULL,
    [IsActive]                TINYINT       DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblAuctionHouse_BuyAuctionHouseTypeID] PRIMARY KEY CLUSTERED ([BuyAuctionHouseTypeID] ASC) WITH (FILLFACTOR = 90)
);

