CREATE TABLE [postsale].[tblManheimRawData] (
    [ManheimRawDataID] BIGINT         IDENTITY (1, 1) NOT NULL,
    [RawData]          NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_[postsale]].tblManheimRawData] PRIMARY KEY CLUSTERED ([ManheimRawDataID] ASC) WITH (FILLFACTOR = 90)
);

