CREATE TABLE [postsale].[tblManheimFeedListingComments] (
    [ManheimFeedListingCommentsID] UNIQUEIDENTIFIER NOT NULL,
    [RowLoadedDateTime]            DATETIME2 (3)    CONSTRAINT [DF_tblManheimFeedListingComments_RowLoadedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [RowUpdatedDateTime]           DATETIME2 (3)    NULL,
    [ManheimFeedListingID]         UNIQUEIDENTIFIER NOT NULL,
    [Count]                        INT              NULL,
    [Href]                         VARCHAR (1000)   NULL,
    CONSTRAINT [PK_tblManheimFeedListingComments] PRIMARY KEY CLUSTERED ([ManheimFeedListingCommentsID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblManheimFeedListingComments_tblManheimFeedListing] FOREIGN KEY ([ManheimFeedListingID]) REFERENCES [postsale].[tblManheimFeedListing] ([ManheimFeedListingID])
);

