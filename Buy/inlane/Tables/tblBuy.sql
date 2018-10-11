CREATE TABLE [inlane].[tblBuy] (
    [BuyID]              BIGINT            IDENTITY (1, 1) NOT NULL,
    [LastUpdatedEmpID]   VARCHAR (128)     CONSTRAINT [DF_tblBuy_LastUpdatedEmpID] DEFAULT (suser_sname()) NOT NULL,
    [RowUpdatedDateTime] DATETIME2 (3)     CONSTRAINT [DF_tblBuy_RowUpdatedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowLoadedDateTime]  DATETIME2 (3)     CONSTRAINT [DF_tblBuy_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [VehicleListID]      BIGINT            NOT NULL,
    [BuyerName]          VARCHAR (100)     NULL,
    [BuyerEmail]         VARCHAR (100)     NULL,
    [BuyerBucket]        VARCHAR (50)      NULL,
    [LastBid]            MONEY             NULL,
    [BuyLatitude]        FLOAT (53)        NULL,
    [BuyLongitude]       FLOAT (53)        NULL,
    [BuyLocation]        [sys].[geography] NULL,
    CONSTRAINT [PK_tblBuy] PRIMARY KEY CLUSTERED ([BuyID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblBuy_tblVehicleList] FOREIGN KEY ([VehicleListID]) REFERENCES [inlane].[tblVehicleList] ([VehicleListID])
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblBuy_VehicleListID]
    ON [inlane].[tblBuy]([VehicleListID] ASC) WITH (FILLFACTOR = 90);

