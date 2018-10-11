CREATE TABLE [postsale].[tblManheimRawDataBulk] (
    [ManheimRawDataBulkID] BIGINT         IDENTITY (1, 1) NOT NULL,
    [RawData]              NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_[postsale]].tblManheimRawDataBulk] PRIMARY KEY CLUSTERED ([ManheimRawDataBulkID] ASC) WITH (FILLFACTOR = 90)
);

