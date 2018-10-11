CREATE TABLE [dbo].[tblKBBVehicle] (
    [KBBVehicleID]         BIGINT        IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]    DATETIME2 (7) CONSTRAINT [DF_tblKBBVehicle_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]   DATETIME2 (7) NULL,
    [LastChangedByEmpID]   VARCHAR (20)  NULL,
    [ExternalKBBVehicleID] INT           NOT NULL,
    [VIN]                  VARCHAR (17)  NOT NULL,
    [StockNumber]          BIGINT        NULL,
    [Year]                 INT           NULL,
    [Make]                 INT           NULL,
    [Model]                VARCHAR (100) NULL,
    [Trim]                 VARCHAR (500) NULL,
    CONSTRAINT [PK_tblKBBVehicle_KBBVehicleID] PRIMARY KEY CLUSTERED ([KBBVehicleID] ASC) WITH (FILLFACTOR = 90)
);

