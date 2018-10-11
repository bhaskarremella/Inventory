CREATE TABLE [postsale].[tblManheimFeedListingConsignmentSeller] (
    [ManheimFeedListingConsignmentSellerID] UNIQUEIDENTIFIER NOT NULL,
    [RowLoadedDateTime]                     DATETIME2 (3)    CONSTRAINT [DF_tblManheimFeedListingConsignmentSeller_RowLoadedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [RowUpdatedDateTime]                    DATETIME2 (3)    NULL,
    [ManheimFeedListingConsignmentID]       UNIQUEIDENTIFIER NOT NULL,
    [DealerNumber]                          VARCHAR (24)     NULL,
    [DealerName]                            VARCHAR (200)    NULL,
    CONSTRAINT [PK_tblManheimFeedListingConsignmentSeller] PRIMARY KEY CLUSTERED ([ManheimFeedListingConsignmentSellerID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblManheimFeedListingConsignmentSeller_tblManheimFeedListingConsignment] FOREIGN KEY ([ManheimFeedListingConsignmentID]) REFERENCES [postsale].[tblManheimFeedListingConsignment] ([ManheimFeedListingConsignmentID])
);

