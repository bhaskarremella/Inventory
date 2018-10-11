CREATE TABLE [bid].[tblProxyBidStatus] (
    [ProxyBidStatusID] TINYINT        NOT NULL,
    [Description]      NVARCHAR (255) NOT NULL,
    CONSTRAINT [PK_tblProxyBidStatus] PRIMARY KEY CLUSTERED ([ProxyBidStatusID] ASC) WITH (FILLFACTOR = 90)
);

