CREATE TABLE [dbo].[tblBuyAuctionVehicleList] (
    [BuyAuctionVehicleListID] BIGINT        IDENTITY (1, 1) NOT NULL,
    [BuyAuctionVehicleID]     BIGINT        NOT NULL,
    [RowLoadedDateTime]       DATETIME2 (7) CONSTRAINT [DF_tblBuyAuctionVehicleList_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]      DATETIME2 (7) NULL,
    [LastChangedByEmpID]      VARCHAR (128) NULL,
    [VIN]                     VARCHAR (17)  NULL,
    [Year]                    SMALLINT      NULL,
    [Make]                    VARCHAR (100) NULL,
    [Model]                   VARCHAR (100) NULL,
    [Color]                   VARCHAR (50)  NULL,
    [BodyStyle]               VARCHAR (100) NULL,
    [Size]                    VARCHAR (50)  NULL,
    [SizeUpdatedDateTime]     DATETIME2 (7) NULL,
    [SizeLastChangedByEmpID]  VARCHAR (128) NULL,
    CONSTRAINT [PK_tblBuyAuctionVehicleList_BuyAuctionVehicleListID] PRIMARY KEY CLUSTERED ([BuyAuctionVehicleListID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblBuyAuctionVehicleList_BuyAuctionVehicleID] FOREIGN KEY ([BuyAuctionVehicleID]) REFERENCES [dbo].[tblBuyAuctionVehicle] ([BuyAuctionVehicleID])
);

