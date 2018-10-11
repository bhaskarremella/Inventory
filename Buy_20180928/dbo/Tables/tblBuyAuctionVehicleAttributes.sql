CREATE TABLE [dbo].[tblBuyAuctionVehicleAttributes] (
    [BuyAuctionVehicleAttributesID]   BIGINT        IDENTITY (1, 1) NOT NULL,
    [BuyAuctionVehicleID]             BIGINT        NOT NULL,
    [RowLoadedDateTime]               DATETIME2 (7) CONSTRAINT [DF_tblBuyAuctionVehicleAttributes_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]              DATETIME2 (7) NULL,
    [LastChangedByEmpID]              VARCHAR (128) NULL,
    [Size]                            VARCHAR (50)  NULL,
    [BuyerSize]                       VARCHAR (50)  NULL,
    [BuyerSizeUpdatedDateTime]        DATETIME2 (7) NULL,
    [BuyerSizeLastChangedByEmpID]     VARCHAR (128) NULL,
    [Odometer]                        INT           NULL,
    [BuyerOdometer]                   INT           NULL,
    [BuyerOdometerUpdatedDateTime]    DATETIME2 (7) NULL,
    [BuyerOdometerLastChangedByEmpID] VARCHAR (128) NULL,
    CONSTRAINT [PK_tblBuyAuctionVehicleAttributes_BuyAuctionVehicleAttributesID] PRIMARY KEY CLUSTERED ([BuyAuctionVehicleAttributesID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblBuyAuctionVehicleAttributes_BuyAuctionVehicleID] FOREIGN KEY ([BuyAuctionVehicleID]) REFERENCES [dbo].[tblBuyAuctionVehicle] ([BuyAuctionVehicleID]),
    CONSTRAINT [Ak_tblBuyAuctionVehicleAttributes_BuyAuctionVehicleID] UNIQUE NONCLUSTERED ([BuyAuctionVehicleID] ASC) WITH (FILLFACTOR = 90)
);

