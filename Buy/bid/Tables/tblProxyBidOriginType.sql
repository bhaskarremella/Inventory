CREATE TABLE [bid].[tblProxyBidOriginType] (
    [ProxyBidOriginTypeID]      BIGINT        IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]         DATETIME2 (7) CONSTRAINT [DF_ProxyBidOriginType_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]        DATETIME2 (7) NULL,
    [LastChangedByEmpID]        VARCHAR (128) NULL,
    [ProxyBidOriginKey]         VARCHAR (50)  NULL,
    [ProxyBidOriginDescription] VARCHAR (200) NULL,
    [IsActive]                  TINYINT       DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblProxyBidOriginType_ProxyBidOriginTypeID] PRIMARY KEY CLUSTERED ([ProxyBidOriginTypeID] ASC) WITH (FILLFACTOR = 90)
);

