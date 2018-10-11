CREATE TABLE [postsale].[tblManheimFeed] (
    [ManheimFeedID]      UNIQUEIDENTIFIER NOT NULL,
    [ListingID]          VARCHAR (36)     NOT NULL,
    [RowLoadedDateTime]  DATETIME2 (3)    CONSTRAINT [DF_tblManheimFeed_RowLoadedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [RowUpdatedDateTime] DATETIME2 (3)    NULL,
    [CreatedOn]          VARCHAR (40)     NULL,
    [PurchaseDate]       VARCHAR (40)     NULL,
    [Channel]            VARCHAR (10)     NULL,
    [VIN]                VARCHAR (17)     NULL,
    [Status]             TINYINT          NULL,
    CONSTRAINT [PK_tblManheimFeed] PRIMARY KEY CLUSTERED ([ManheimFeedID] ASC) WITH (FILLFACTOR = 90)
);

