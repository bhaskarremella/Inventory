CREATE TABLE [postsale].[tblManheimFeedListingPostSaleInspectionConsignment] (
    [ManheimFeedListingPostSaleInspectionConsignmentID] UNIQUEIDENTIFIER NOT NULL,
    [RowLoadedDateTime]                                 DATETIME2 (3)    CONSTRAINT [DF_tblManheimFeedListingPostSaleInspectionConsignment_RowLoadedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [RowUpdatedDateTime]                                DATETIME2 (3)    NULL,
    [ManheimFeedListingPostSaleInspectionID]            UNIQUEIDENTIFIER NOT NULL,
    [WorkOrderNumber]                                   INT              NULL,
    CONSTRAINT [PK_tblManheimFeedListingPostSaleInspectionConsignment] PRIMARY KEY CLUSTERED ([ManheimFeedListingPostSaleInspectionConsignmentID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblManheimFeedListingPostSaleInspectionConsignment_tblManheimFeedListingPostSaleInspection] FOREIGN KEY ([ManheimFeedListingPostSaleInspectionID]) REFERENCES [postsale].[tblManheimFeedListingPostSaleInspection] ([ManheimFeedListingPostSaleInspectionID])
);

