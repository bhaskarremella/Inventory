CREATE TABLE [postsale].[tblManheimFeedListingTitleOperatingLocation] (
    [ManheimFeedListingTitleOperatingLocationID] UNIQUEIDENTIFIER NOT NULL,
    [RowLoadedDateTime]                          DATETIME2 (3)    CONSTRAINT [DF_tblManheimFeedListingTitleOperatingLocation_RowLoadedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [RowUpdatedDateTime]                         DATETIME2 (3)    NULL,
    [ManheimFeedListingTitleID]                  UNIQUEIDENTIFIER NOT NULL,
    [LocationName]                               VARCHAR (80)     NULL,
    [LocationCode]                               VARCHAR (24)     NULL,
    [Href]                                       VARCHAR (1000)   NULL,
    CONSTRAINT [PK_tblManheimFeedListingTitleOperatingLocation] PRIMARY KEY CLUSTERED ([ManheimFeedListingTitleOperatingLocationID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblManheimFeedListingTitleOperatingLocation_tblManheimFeedListingTitle] FOREIGN KEY ([ManheimFeedListingTitleID]) REFERENCES [postsale].[tblManheimFeedListingTitle] ([ManheimFeedListingTitleID])
);


GO
CREATE NONCLUSTERED INDEX [idx_tblManheimFeedListingTitleOperatingLocation_ManheimFeedListingTitleID]
    ON [postsale].[tblManheimFeedListingTitleOperatingLocation]([ManheimFeedListingTitleID] ASC) WITH (FILLFACTOR = 90);

