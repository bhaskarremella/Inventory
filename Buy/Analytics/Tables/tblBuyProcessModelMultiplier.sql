CREATE TABLE [Analytics].[tblBuyProcessModelMultiplier] (
    [BuyProcessModelMultiplierID] INT             IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]           DATETIME2 (7)   CONSTRAINT [DF_tblBuyProcessModelMultiplier_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]          DATETIME2 (7)   NULL,
    [LastChangedByEmpID]          VARCHAR (128)   NULL,
    [Size]                        VARCHAR (250)   NOT NULL,
    [Make]                        VARCHAR (250)   NOT NULL,
    [CommonModel]                 VARCHAR (250)   NOT NULL,
    [KBBMultiplier]               DECIMAL (20, 6) NULL,
    [KBBDTAdjustmentValue]        DECIMAL (6, 2)  NOT NULL,
    [IsCore]                      TINYINT         CONSTRAINT [DF_tblBuyProcessModelMultiplier_IsCore] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_tblBuyProcessModelMultiplier] PRIMARY KEY CLUSTERED ([Size] ASC, [Make] ASC, [CommonModel] ASC, [IsCore] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [idx_tblBuyProcessModelMultiplier_BuyProcessModelMultiplierID] UNIQUE NONCLUSTERED ([BuyProcessModelMultiplierID] ASC) WITH (FILLFACTOR = 90)
);

