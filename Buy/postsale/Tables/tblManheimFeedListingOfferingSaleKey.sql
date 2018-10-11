CREATE TABLE [postsale].[tblManheimFeedListingOfferingSaleKey] (
    [ManheimFeedListingOfferingSaleKeyID] UNIQUEIDENTIFIER NOT NULL,
    [RowLoadedDateTime]                   DATETIME2 (3)    CONSTRAINT [DF_tblManheimFeedListingOfferingSaleKey_RowLoadedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [RowUpdatedDateTime]                  DATETIME2 (3)    NULL,
    [ManheimFeedListingOfferingID]        UNIQUEIDENTIFIER NOT NULL,
    [SaleYear]                            SMALLINT         NULL,
    [SaleNumber]                          TINYINT          NULL,
    [LaneNumber]                          TINYINT          NULL,
    [RunNumber]                           SMALLINT         NULL,
    CONSTRAINT [PK_tblManheimFeedListingOfferingSaleKey] PRIMARY KEY CLUSTERED ([ManheimFeedListingOfferingSaleKeyID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblManheimFeedListingOfferingSaleKey_tblManheimFeedListingOffering] FOREIGN KEY ([ManheimFeedListingOfferingID]) REFERENCES [postsale].[tblManheimFeedListingOffering] ([ManheimFeedListingOfferingID])
);

