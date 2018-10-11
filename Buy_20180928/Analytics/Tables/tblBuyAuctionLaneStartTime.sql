CREATE TABLE [Analytics].[tblBuyAuctionLaneStartTime] (
    [BuyAuctionLaneStartTimeID] INT            IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]         DATETIME2 (7)  CONSTRAINT [DF_tblBuyAuctionLaneStartTime_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]        DATETIME2 (7)  NULL,
    [LastChangedByEmpID]        VARCHAR (128)  NULL,
    [AuctionName]               NVARCHAR (250) NULL,
    [SaleDay]                   VARCHAR (25)   NULL,
    [LaneNumber]                SMALLINT       NULL,
    [LaneStartTime]             TIME (7)       NULL,
    [isActive]                  TINYINT        NOT NULL,
    [StartDate]                 DATETIME2 (3)  NULL,
    [EndDate]                   DATETIME2 (3)  NULL,
    CONSTRAINT [PK_tblBuyAuctionLaneStartTime_BuyAuctionLaneStartTimeID] PRIMARY KEY CLUSTERED ([BuyAuctionLaneStartTimeID] ASC) WITH (FILLFACTOR = 90)
);

