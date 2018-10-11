CREATE TABLE [postsale].[tblManheimFeedListingPostSaleInspection] (
    [ManheimFeedListingPostSaleInspectionID] UNIQUEIDENTIFIER NOT NULL,
    [RowLoadedDateTime]                      DATETIME2 (3)    CONSTRAINT [DF_tblManheimFeedListingPostSaleInspection_RowLoadedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [RowUpdatedDateTime]                     DATETIME2 (3)    NULL,
    [ManheimFeedListingID]                   UNIQUEIDENTIFIER NOT NULL,
    [StatusTimestamp]                        VARCHAR (40)     NULL,
    [Status]                                 VARCHAR (20)     NULL,
    [StatusReason]                           VARCHAR (96)     NULL,
    [InspectionType]                         VARCHAR (32)     NULL,
    [LegacyPSICode]                          VARCHAR (32)     NULL,
    [LegacyDay14Flag]                        VARCHAR (20)     NULL,
    [Href]                                   VARCHAR (1000)   NULL,
    CONSTRAINT [PK_tblManheimFeedListingPostSaleInspection] PRIMARY KEY CLUSTERED ([ManheimFeedListingPostSaleInspectionID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblManheimFeedListingPostSaleInspection_tblManheimFeedListing] FOREIGN KEY ([ManheimFeedListingID]) REFERENCES [postsale].[tblManheimFeedListing] ([ManheimFeedListingID])
);


GO
CREATE NONCLUSTERED INDEX [idx_tblManheimFeedListingPostSaleInspection_ManheimFeedListingID]
    ON [postsale].[tblManheimFeedListingPostSaleInspection]([ManheimFeedListingID] ASC) WITH (FILLFACTOR = 90);

