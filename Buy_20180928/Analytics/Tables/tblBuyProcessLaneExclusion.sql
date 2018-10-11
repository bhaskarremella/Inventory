CREATE TABLE [Analytics].[tblBuyProcessLaneExclusion] (
    [BuyProcessLaneExclusionID] INT           IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]         DATETIME2 (7) CONSTRAINT [DF_tblBuyProcessLaneExclusion_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]        DATETIME2 (7) NULL,
    [LastChangedByEmpID]        VARCHAR (128) NULL,
    [AuctionName]               VARCHAR (250) NULL,
    [LaneNumber]                SMALLINT      NULL,
    [DayofWeek]                 VARCHAR (200) NULL,
    [StartDate]                 DATETIME      NULL,
    [EndDate]                   DATETIME      NULL,
    [IsCurrent]                 BIGINT        NULL,
    CONSTRAINT [PK_tblBuyProcessLaneExclusion_BuyAuctionLaneStartTimeID] PRIMARY KEY CLUSTERED ([BuyProcessLaneExclusionID] ASC) WITH (FILLFACTOR = 90)
);

