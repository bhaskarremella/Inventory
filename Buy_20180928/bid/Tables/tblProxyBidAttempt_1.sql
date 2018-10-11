CREATE TABLE [bid].[tblProxyBidAttempt] (
    [ProxyBidAttemptID]    BIGINT         IDENTITY (1, 1) NOT NULL,
    [ProxyBidRequestID]    BIGINT         NOT NULL,
    [AttemptStartDateTime] DATETIME2 (7)  NOT NULL,
    [AttemptStopDateTime]  DATETIME2 (7)  NULL,
    [OutcomeErrorMessage]  NTEXT          NULL,
    [OutcomeStatusCode]    NVARCHAR (255) NULL,
    [BidUrl]               NTEXT          NULL,
    CONSTRAINT [PK_tblProxyBidAttempt] PRIMARY KEY CLUSTERED ([ProxyBidAttemptID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblProxyBidAttempt_tblProxyBidRequest] FOREIGN KEY ([ProxyBidRequestID]) REFERENCES [bid].[tblProxyBidRequest] ([ProxyBidRequestID]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [idx_tblProxyBidAttempt_ProxyBidRequestID]
    ON [bid].[tblProxyBidAttempt]([ProxyBidRequestID] ASC)
    INCLUDE([ProxyBidAttemptID]) WITH (FILLFACTOR = 90);

