CREATE TABLE [postsale].[tblManheimFeedListingConsignmentUnitPhysicalLocationAddress] (
    [ManheimFeedListingConsignmentUnitPhysicalLocationAddressID] UNIQUEIDENTIFIER NOT NULL,
    [RowLoadedDateTime]                                          DATETIME2 (3)    CONSTRAINT [DF_tblManheimFeedListingConsignmentUnitPhysicalLocationAddress_RowLoadedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [RowUpdatedDateTime]                                         DATETIME2 (3)    NULL,
    [ManheimFeedListingConsignmentUnitPhysicalLocationID]        UNIQUEIDENTIFIER NOT NULL,
    [Address1]                                                   VARCHAR (96)     NULL,
    [City]                                                       VARCHAR (40)     NULL,
    [StateProvinceRegion]                                        VARCHAR (10)     NULL,
    [Country]                                                    VARCHAR (25)     NULL,
    [PostalCode]                                                 VARCHAR (24)     NULL,
    CONSTRAINT [PK_tblManheimFeedListingConsignmentUnitPhysicalLocationAddress] PRIMARY KEY CLUSTERED ([ManheimFeedListingConsignmentUnitPhysicalLocationAddressID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblManheimFeedListingConsignmentUnitPhysicalLocationAddress_tblManheimFeedListingConsignmentUnitPhysicalLocation] FOREIGN KEY ([ManheimFeedListingConsignmentUnitPhysicalLocationID]) REFERENCES [postsale].[tblManheimFeedListingConsignmentUnitPhysicalLocation] ([ManheimFeedListingConsignmentUnitPhysicalLocationID])
);


GO
CREATE NONCLUSTERED INDEX [idx_tblManheimFeedListingConsignmentUnitPhysicalLocationAddress_ManheimFeedListingConsignmentUnitPhysicalLocationID]
    ON [postsale].[tblManheimFeedListingConsignmentUnitPhysicalLocationAddress]([ManheimFeedListingConsignmentUnitPhysicalLocationID] ASC) WITH (FILLFACTOR = 90);

