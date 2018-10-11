CREATE TABLE [postsale].[tblManheimFeedListingBuyerRep] (
    [ManheimFeedListingBuyerRepID] UNIQUEIDENTIFIER NOT NULL,
    [RowLoadedDateTime]            DATETIME2 (3)    CONSTRAINT [DF_tblManheimFeedListingBuyerRep_RowLoadedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [RowUpdatedDateTime]           DATETIME2 (3)    NULL,
    [ManheimFeedListingBuyerID]    UNIQUEIDENTIFIER NOT NULL,
    [RepNumber]                    VARCHAR (480)    NULL,
    [RepName]                      VARCHAR (96)     NULL,
    [Href]                         VARCHAR (1000)   NULL,
    CONSTRAINT [PK_tblManheimFeedListingBuyerRep] PRIMARY KEY CLUSTERED ([ManheimFeedListingBuyerRepID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblManheimFeedListingBuyerRep_tblManheimFeedListingBuyer] FOREIGN KEY ([ManheimFeedListingBuyerID]) REFERENCES [postsale].[tblManheimFeedListingBuyer] ([ManheimFeedListingBuyerID])
);

