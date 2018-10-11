CREATE TABLE [postsale].[tblManheimFeedListingTitleOdometer] (
    [ManheimFeedListingTitleOdometerID] UNIQUEIDENTIFIER NOT NULL,
    [RowLoadedDateTime]                 DATETIME2 (3)    CONSTRAINT [DF_tblManheimFeedListingTitleOdometer_RowLoadedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [RowUpdatedDateTime]                DATETIME2 (3)    NULL,
    [ManheimFeedListingTitleID]         UNIQUEIDENTIFIER NOT NULL,
    [Reading]                           INT              NULL,
    [Units]                             VARCHAR (20)     NULL,
    CONSTRAINT [PK_tblManheimFeedListingTitleOdometer] PRIMARY KEY CLUSTERED ([ManheimFeedListingTitleOdometerID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblManheimFeedListingTitleOdometer_tblManheimFeedListingTitle] FOREIGN KEY ([ManheimFeedListingTitleID]) REFERENCES [postsale].[tblManheimFeedListingTitle] ([ManheimFeedListingTitleID])
);


GO
CREATE NONCLUSTERED INDEX [idx_tblManheimFeedListingTitleOdometer_ManheimFeedListingTitleID]
    ON [postsale].[tblManheimFeedListingTitleOdometer]([ManheimFeedListingTitleID] ASC) WITH (FILLFACTOR = 90);

