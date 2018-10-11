CREATE TABLE [postsale].[tblManheimFeedListingConsignmentUnitPhysicalLocation] (
    [ManheimFeedListingConsignmentUnitPhysicalLocationID] UNIQUEIDENTIFIER NOT NULL,
    [RowLoadedDateTime]                                   DATETIME2 (3)    CONSTRAINT [DF_tblManheimFeedListingConsignmentUnitPhysicalLocation_RowLoadedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [RowUpdatedDateTime]                                  DATETIME2 (3)    NULL,
    [ManheimFeedListingConsignmentUnitID]                 UNIQUEIDENTIFIER NOT NULL,
    [Offsite]                                             VARCHAR (20)     NULL,
    [LocationName]                                        VARCHAR (80)     NULL,
    [LocationCode]                                        VARCHAR (24)     NULL,
    [Href]                                                VARCHAR (1000)   NULL,
    CONSTRAINT [PK_tblManheimFeedListingConsignmentUnitPhysicalLocation] PRIMARY KEY CLUSTERED ([ManheimFeedListingConsignmentUnitPhysicalLocationID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblManheimFeedListingConsignmentUnitPhysicalLocation_tblManheimFeedListingConsignmentUnit] FOREIGN KEY ([ManheimFeedListingConsignmentUnitID]) REFERENCES [postsale].[tblManheimFeedListingConsignmentUnit] ([ManheimFeedListingConsignmentUnitID])
);


GO
CREATE NONCLUSTERED INDEX [idx_tblManheimFeedListingConsignmentUnitPhysicalLocation_ManheimFeedListingConsignmentUnitID]
    ON [postsale].[tblManheimFeedListingConsignmentUnitPhysicalLocation]([ManheimFeedListingConsignmentUnitID] ASC) WITH (FILLFACTOR = 90);

