CREATE TABLE [dbo].[tblBuyDestinationPriorityStage] (
    [BuyDestinationPriorityStageID] BIGINT        IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]             DATETIME2 (7) CONSTRAINT [DF_tblBuyDestinationPriorityStage_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]            DATETIME2 (7) NULL,
    [LastChangedByEmpID]            VARCHAR (128) NULL,
    [VIN]                           VARCHAR (17)  NOT NULL,
    [AuctionName]                   VARCHAR (100) NOT NULL,
    [SaleDate]                      DATE          NOT NULL,
    [CRLLT]                         INT           NOT NULL,
    [LocationPriority]              SMALLINT      NOT NULL,
    [IDNumber]                      INT           NULL,
    CONSTRAINT [PK_tblBuyDestinationPriorityStage] PRIMARY KEY CLUSTERED ([BuyDestinationPriorityStageID] ASC) WITH (FILLFACTOR = 90)
);

