CREATE TABLE [presale].[tblManheimFeedImage] (
    [ImageID]   UNIQUEIDENTIFIER NOT NULL,
    [ListingID] UNIQUEIDENTIFIER NOT NULL,
    [Images]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_tblManheimFeedImage] PRIMARY KEY CLUSTERED ([ImageID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblManheimFeed_ListingID] FOREIGN KEY ([ListingID]) REFERENCES [presale].[tblManheimFeed] ([ListingID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_tblManheimFeedImage_ListingID]
    ON [presale].[tblManheimFeedImage]([ListingID] ASC) WITH (FILLFACTOR = 90);

