CREATE TABLE [dbo].[tblKBBOption] (
    [KBBOptionsID]         BIGINT          IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]    DATETIME2 (7)   CONSTRAINT [DF_tblKBBOption_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]   DATETIME2 (7)   NULL,
    [LastChangedByEmpID]   VARCHAR (20)    NULL,
    [KBBValuationID]       BIGINT          NOT NULL,
    [KBBPriceTypeID]       SMALLINT        NOT NULL,
    [OptionID]             INT             NOT NULL,
    [OptionName]           VARCHAR (200)   NULL,
    [OptionAdjustment]     DECIMAL (10, 4) NULL,
    [OptionAdjustmentType] VARCHAR (20)    NULL,
    [AvailablevsStandard]  TINYINT         NULL,
    [IsDefault]            TINYINT         NULL,
    CONSTRAINT [PK_tblKBBOption_KBBOptionID] PRIMARY KEY CLUSTERED ([KBBOptionsID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblKBBOption_tblKBBPriceType] FOREIGN KEY ([KBBPriceTypeID]) REFERENCES [dbo].[tblKBBPriceType] ([KBBPriceTypeID]),
    CONSTRAINT [FK_tblKBBOption_tblKBBValuation] FOREIGN KEY ([KBBValuationID]) REFERENCES [dbo].[tblKBBValuation] ([KBBValuationID])
);

