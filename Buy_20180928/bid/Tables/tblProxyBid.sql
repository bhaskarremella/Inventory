CREATE TABLE [bid].[tblProxyBid] (
    [ProxyBidID]            BIGINT           IDENTITY (1, 1) NOT NULL,
    [ProxyBidStagingId]     UNIQUEIDENTIFIER NOT NULL,
    [AuctionID]             NVARCHAR (255)   NOT NULL,
    [Channel]               NVARCHAR (255)   CONSTRAINT [DF_tblProxyBid_Channel] DEFAULT ('IN_LANE') NOT NULL,
    [VIN]                   NVARCHAR (255)   NOT NULL,
    [Amount]                INT              NULL,
    [CustomerId]            NVARCHAR (255)   NOT NULL,
    [AccountNumber]         NVARCHAR (255)   NOT NULL,
    [RepName]               NVARCHAR (255)   CONSTRAINT [DF_tblProxyBid_RepUserName] DEFAULT ('dtime01') NOT NULL,
    [RepNumber]             INT              CONSTRAINT [DF_tblProxyBid_RepNumber] DEFAULT ((100399265)) NOT NULL,
    [ProxyBidStatusID]      TINYINT          CONSTRAINT [DF_tblProxyBid_ProxyBidStatusID] DEFAULT ((0)) NOT NULL,
    [IsDeleted]             BIT              CONSTRAINT [DF_tblProxyBid_IsDeleted] DEFAULT ((0)) NOT NULL,
    [IsAbandoned]           BIT              CONSTRAINT [DF_tblProxyBid_IsAbandoned] DEFAULT ((0)) NOT NULL,
    [RowLoadedDateTime]     DATETIME2 (7)    CONSTRAINT [DF_tblProxyBid_RowLoadedDateTime] DEFAULT (getutcdate()) NOT NULL,
    [RowUpdatedDateTime]    DATETIME2 (7)    CONSTRAINT [DF_tblProxyBid_RowUpdatedDateTime] DEFAULT (getutcdate()) NOT NULL,
    [ProxyBidPlaced]        AS               (CONVERT([bit],case [ProxyBidStatusID] when (1) then (1) when (2) then (1) else (0) end,(0))),
    [BidId]                 NVARCHAR (255)   NULL,
    [ProxyBidEnteredBy]     VARCHAR (250)    NULL,
    [BuyAuctionVehicleID]   BIGINT           NULL,
    [BuyAuctionHouseTypeID] BIGINT           DEFAULT ((1)) NOT NULL,
    [SaleDate]              DATE             NULL,
    CONSTRAINT [PK_tblProxyBid] PRIMARY KEY CLUSTERED ([ProxyBidID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblProxyBid_BuyAuctionHouseTypeID] FOREIGN KEY ([BuyAuctionHouseTypeID]) REFERENCES [dbo].[tblBuyAuctionHouseType] ([BuyAuctionHouseTypeID])
);


GO
CREATE NONCLUSTERED INDEX [IX_tblProxyBid_VIN]
    ON [bid].[tblProxyBid]([VIN] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idx_tblProxyBid_BuyAuctionHosueTypeID]
    ON [bid].[tblProxyBid]([BuyAuctionHouseTypeID] ASC) WITH (FILLFACTOR = 90);

