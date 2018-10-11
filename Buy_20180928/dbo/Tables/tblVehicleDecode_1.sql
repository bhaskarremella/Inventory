CREATE TABLE [dbo].[tblVehicleDecode] (
    [VehicleDecodeID]         INT                                         IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]       DATETIME2 (7)                               CONSTRAINT [DF_tblVehicleDecode_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]      DATETIME2 (7)                               NULL,
    [LastChangedByEmpID]      VARCHAR (128)                               NULL,
    [VIN]                     VARCHAR (17)                                NULL,
    [ExternalConfigurationID] VARCHAR (36)                                NOT NULL,
    [ValidFromDate]           DATETIME2 (7) GENERATED ALWAYS AS ROW START CONSTRAINT [DF_tblVehicleDecode_ValidFromDate] DEFAULT (sysdatetime()) NOT NULL,
    [ValidToDate]             DATETIME2 (7) GENERATED ALWAYS AS ROW END   CONSTRAINT [DF_tblVehicleDecode_ValidToDate] DEFAULT (sysdatetime()) NOT NULL,
    CONSTRAINT [PK_tblVehicleDecode] PRIMARY KEY CLUSTERED ([VehicleDecodeID] ASC) WITH (FILLFACTOR = 90),
    PERIOD FOR SYSTEM_TIME ([ValidFromDate], [ValidToDate])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Audit].[tblVehicleDecode], DATA_CONSISTENCY_CHECK=ON));

