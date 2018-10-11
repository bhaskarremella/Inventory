CREATE TABLE [dbo].[tblBuyAuctionVehicle] (
    [BuyAuctionVehicleID]                BIGINT          IDENTITY (1, 1) NOT NULL,
    [BuyVehicleID]                       BIGINT          NOT NULL,
    [BuyAuctionListTypeID]               BIGINT          NOT NULL,
    [RowLoadedDateTime]                  DATETIME2 (7)   CONSTRAINT [DF_tblBuyAuctionVehicle_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]                 DATETIME2 (7)   NULL,
    [LastChangedByEmpID]                 VARCHAR (128)   NULL,
    [SaleDate]                           DATE            NULL,
    [Lane]                               VARCHAR (50)    NULL,
    [Run]                                VARCHAR (50)    NULL,
    [Odometer]                           INT             NULL,
    [SellerName]                         VARCHAR (220)   NULL,
    [VehicleLink]                        VARCHAR (500)   NULL,
    [CRLink]                             VARCHAR (500)   NULL,
    [CRScore]                            VARCHAR (50)    NULL,
    [PreSaleAnnouncement]                VARCHAR (250)   NULL,
    [PriceCap]                           DECIMAL (10, 4) NULL,
    [IsPreviousDTVehicle]                BIT             CONSTRAINT [DF_tblBuyAuctionVehicle_IsPreviousDTVehicle] DEFAULT ((0)) NOT NULL,
    [IsDTInspectionRequested]            BIT             CONSTRAINT [DF_tblBuyAuctionVehicle_IsDTInspectionRequested] DEFAULT ((0)) NOT NULL,
    [IsDecommissioned]                   BIT             CONSTRAINT [DF_tblBuyAuctionVehicle_IsDecommissioned] DEFAULT ((0)) NOT NULL,
    [IsDecommissionedDateTime]           DATETIME2 (7)   NULL,
    [KBBMultiplier]                      DECIMAL (10, 4) CONSTRAINT [DF_tblBuyAuctionVehicle_KBBMultiplier] DEFAULT ((1.00)) NULL,
    [KBBDTAdjustmentValue]               DECIMAL (10, 4) CONSTRAINT [DF_tblBuyAuctionVehicle_KBBDTAdjustmentValue] DEFAULT ((0)) NULL,
    [ProxyBidAmount]                     DECIMAL (10, 4) NULL,
    [ProxyBidAmountDateTime]             DATETIME2 (7)   NULL,
    [MMRValue]                           DECIMAL (10, 4) NULL,
    [BuyStrategyID]                      TINYINT         NULL,
    [Images]                             VARCHAR (MAX)   NULL,
    [IsAccuCheckIssue]                   TINYINT         NULL,
    [IsAccuCheckIssueDateTime]           DATETIME2 (7)   NULL,
    [IsBuyerAppVehicle]                  TINYINT         DEFAULT ((0)) NOT NULL,
    [IsInspectorAppVehicle]              TINYINT         DEFAULT ((0)) NOT NULL,
    [IsDecommissionedInspection]         BIT             DEFAULT ((0)) NOT NULL,
    [IsDecommissionedInspectionDateTime] DATETIME2 (7)   NULL,
    [PreviewBidAmount]                   DECIMAL (10, 4) NULL,
    [PreviewBidAmountDateTime]           DATETIME2 (7)   NULL,
    [IsDecommissionedDate]               AS              (CONVERT([date],[IsDecommissionedDateTime])),
    [BuyAuctionGuaranteeTypeID]          TINYINT         NULL,
    [ExternalLocationTypeID]             BIGINT          NULL,
    [DestinationConfirmationDateTime]    DATETIME2 (7)   NULL,
    [DestinationLastChangedByEmpID]      VARCHAR (128)   NULL,
    CONSTRAINT [PK_tblBuyAuctionVehicle_BuyAuctionVehicleID] PRIMARY KEY CLUSTERED ([BuyAuctionVehicleID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblBuyAuctionVehicle_BuyAuctionListTypeID] FOREIGN KEY ([BuyAuctionListTypeID]) REFERENCES [dbo].[tblBuyAuctionListType] ([BuyAuctionListTypeID]),
    CONSTRAINT [FK_tblBuyAuctionVehicle_BuyVehicleID] FOREIGN KEY ([BuyVehicleID]) REFERENCES [dbo].[tblBuyVehicle] ([BuyVehicleID]),
    CONSTRAINT [fk_tblBuyAuctionVehicle_tblBuyAuctionGuaranteeType_1] FOREIGN KEY ([BuyAuctionGuaranteeTypeID]) REFERENCES [mybuys].[tblBuyAuctionGuaranteeType] ([BuyAuctionGuaranteeTypeID])
);


GO
CREATE NONCLUSTERED INDEX [idx_tblBuyAuctionVehicle_BuyVehicleID_BuyAuctionListTypeID]
    ON [dbo].[tblBuyAuctionVehicle]([BuyVehicleID] ASC, [BuyAuctionListTypeID] ASC)
    INCLUDE([BuyAuctionVehicleID], [SaleDate], [Lane], [Run], [Odometer], [SellerName], [VehicleLink], [CRLink], [CRScore], [PreSaleAnnouncement], [PriceCap], [IsPreviousDTVehicle], [IsDTInspectionRequested], [IsDecommissioned], [IsDecommissionedDateTime], [ProxyBidAmount]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idx_tblBuyAuctionVehicle_SaleDate_Lane_IsDecommissioned]
    ON [dbo].[tblBuyAuctionVehicle]([SaleDate] ASC, [Lane] ASC, [IsDecommissioned] ASC)
    INCLUDE([BuyAuctionVehicleID], [BuyVehicleID], [BuyAuctionListTypeID], [RowLoadedDateTime], [RowUpdatedDateTime], [LastChangedByEmpID], [Run], [Odometer], [SellerName], [VehicleLink], [CRLink], [CRScore], [PreSaleAnnouncement], [PriceCap], [IsPreviousDTVehicle], [IsDTInspectionRequested], [IsDecommissionedDateTime], [KBBMultiplier], [KBBDTAdjustmentValue], [ProxyBidAmount], [ProxyBidAmountDateTime], [MMRValue], [BuyStrategyID], [Images]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idx_tblBuyAuctionVehicle_IsInspectorAppVehicle_IsDecommissionedInspection_SaleDate]
    ON [dbo].[tblBuyAuctionVehicle]([IsInspectorAppVehicle] ASC, [IsDecommissionedInspection] ASC, [SaleDate] ASC)
    INCLUDE([BuyAuctionVehicleID], [BuyAuctionListTypeID], [Lane], [IsDTInspectionRequested]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idx_tblBuyAuctionVehicle_IsDecommissionedDate]
    ON [dbo].[tblBuyAuctionVehicle]([IsDecommissionedDate] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idx_tblBuyAuctionVehicle_BuyAuctionGuaranteeTypeID]
    ON [dbo].[tblBuyAuctionVehicle]([BuyAuctionGuaranteeTypeID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idx_tblBuyAuctionVehicle_BuyAuctionListTypeID_SaleDate_INLC]
    ON [dbo].[tblBuyAuctionVehicle]([BuyAuctionListTypeID] ASC, [SaleDate] ASC)
    INCLUDE([BuyVehicleID], [RowUpdatedDateTime], [Lane], [Run], [Odometer], [SellerName], [VehicleLink], [CRLink], [CRScore], [PreSaleAnnouncement], [PriceCap], [IsPreviousDTVehicle], [IsDTInspectionRequested], [IsDecommissioned], [IsDecommissionedDateTime], [KBBMultiplier], [KBBDTAdjustmentValue], [MMRValue], [BuyStrategyID], [Images], [IsAccuCheckIssue], [IsAccuCheckIssueDateTime], [IsBuyerAppVehicle], [IsDecommissionedInspection], [IsDecommissionedInspectionDateTime], [IsInspectorAppVehicle], [ProxyBidAmount]) WITH (FILLFACTOR = 90);

