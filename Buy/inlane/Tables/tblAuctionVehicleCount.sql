CREATE TABLE [inlane].[tblAuctionVehicleCount] (
    [AuctionVehicleID]    INT           IDENTITY (1, 1) NOT NULL,
    [LastUpdatedByEmpID]  VARCHAR (128) CONSTRAINT [DF_tblVehicleCount_LastUpdatedByEmpID] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDateTime] DATETIME2 (3) CONSTRAINT [DF_tblVehicleCount_LastUpdatedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowLoadedDateTime]   DATETIME2 (3) CONSTRAINT [DF_tblVehicleCount_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [AuctionID]           BIGINT        NOT NULL,
    [AuctionName]         VARCHAR (255) NULL,
    [AuctionNameShort]    VARCHAR (50)  NULL,
    [VehicleCount]        INT           NOT NULL,
    [IsActive]            BIT           CONSTRAINT [DF_tblAuctionVehicleCount_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_tblVehicleCount] PRIMARY KEY CLUSTERED ([AuctionVehicleID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This is the total count of vehicles for the day', @level0type = N'SCHEMA', @level0name = N'inlane', @level1type = N'TABLE', @level1name = N'tblAuctionVehicleCount', @level2type = N'COLUMN', @level2name = N'VehicleCount';

