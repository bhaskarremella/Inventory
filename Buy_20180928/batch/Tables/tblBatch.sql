CREATE TABLE [batch].[tblBatch] (
    [BatchID]             INT           IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]   DATETIME2 (7) CONSTRAINT [DF_tblBatch_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]  DATETIME2 (7) NULL,
    [FileName]            VARCHAR (500) NOT NULL,
    [IsCurrent]           TINYINT       NOT NULL,
    [IsLastFileProcessed] TINYINT       NOT NULL,
    CONSTRAINT [PK_tblBatch] PRIMARY KEY CLUSTERED ([BatchID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_tblBatch_IsCurrent]
    ON [batch].[tblBatch]([IsCurrent] ASC) WHERE ([IsCurrent]=(1)) WITH (FILLFACTOR = 90);

