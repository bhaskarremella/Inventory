CREATE TABLE [postsale].[tblManheimFeedListingBuyer] (
    [ManheimFeedListingBuyerID] UNIQUEIDENTIFIER NOT NULL,
    [RowLoadedDateTime]         DATETIME2 (3)    CONSTRAINT [DF_tblManheimFeedListingBuyer_RowLoadedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [RowUpdatedDateTime]        DATETIME2 (3)    NULL,
    [ManheimFeedListingID]      UNIQUEIDENTIFIER NOT NULL,
    [DealerNumber]              VARCHAR (24)     NULL,
    [DealerName]                VARCHAR (200)    NULL,
    [BidderBadge]               VARCHAR (10)     NULL,
    [Href]                      VARCHAR (1000)   NULL,
    CONSTRAINT [PK_tblManheimFeedListingBuyer] PRIMARY KEY CLUSTERED ([ManheimFeedListingBuyerID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblManheimFeedListingBuyer_tblManheimFeedListing] FOREIGN KEY ([ManheimFeedListingID]) REFERENCES [postsale].[tblManheimFeedListing] ([ManheimFeedListingID])
);

