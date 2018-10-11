CREATE TABLE [dbo].[tblKBBPriceType] (
    [KBBPriceTypeID]       SMALLINT      IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]    DATETIME2 (7) CONSTRAINT [DF_tblKBBPriceType_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]   DATETIME2 (7) NULL,
    [LastChangedByEmpID]   VARCHAR (20)  NULL,
    [PriceTypeName]        VARCHAR (50)  NULL,
    [PriceTypeDescription] VARCHAR (100) NULL,
    CONSTRAINT [PK_tblKBBPriceType_KBBPriceTypeID] PRIMARY KEY CLUSTERED ([KBBPriceTypeID] ASC) WITH (FILLFACTOR = 90)
);

