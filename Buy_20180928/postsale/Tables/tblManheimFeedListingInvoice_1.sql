CREATE TABLE [postsale].[tblManheimFeedListingInvoice] (
    [ManheimFeedListingInvoiceID] UNIQUEIDENTIFIER NOT NULL,
    [RowLoadedDateTime]           DATETIME2 (3)    CONSTRAINT [DF_tblManheimFeedListingInvoice_RowLoadedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [RowUpdatedDateTime]          DATETIME2 (3)    NULL,
    [ManheimFeedListingID]        UNIQUEIDENTIFIER NOT NULL,
    [Href]                        VARCHAR (1000)   NULL,
    CONSTRAINT [PK_tblManheimFeedListingInvoice] PRIMARY KEY CLUSTERED ([ManheimFeedListingInvoiceID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblManheimFeedListingInvoice_tblManheimFeedListing] FOREIGN KEY ([ManheimFeedListingID]) REFERENCES [postsale].[tblManheimFeedListing] ([ManheimFeedListingID])
);

