CREATE TABLE [inlane].[tblAuction] (
    [AuctionID]          BIGINT        NOT NULL,
    [AuctionKeyID]       VARCHAR (10)  NULL,
    [LastUpdatedEmpID]   VARCHAR (128) CONSTRAINT [DF_tblAuction_LastUpdatedEmpID] DEFAULT (suser_sname()) NOT NULL,
    [RowUpdatedDateTime] DATETIME2 (3) CONSTRAINT [DF_tblAuction_RowUpdatedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowLoadedDateTime]  DATETIME2 (3) CONSTRAINT [DF_tblAuction_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [AuctionName]        VARCHAR (255) NULL,
    [AuctionNameShort]   AS            (replace([AuctionName],N'Manheim ',N'')),
    [AuctionInitials]    VARCHAR (20)  NULL,
    [Address1]           VARCHAR (50)  NULL,
    [City]               VARCHAR (40)  NULL,
    [AuctionState]       CHAR (2)      NULL,
    [PostalCD]           VARCHAR (20)  NULL,
    [Country]            VARCHAR (30)  NULL,
    [Phone]              VARCHAR (30)  NULL,
    [IsActive]           BIT           NOT NULL,
    [IsPilot]            BIT           CONSTRAINT [DF_tblAuction_IsPilot] DEFAULT ((0)) NOT NULL,
    [AuctionVendorID]    INT           CONSTRAINT [DF_tblAuction_AuctionVendoryID] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_tblAuction] PRIMARY KEY CLUSTERED ([AuctionID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [AK_tblAuction] UNIQUE NONCLUSTERED ([AuctionKeyID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [idx_tblAuction_AuctionID_IsPilot]
    ON [inlane].[tblAuction]([AuctionID] ASC, [IsPilot] ASC) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This ties to our Master Inventory Auction Table in Datamart.InventoryDM.dbo.tblAuctionList.AuctionListID', @level0type = N'SCHEMA', @level0name = N'inlane', @level1type = N'TABLE', @level1name = N'tblAuction', @level2type = N'COLUMN', @level2name = N'AuctionID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This is received directly from the Manheim presale feeds as the AuctionID', @level0type = N'SCHEMA', @level0name = N'inlane', @level1type = N'TABLE', @level1name = N'tblAuction', @level2type = N'COLUMN', @level2name = N'AuctionKeyID';

