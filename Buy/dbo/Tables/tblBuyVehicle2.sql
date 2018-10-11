CREATE TABLE [dbo].[tblBuyVehicle2] (
    [BuyVehicleID]       BIGINT        IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]  DATETIME2 (7) CONSTRAINT [DF_tblBuyVehicle2_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime] DATETIME2 (7) NULL,
    [LastChangedByEmpID] VARCHAR (20)  NULL,
    [VIN]                VARCHAR (17)  NULL,
    [Year]               SMALLINT      NULL,
    [Make]               VARCHAR (100) NULL,
    [Model]              VARCHAR (100) NULL,
    [Color]              VARCHAR (50)  NULL,
    [Odometer]           INT           NULL,
    [BodyStyle]          VARCHAR (100) NULL,
    [Size]               VARCHAR (50)  NULL,
    [BuyInspectionID]    BIGINT        NOT NULL,
    CONSTRAINT [PK_tblBuyVehicle2_BuyVehicleID] PRIMARY KEY CLUSTERED ([BuyVehicleID] ASC) WITH (FILLFACTOR = 90)
);

