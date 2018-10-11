CREATE TABLE [inlane].[tblInspection] (
    [InspectionID]                   BIGINT        IDENTITY (1, 1) NOT NULL,
    [LastUpdatedEmpID]               VARCHAR (128) CONSTRAINT [DF_tblInspection_LastUpdatedEmpID] DEFAULT (suser_sname()) NOT NULL,
    [RowUpdatedDateTime]             DATETIME2 (3) CONSTRAINT [DF_tblInspection_RowUpdatedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowLoadedDateTime]              DATETIME2 (3) CONSTRAINT [DF_tblInspection_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [VehicleListID]                  BIGINT        NOT NULL,
    [InspectionStartTime]            DATETIME2 (3) NULL,
    [InspectionEndTime]              DATETIME2 (3) NULL,
    [InspectorName]                  VARCHAR (100) NULL,
    [InspectorEmail]                 VARCHAR (100) NULL,
    [VehicleFound]                   VARCHAR (10)  NULL,
    [Pass3FtInspection]              VARCHAR (10)  NULL,
    [VehicleHasKeys]                 VARCHAR (10)  NULL,
    [ReconFrontEnd]                  VARCHAR (100) NULL,
    [ReconRightSide]                 VARCHAR (100) NULL,
    [ReconRightSideTW]               VARCHAR (100) NULL,
    [ReconRearEnd]                   VARCHAR (100) NULL,
    [ReconLeftSide]                  VARCHAR (100) NULL,
    [ReconLeftSideTW]                VARCHAR (100) NULL,
    [ReconGlass]                     VARCHAR (100) NULL,
    [ReconRoof]                      VARCHAR (100) NULL,
    [ReconInterior]                  VARCHAR (100) NULL,
    [StructuralMechanicalInspection] VARCHAR (10)  NULL,
    [StructuralMechanicalFailReason] VARCHAR (200) NULL,
    [ReconTotal]                     MONEY         NULL,
    [BookValue]                      MONEY         NULL,
    [InspectionLatitude]             FLOAT (53)    NULL,
    [InspectionLongitude]            FLOAT (53)    NULL,
    [InspectionLocation]             AS            ([geography]::STPointFromText(((('POINT('+CONVERT([varchar](50),[InspectionLongitude]))+' ')+CONVERT([varchar](50),[InspectionLatitude]))+')',(4326))),
    CONSTRAINT [PK_tblInspection] PRIMARY KEY CLUSTERED ([InspectionID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblInspection_tblVehicleList] FOREIGN KEY ([VehicleListID]) REFERENCES [inlane].[tblVehicleList] ([VehicleListID])
);


GO
CREATE NONCLUSTERED INDEX [idx_tblInspection_VehicleListID]
    ON [inlane].[tblInspection]([VehicleListID] ASC) WITH (FILLFACTOR = 90);

