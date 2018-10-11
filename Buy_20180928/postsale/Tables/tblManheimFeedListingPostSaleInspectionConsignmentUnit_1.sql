CREATE TABLE [postsale].[tblManheimFeedListingPostSaleInspectionConsignmentUnit] (
    [ManheimFeedListingPostSaleInspectionConsignmentUnitID] UNIQUEIDENTIFIER NOT NULL,
    [RowLoadedDateTime]                                     DATETIME2 (3)    CONSTRAINT [DF_tblManheimFeedListingPostSaleInspectionConsignmentUnit_RowLoadedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [RowUpdatedDateTime]                                    DATETIME2 (3)    NULL,
    [ManheimFeedListingPostSaleInspectionConsignmentID]     UNIQUEIDENTIFIER NOT NULL,
    [VIN]                                                   VARCHAR (17)     NULL,
    [ModelYear]                                             SMALLINT         NULL,
    [Make]                                                  VARCHAR (50)     NULL,
    [Model]                                                 VARCHAR (100)    NULL,
    CONSTRAINT [PK_tblManheimFeedListingPostSaleInspectionConsignmentUnit] PRIMARY KEY CLUSTERED ([ManheimFeedListingPostSaleInspectionConsignmentUnitID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblManheimFeedListingPostSaleInspectionConsignmentUnit_tblManheimFeedListingPostSaleInspectionConsignment] FOREIGN KEY ([ManheimFeedListingPostSaleInspectionConsignmentID]) REFERENCES [postsale].[tblManheimFeedListingPostSaleInspectionConsignment] ([ManheimFeedListingPostSaleInspectionConsignmentID])
);

