CREATE TABLE [Analytics].[tblBuyAuctionDayException] (
    [BuyAuctionDayExceptionsID] INT           IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]         DATETIME2 (7) CONSTRAINT [DF_tblBuyAuctionDayException_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]        DATETIME2 (7) NULL,
    [LastChangedByEmpID]        VARCHAR (128) NULL,
    [AuctionName]               VARCHAR (250) NULL,
    [DayOfWeek]                 VARCHAR (100) NULL,
    [ExceptionReason]           VARCHAR (100) NULL,
    [IsCurrent]                 INT           NULL,
    CONSTRAINT [PK_tblBuyAuctionDayException_BuyAuctionDayExceptionsID] PRIMARY KEY CLUSTERED ([BuyAuctionDayExceptionsID] ASC) WITH (FILLFACTOR = 90)
);

