CREATE TABLE [postsale].[tblManheimFeedListing] (
    [ManheimFeedListingID] UNIQUEIDENTIFIER NOT NULL,
    [UniqueID]             VARCHAR (36)     NOT NULL,
    [RowLoadedDateTime]    DATETIME2 (3)    CONSTRAINT [DF_tblManheimFeedListing_RowLoadedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [RowUpdatedDateTime]   DATETIME2 (3)    NULL,
    [ManheimFeedID]        UNIQUEIDENTIFIER NOT NULL,
    [PurchaseDate]         VARCHAR (40)     NULL,
    [BlockTimestamp]       VARCHAR (40)     NULL,
    [PurchaseOfferExists]  VARCHAR (20)     NULL,
    [PurchasePrice]        MONEY            NULL,
    [Currency]             VARCHAR (5)      NULL,
    [VehicleStatus]        VARCHAR (64)     NULL,
    [PurchaseApplication]  VARCHAR (40)     NULL,
    [PurchaseMethod]       VARCHAR (40)     NULL,
    CONSTRAINT [PK_tblManheimFeedListing] PRIMARY KEY CLUSTERED ([ManheimFeedListingID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblManheimFeedListing_tblManheimFeed] FOREIGN KEY ([ManheimFeedID]) REFERENCES [postsale].[tblManheimFeed] ([ManheimFeedID])
);

