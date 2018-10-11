CREATE TABLE [dbo].[testDestinationPriority] (
    [BuyAuctionVehicleID] BIGINT        NOT NULL,
    [VIN]                 VARCHAR (17)  NOT NULL,
    [AuctionName]         VARCHAR (100) NOT NULL,
    [SaleDate]            DATE          NOT NULL,
    [CRLLT]               INT           NOT NULL,
    [LocationPriority]    SMALLINT      NOT NULL,
    [IDNumber]            INT           NULL
);

