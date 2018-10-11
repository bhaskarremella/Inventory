CREATE TABLE [postsale].[tblManheimFeedListingConsignmentUnit] (
    [ManheimFeedListingConsignmentUnitID] UNIQUEIDENTIFIER NOT NULL,
    [RowLoadedDateTime]                   DATETIME2 (3)    CONSTRAINT [DF_tblManheimFeedListingConsignmentUnit_RowLoadedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [RowUpdatedDateTime]                  DATETIME2 (3)    NULL,
    [ManheimFeedListingConsignmentID]     UNIQUEIDENTIFIER NOT NULL,
    [VIN]                                 VARCHAR (17)     NULL,
    [ModelYear]                           SMALLINT         NULL,
    [Make]                                VARCHAR (50)     NULL,
    [Model]                               VARCHAR (100)    NULL,
    [Trim]                                VARCHAR (65)     NULL,
    [Body]                                VARCHAR (16)     NULL,
    [EngineDescription]                   VARCHAR (64)     NULL,
    [OdometerReading]                     INT              NULL,
    [OdometerUnits]                       VARCHAR (20)     NULL,
    [VehicleType]                         VARCHAR (48)     NULL,
    [InteriorColor]                       VARCHAR (15)     NULL,
    [ExteriorColor]                       VARCHAR (15)     NULL,
    CONSTRAINT [PK_tblManheimFeedListingConsignmentUnit] PRIMARY KEY CLUSTERED ([ManheimFeedListingConsignmentUnitID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblManheimFeedListingConsignmentUnit_tblManheimFeedListingConsignment] FOREIGN KEY ([ManheimFeedListingConsignmentID]) REFERENCES [postsale].[tblManheimFeedListingConsignment] ([ManheimFeedListingConsignmentID])
);

