CREATE TABLE [Analytics].[tblBuyProcessKBBCoreSizeMultiplier] (
    [BuyProcessKBBCoreSizeMultiplierID] INT             IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]                 DATETIME2 (7)   CONSTRAINT [DF_tblBuyProcessKBBCoreSizeMultiplier_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]                DATETIME2 (7)   NULL,
    [LastChangedByEmpID]                VARCHAR (128)   NULL,
    [Size]                              VARCHAR (400)   NULL,
    [AvgTradePctofKBB]                  DECIMAL (10, 6) NULL,
    CONSTRAINT [PK_tblBuyProcessKBBCoreSizeMultiplier_BuyProcessKBBCoreSizeMultiplierID] PRIMARY KEY CLUSTERED ([BuyProcessKBBCoreSizeMultiplierID] ASC) WITH (FILLFACTOR = 90)
);

