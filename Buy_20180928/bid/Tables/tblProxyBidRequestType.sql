CREATE TABLE [bid].[tblProxyBidRequestType] (
    [ProxyBidRequestTypeID] TINYINT        NOT NULL,
    [Description]           NVARCHAR (255) NOT NULL,
    CONSTRAINT [PK_tblProxyBidRequestType] PRIMARY KEY CLUSTERED ([ProxyBidRequestTypeID] ASC) WITH (FILLFACTOR = 90)
);

