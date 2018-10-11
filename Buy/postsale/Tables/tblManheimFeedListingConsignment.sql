CREATE TABLE [postsale].[tblManheimFeedListingConsignment] (
    [ManheimFeedListingConsignmentID] UNIQUEIDENTIFIER NOT NULL,
    [RowLoadedDateTime]               DATETIME2 (3)    CONSTRAINT [DF_tblManheimFeedListingConsignment_RowLoadedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [RowUpdatedDateTime]              DATETIME2 (3)    NULL,
    [ManheimFeedListingID]            UNIQUEIDENTIFIER NOT NULL,
    [WorkOrderNumber]                 INT              NULL,
    CONSTRAINT [PK_tblManheimFeedListingConsignment] PRIMARY KEY CLUSTERED ([ManheimFeedListingConsignmentID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblManheimFeedListingConsignment_tblManheimFeedListing] FOREIGN KEY ([ManheimFeedListingID]) REFERENCES [postsale].[tblManheimFeedListing] ([ManheimFeedListingID])
);

