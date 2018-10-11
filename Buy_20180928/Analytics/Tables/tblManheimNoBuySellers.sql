CREATE TABLE [Analytics].[tblManheimNoBuySellers] (
    [ManheimNoBuySellersID] INT           IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]     DATETIME2 (7) CONSTRAINT [DF_tblManheimNoBuySellers_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]    DATETIME2 (7) NULL,
    [LastChangedByEmpID]    VARCHAR (128) NULL,
    [SellerName]            VARCHAR (100) NULL,
    [SellerState]           VARCHAR (50)  NULL,
    [NoBuyFlag]             TINYINT       NULL,
    CONSTRAINT [PK_tblManheimNoBuySellers_ManheimNoBuySellersID] PRIMARY KEY CLUSTERED ([ManheimNoBuySellersID] ASC) WITH (FILLFACTOR = 90)
);

