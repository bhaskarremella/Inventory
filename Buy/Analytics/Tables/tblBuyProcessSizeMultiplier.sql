CREATE TABLE [Analytics].[tblBuyProcessSizeMultiplier] (
    [BuyProcessSizeMultiplierID] INT             IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]          DATETIME2 (7)   CONSTRAINT [DF_tblBuyProcessSizeMultiplier_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]         DATETIME2 (7)   NULL,
    [LastChangedByEmpID]         VARCHAR (128)   NULL,
    [Size]                       VARCHAR (250)   NOT NULL,
    [KBBMultiplier]              DECIMAL (20, 6) NULL,
    [KBBDTAdjustmentValue]       DECIMAL (6, 2)  NOT NULL,
    [IsCore]                     TINYINT         CONSTRAINT [DF_tblBuyProcessSizeMultiplier_IsCore] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_tblBuyProcessSizeMultiplier] PRIMARY KEY CLUSTERED ([Size] ASC, [IsCore] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [idx_tblBuyProcessSizeMultiplier_BuyProcessSizeMultiplierID] UNIQUE NONCLUSTERED ([BuyProcessSizeMultiplierID] ASC) WITH (FILLFACTOR = 90)
);

