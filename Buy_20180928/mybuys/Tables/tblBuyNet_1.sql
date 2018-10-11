CREATE TABLE [mybuys].[tblBuyNet] (
    [BuyNetID]              BIGINT          IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]     DATETIME2 (7)   NOT NULL,
    [RowUpdatedDateTime]    DATETIME2 (7)   NULL,
    [LastChangedByEmpID]    VARCHAR (128)   NULL,
    [BuyNetEnteredBy]       VARCHAR (128)   NULL,
    [BuyNetEnteredDateTime] DATETIME2 (7)   NULL,
    [BuyNetAmount]          DECIMAL (10, 4) NULL,
    [BuyNetCount]           INT             NULL,
    CONSTRAINT [PK_tblBuyNet] PRIMARY KEY CLUSTERED ([BuyNetID] ASC) WITH (FILLFACTOR = 90)
);

