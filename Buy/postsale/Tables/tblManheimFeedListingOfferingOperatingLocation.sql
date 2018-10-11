CREATE TABLE [postsale].[tblManheimFeedListingOfferingOperatingLocation] (
    [ManheimFeedListingOfferingOperatingLocationID] UNIQUEIDENTIFIER NOT NULL,
    [RowLoadedDateTime]                             DATETIME2 (3)    CONSTRAINT [DF_tblManheimFeedListingOfferingOperatingLocation_RowLoadedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [RowUpdatedDateTime]                            DATETIME2 (3)    NULL,
    [ManheimFeedListingOfferingID]                  UNIQUEIDENTIFIER NOT NULL,
    [LocationName]                                  VARCHAR (80)     NULL,
    [LocationCode]                                  VARCHAR (24)     NULL,
    [Href]                                          VARCHAR (1000)   NULL,
    CONSTRAINT [PK_tblManheimFeedListingOfferingOperatingLocation] PRIMARY KEY CLUSTERED ([ManheimFeedListingOfferingOperatingLocationID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblManheimFeedListingOfferingOperatingLocation_tblManheimFeedListingOffering] FOREIGN KEY ([ManheimFeedListingOfferingID]) REFERENCES [postsale].[tblManheimFeedListingOffering] ([ManheimFeedListingOfferingID])
);

