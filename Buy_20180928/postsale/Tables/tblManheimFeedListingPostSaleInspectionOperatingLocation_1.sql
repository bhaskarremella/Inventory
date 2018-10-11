CREATE TABLE [postsale].[tblManheimFeedListingPostSaleInspectionOperatingLocation] (
    [ManheimFeedListingPostSaleInspectionOperatingLocationID] UNIQUEIDENTIFIER NOT NULL,
    [RowLoadedDateTime]                                       DATETIME2 (3)    CONSTRAINT [DF_tblManheimFeedListingPostSaleInspectionOperatingLocation_RowLoadedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [RowUpdatedDateTime]                                      DATETIME2 (3)    NULL,
    [ManheimFeedListingPostSaleInspectionID]                  UNIQUEIDENTIFIER NOT NULL,
    [LocationName]                                            VARCHAR (80)     NULL,
    [LocationCode]                                            VARCHAR (24)     NULL,
    [Href]                                                    VARCHAR (1000)   NULL,
    CONSTRAINT [PK_tblManheimFeedListingPostSaleInspectionOperatingLocation] PRIMARY KEY CLUSTERED ([ManheimFeedListingPostSaleInspectionOperatingLocationID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblManheimFeedListingPostSaleInspectionOperatingLocation_tblManheimFeedListingPostSaleInspection] FOREIGN KEY ([ManheimFeedListingPostSaleInspectionID]) REFERENCES [postsale].[tblManheimFeedListingPostSaleInspection] ([ManheimFeedListingPostSaleInspectionID])
);

