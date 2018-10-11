CREATE TABLE [presale].[tblAuctionEdgeFeedAuction] (
    [AuctionEdgeFeedAuctionID] BIGINT        IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]        DATETIME2 (7) CONSTRAINT [DF_tblAuctionEdgeFeedAuction_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [BatchID]                  INT           NOT NULL,
    [AuctionID]                VARCHAR (50)  NULL,
    [Name]                     VARCHAR (150) NULL,
    [City]                     VARCHAR (100) NULL,
    [State]                    VARCHAR (50)  NULL,
    [Zip]                      VARCHAR (50)  NULL,
    [TimeZone]                 VARCHAR (100) NULL,
    CONSTRAINT [PK_tblAuctionEdgeFeedAuction] PRIMARY KEY NONCLUSTERED ([AuctionEdgeFeedAuctionID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE CLUSTERED INDEX [idx_tblAuctionEdgeFeedAuction_AuctionID_BatchID]
    ON [presale].[tblAuctionEdgeFeedAuction]([AuctionID] ASC, [BatchID] ASC) WITH (FILLFACTOR = 90);

