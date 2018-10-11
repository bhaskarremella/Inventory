CREATE TABLE [Audit].[tblVehicleDecode] (
    [VehicleDecodeID]         INT           NOT NULL,
    [RowLoadedDateTime]       DATETIME2 (7) NOT NULL,
    [RowUpdatedDateTime]      DATETIME2 (7) NULL,
    [LastChangedByEmpID]      VARCHAR (128) NULL,
    [VIN]                     VARCHAR (17)  NULL,
    [ExternalConfigurationID] VARCHAR (36)  NOT NULL,
    [ValidFromDate]           DATETIME2 (7) NOT NULL,
    [ValidToDate]             DATETIME2 (7) NOT NULL
);

