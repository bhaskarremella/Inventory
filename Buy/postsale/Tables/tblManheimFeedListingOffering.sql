CREATE TABLE [postsale].[tblManheimFeedListingOffering] (
    [ManheimFeedListingOfferingID] UNIQUEIDENTIFIER NOT NULL,
    [RowLoadedDateTime]            DATETIME2 (3)    CONSTRAINT [DF_tblManheimFeedListingOffering_RowLoadedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [RowUpdatedDateTime]           DATETIME2 (3)    NULL,
    [ManheimFeedListingID]         UNIQUEIDENTIFIER NOT NULL,
    [StartDate]                    VARCHAR (40)     NULL,
    [EndDate]                      VARCHAR (40)     NULL,
    [RegistrationDate]             VARCHAR (40)     NULL,
    [OfferingApplication]          VARCHAR (40)     NULL,
    [OfferMethod]                  VARCHAR (20)     NULL,
    [SaleType]                     VARCHAR (13)     NULL,
    [AsIs]                         VARCHAR (20)     NULL,
    [Salvage]                      VARCHAR (20)     NULL,
    [ConsignorCode]                VARCHAR (10)     NULL,
    [BidRestriction]               VARCHAR (13)     NULL,
    [OfferingStatus]               VARCHAR (16)     NULL,
    [OfferingStatusReason]         VARCHAR (96)     NULL,
    [Disclosures]                  NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_tblManheimFeedListingOffering] PRIMARY KEY CLUSTERED ([ManheimFeedListingOfferingID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblManheimFeedListingOffering_tblManheimFeedListing] FOREIGN KEY ([ManheimFeedListingID]) REFERENCES [postsale].[tblManheimFeedListing] ([ManheimFeedListingID])
);

