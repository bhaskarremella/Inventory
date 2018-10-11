CREATE TABLE [dbo].[tblVehicleDecodeOption] (
    [VehicleDecodeOptionID] INT                                         IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]     DATETIME2 (7)                               CONSTRAINT [DF_tblVehicleDecodeOption_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]    DATETIME2 (7)                               NULL,
    [LastChangedByEmpID]    VARCHAR (128)                               NULL,
    [VehicleDecodeID]       INT                                         NOT NULL,
    [ExternalOptionID]      VARCHAR (36)                                NOT NULL,
    [ValidFromDate]         DATETIME2 (7) GENERATED ALWAYS AS ROW START CONSTRAINT [DF_tblVehicleDecodeOption_ValidFromDate] DEFAULT (sysdatetime()) NOT NULL,
    [ValidToDate]           DATETIME2 (7) GENERATED ALWAYS AS ROW END   CONSTRAINT [DF_tblVehicleDecodeOption_ValidToDate] DEFAULT (sysdatetime()) NOT NULL,
    CONSTRAINT [PK_tblVehicleDecodeOption] PRIMARY KEY CLUSTERED ([VehicleDecodeOptionID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblVehicleDecodeOption_tblVehicleDecode] FOREIGN KEY ([VehicleDecodeID]) REFERENCES [dbo].[tblVehicleDecode] ([VehicleDecodeID]),
    CONSTRAINT [AK_tblVehicleDecodeOption] UNIQUE NONCLUSTERED ([VehicleDecodeID] ASC, [ExternalOptionID] ASC) WITH (FILLFACTOR = 90),
    PERIOD FOR SYSTEM_TIME ([ValidFromDate], [ValidToDate])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Audit].[tblVehicleDecodeOption], DATA_CONSISTENCY_CHECK=ON));

