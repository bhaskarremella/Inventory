CREATE TABLE [dbo].[tblBuyDestinationPriority] (
    [BuyDestinationPriorityID] BIGINT        IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]        DATETIME2 (7) CONSTRAINT [DF_tblBuyDestinationPriority_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]       DATETIME2 (7) NULL,
    [LastChangedByEmpID]       VARCHAR (128) NULL,
    [BuyAuctionVehicleID]      BIGINT        NOT NULL,
    [VIN]                      VARCHAR (17)  NOT NULL,
    [AuctionName]              VARCHAR (100) NOT NULL,
    [SaleDate]                 DATE          NOT NULL,
    [CRLLT]                    INT           NOT NULL,
    [LocationPriority]         SMALLINT      NOT NULL,
    [IDNumber]                 INT           NULL,
    CONSTRAINT [PK_tblBuyDestinationPriority] PRIMARY KEY CLUSTERED ([BuyDestinationPriorityID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [idx_tblBuyDestinationPriority_BuyAuctionVehicleID_LocationPriority]
    ON [dbo].[tblBuyDestinationPriority]([BuyAuctionVehicleID] ASC)
    INCLUDE([LocationPriority]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idx_tblBuyDestinationPriority_VIN]
    ON [dbo].[tblBuyDestinationPriority]([VIN] ASC) WITH (FILLFACTOR = 90);

