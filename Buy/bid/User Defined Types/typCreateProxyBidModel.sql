CREATE TYPE [bid].[typCreateProxyBidModel] AS TABLE (
    [AuctionID]     NVARCHAR (255) NOT NULL,
    [Channel]       NVARCHAR (255) NOT NULL,
    [VIN]           NVARCHAR (255) NOT NULL,
    [Amount]        INT            NULL,
    [CustomerId]    NVARCHAR (255) NOT NULL,
    [AccountNumber] NVARCHAR (255) NOT NULL,
    [RepUsername]   NVARCHAR (255) NOT NULL,
    [RepNumber]     INT            NOT NULL);

