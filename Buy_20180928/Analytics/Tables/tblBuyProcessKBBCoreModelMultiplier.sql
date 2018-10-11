CREATE TABLE [Analytics].[tblBuyProcessKBBCoreModelMultiplier] (
    [BuyProcessKBBCoreModelMultiplierID] INT             IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]                  DATETIME2 (7)   CONSTRAINT [DF_tblBuyProcessKBBCoreModelMultiplier_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]                 DATETIME2 (7)   NULL,
    [LastChangedByEmpID]                 VARCHAR (128)   NULL,
    [Size]                               VARCHAR (400)   NULL,
    [Make]                               VARCHAR (100)   NULL,
    [CommonModel]                        VARCHAR (100)   NULL,
    [AvgTradePctofKBB]                   DECIMAL (10, 6) NULL,
    CONSTRAINT [PK_tblBuyProcessKBBCoreModelMultiplier_BuyProcessKBBCoreModelMultiplierID] PRIMARY KEY CLUSTERED ([BuyProcessKBBCoreModelMultiplierID] ASC) WITH (FILLFACTOR = 90)
);

