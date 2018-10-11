CREATE TABLE [dbo].[tblBuyVehicle] (
    [BuyVehicleID]       BIGINT        IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]  DATETIME2 (7) CONSTRAINT [DF_tblBuyVehicle_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime] DATETIME2 (7) NULL,
    [LastChangedByEmpID] VARCHAR (128) NULL,
    [VIN]                VARCHAR (17)  NULL,
    [Year]               SMALLINT      NULL,
    [Make]               VARCHAR (100) NULL,
    [Model]              VARCHAR (100) NULL,
    [Color]              VARCHAR (50)  NULL,
    [BodyStyle]          VARCHAR (100) NULL,
    [Size]               VARCHAR (50)  NULL,
    CONSTRAINT [PK_tblBuyVehicle_BuyVehicleID] PRIMARY KEY CLUSTERED ([BuyVehicleID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [idx_tblBuyVehicle_BuyVehicleID]
    ON [dbo].[tblBuyVehicle]([BuyVehicleID] ASC)
    INCLUDE([VIN], [Year], [Make], [Model], [Color], [Size]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idx_tblBuyVehicle_VIN]
    ON [dbo].[tblBuyVehicle]([VIN] ASC)
    INCLUDE([BuyVehicleID], [Year], [Make], [Model], [Color], [BodyStyle], [Size]) WITH (FILLFACTOR = 90);

