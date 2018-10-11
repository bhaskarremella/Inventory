CREATE TABLE [bid].[tblProxyBidRequest] (
    [ProxyBidRequestID]     BIGINT           IDENTITY (1, 1) NOT NULL,
    [ProxyBidID]            BIGINT           NOT NULL,
    [ProxyBidRequestTypeID] TINYINT          NOT NULL,
    [Amount]                INT              NULL,
    [IsDeleted]             BIT              CONSTRAINT [DF_tblProxyBidRequest_IsDeleted] DEFAULT ((0)) NOT NULL,
    [RowLoadedDateTime]     DATETIME2 (7)    CONSTRAINT [DF_tblProxyBidRequest_RowLoadedDateTime] DEFAULT (getutcdate()) NOT NULL,
    [RowUpdatedDateTime]    DATETIME2 (7)    CONSTRAINT [DF_tblProxyBidRequest_RowUpdatedDateTime] DEFAULT (getutcdate()) NOT NULL,
    [AttemptCount]          INT              CONSTRAINT [DF_tblProxyBidRequest_AttemptCount] DEFAULT ((0)) NOT NULL,
    [ExecutionTimeSeconds]  FLOAT (53)       CONSTRAINT [DF_tblProxyBidRequest_ExecutionTimeSeconds] DEFAULT ((0)) NOT NULL,
    [SessionId]             UNIQUEIDENTIFIER NULL,
    [CompletedSuccessfully] BIT              CONSTRAINT [DF_tblProxyBidRequest_CompletedSuccessfully] DEFAULT ((0)) NOT NULL,
    [ProxyBidOriginTypeID]  BIGINT           CONSTRAINT [DF_tblProxyBidRequest_ProxyBidOriginTypeID] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_tblProxyBidRequest] PRIMARY KEY CLUSTERED ([ProxyBidRequestID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblProxyBidRequest_ProxyBidOriginTypeID] FOREIGN KEY ([ProxyBidOriginTypeID]) REFERENCES [bid].[tblProxyBidOriginType] ([ProxyBidOriginTypeID]),
    CONSTRAINT [FK_tblProxyBidRequest_tblProxyBid] FOREIGN KEY ([ProxyBidID]) REFERENCES [bid].[tblProxyBid] ([ProxyBidID]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_tblProxyBidRequest_ProxyBidID]
    ON [bid].[tblProxyBidRequest]([ProxyBidID] ASC) WITH (FILLFACTOR = 90);

