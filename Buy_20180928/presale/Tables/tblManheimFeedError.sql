CREATE TABLE [presale].[tblManheimFeedError] (
    [ErrorID]           UNIQUEIDENTIFIER NOT NULL,
    [RowLoadedDateTime] DATETIME2 (7)    CONSTRAINT [DF_tblManheimFeedError_RowLoadedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [ErrorMessage]      VARCHAR (MAX)    NULL,
    [StackTrace]        VARCHAR (MAX)    NULL,
    [RequestObject]     VARCHAR (MAX)    NULL,
    CONSTRAINT [PK_tblManheimFeedError] PRIMARY KEY CLUSTERED ([ErrorID] ASC) WITH (FILLFACTOR = 90)
);

