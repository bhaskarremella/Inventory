CREATE TABLE [stage].[tblVehicleListStage] (
    [VehicleListStageID] BIGINT        IDENTITY (1, 1) NOT NULL,
    [LastUpdatedEmpID]   VARCHAR (128) CONSTRAINT [DF_tblVehicleListStage_LastUpdatedByEmpID] DEFAULT (suser_sname()) NOT NULL,
    [RowUpdatedDateTime] DATETIME2 (3) CONSTRAINT [DF_tblVehicleListStage_RowUpdatedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowLoadedDateTime]  DATETIME2 (3) CONSTRAINT [DF_tblVehicleListStage_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [AuctionID]          BIGINT        NOT NULL,
    [AuctionName]        VARCHAR (255) NOT NULL,
    [SaleDate]           DATE          NOT NULL,
    [Lane]               INT           NULL,
    [Run]                INT           NULL,
    [VIN]                VARCHAR (17)  NOT NULL,
    [Year]               SMALLINT      NULL,
    [Make]               VARCHAR (100) NULL,
    [Model]              VARCHAR (100) NULL,
    [Color]              VARCHAR (50)  NULL,
    [Odometer]           INT           NULL,
    [Size]               VARCHAR (50)  NULL,
    CONSTRAINT [PK_tblVehicleListStage] PRIMARY KEY CLUSTERED ([VehicleListStageID] ASC) WITH (FILLFACTOR = 90)
);

