CREATE TABLE [inlane].[tblVehicleList] (
    [VehicleListID]        BIGINT        IDENTITY (1, 1) NOT NULL,
    [LastUpdatedEmpID]     VARCHAR (128) CONSTRAINT [DF_tblVehicleList_LastUpdatedByEmpID] DEFAULT (suser_sname()) NOT NULL,
    [RowUpdatedDateTime]   DATETIME2 (3) CONSTRAINT [DF_tblVehicleList_RowUpdatedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowLoadedDateTime]    DATETIME2 (3) CONSTRAINT [DF_tblVehicleList_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [AuctionID]            BIGINT        NOT NULL,
    [AuctionName]          VARCHAR (255) NOT NULL,
    [AuctionNameShort]     AS            (replace([AuctionName],N'Manheim ',N'')) PERSISTED,
    [SaleDate]             DATE          NOT NULL,
    [SaleDateString]       AS            (CONVERT([varchar](10),CONVERT([date],[SaleDate]),(111))),
    [Lane]                 INT           NULL,
    [LaneString]           AS            (format([Lane],'00')),
    [Run]                  INT           NULL,
    [VIN]                  VARCHAR (17)  NOT NULL,
    [Year]                 SMALLINT      NULL,
    [Make]                 VARCHAR (100) NULL,
    [Model]                VARCHAR (100) NULL,
    [Color]                VARCHAR (50)  NULL,
    [YMMC]                 AS            (concat(CONVERT([varchar](4),[Year]),' ',[Make],' ',[Model],' ',[Color])) PERSISTED NOT NULL,
    [Odometer]             INT           NULL,
    [Size]                 VARCHAR (50)  NULL,
    [ReconTotal]           INT           NULL,
    [NADAValue]            INT           NULL,
    [IsVehicleNotFound]    BIT           CONSTRAINT [DF_tblVehicleList_IsVehicleNotFound] DEFAULT ((0)) NOT NULL,
    [IsInspectionComplete] BIT           CONSTRAINT [DF_tblVehicleList_IsInspectionComplete] DEFAULT ((0)) NOT NULL,
    [IsInspectionFailed]   BIT           CONSTRAINT [DF_tblVehicleList_IsInspectionFailed] DEFAULT ((0)) NOT NULL,
    [IsBuyerPreferred]     BIT           CONSTRAINT [DF_tblVehicleList_IsBuyerPreferred] DEFAULT ((0)) NOT NULL,
    [IsBuyComplete]        BIT           CONSTRAINT [DF_tblVehicleList_IsBuyComplete] DEFAULT ((0)) NOT NULL,
    [IsLaneSelected]       BIT           CONSTRAINT [DF_tblVehicleList_IsLaneSelected] DEFAULT ((0)) NOT NULL,
    [LaneSelectedBy]       VARCHAR (100) NULL,
    [IsDeletedByFeed]      BIT           CONSTRAINT [DF_tblVehicleList_IsDeletedByFeed] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblVehicleList] PRIMARY KEY CLUSTERED ([VehicleListID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblAuction_tblVehicleList] FOREIGN KEY ([AuctionID]) REFERENCES [inlane].[tblAuction] ([AuctionID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_tblVehicleList]
    ON [inlane].[tblVehicleList]([VIN] ASC, [SaleDate] ASC, [AuctionID] ASC) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This is used by PowerApps In Lane Buy App which requires the date to be a string.', @level0type = N'SCHEMA', @level0name = N'inlane', @level1type = N'TABLE', @level1name = N'tblVehicleList', @level2type = N'COLUMN', @level2name = N'SaleDateString';

