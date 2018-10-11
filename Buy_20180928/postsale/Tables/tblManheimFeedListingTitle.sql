CREATE TABLE [postsale].[tblManheimFeedListingTitle] (
    [ManheimFeedListingTitleID] UNIQUEIDENTIFIER NOT NULL,
    [RowLoadedDateTime]         DATETIME2 (3)    CONSTRAINT [DF_tblManheimFeedListingTitle_RowLoadedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [RowUpdatedDateTime]        DATETIME2 (3)    NULL,
    [ManheimFeedListingID]      UNIQUEIDENTIFIER NOT NULL,
    [ReceivedOn]                VARCHAR (40)     NULL,
    [UpdatedOn]                 VARCHAR (40)     NULL,
    [Status]                    VARCHAR (20)     NULL,
    [TitleNotRequired]          VARCHAR (20)     NULL,
    [VIN]                       VARCHAR (17)     NULL,
    [Year]                      SMALLINT         NULL,
    [Make]                      VARCHAR (50)     NULL,
    [Model]                     VARCHAR (100)    NULL,
    [BodyStyle]                 VARCHAR (16)     NULL,
    [Href]                      VARCHAR (1000)   NULL,
    CONSTRAINT [PK_tblManheimFeedListingTitle] PRIMARY KEY CLUSTERED ([ManheimFeedListingTitleID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblManheimFeedListingTitle_tblManheimFeedListing] FOREIGN KEY ([ManheimFeedListingID]) REFERENCES [postsale].[tblManheimFeedListing] ([ManheimFeedListingID])
);


GO
CREATE NONCLUSTERED INDEX [idx_tblManheimFeedListingTitle_ManheimFeedListingID]
    ON [postsale].[tblManheimFeedListingTitle]([ManheimFeedListingID] ASC) WITH (FILLFACTOR = 90);

