CREATE TABLE [dbo].[tblBuyAuctionVehicleInspectionStatus] (
    [BuyAuctionVehicleInspectionStatusID] BIGINT        IDENTITY (1, 1) NOT NULL,
    [BuyAuctionVehicleID]                 BIGINT        NOT NULL,
    [RowLoadedDateTime]                   DATETIME2 (7) NOT NULL,
    [RowUpdatedDateTime]                  DATETIME2 (7) NULL,
    [LastChangedByEmpID]                  VARCHAR (128) NULL,
    [InspectionStartedDateTime]           DATETIME2 (3) NULL,
    [InspectionCompletedDateTime]         DATETIME2 (3) NULL,
    [VehicleNotFoundDateTime]             DATETIME2 (3) NULL,
    [HasConditionReportDateTime]          DATETIME2 (3) NULL,
    [InspectionStatusKey]                 AS            (case when [HasConditionReportDateTime] IS NOT NULL AND [HasConditionReportDateTime]>coalesce([VehicleNotFoundDateTime],'') AND [HasConditionReportDateTime]>coalesce([InspectionStartedDateTime],'') AND [HasConditionReportDateTime]>coalesce([InspectionCompletedDateTime],'') then 'CRCOMPLETED' when [VehicleNotFoundDateTime] IS NOT NULL AND [VehicleNotFoundDateTime]>coalesce([InspectionStartedDateTime],'') AND [VehicleNotFoundDateTime]>coalesce([InspectionCompletedDateTime],'') AND [VehicleNotFoundDateTime]>coalesce([HasConditionReportDateTime],'') then 'VEHICLENOTFOUND' when [InspectionStartedDateTime] IS NULL AND [InspectionCompletedDateTime] IS NULL AND [VehicleNotFoundDateTime] IS NULL AND [HasConditionReportDateTime] IS NULL then 'NOTSTARTED' when [InspectionStartedDateTime] IS NOT NULL AND [InspectionStartedDateTime]>coalesce([VehicleNotFoundDateTime],'') AND [InspectionStartedDateTime]>coalesce([InspectionCompletedDateTime],'') AND [InspectionStartedDateTime]>coalesce([HasConditionReportDateTime],'') then 'STARTED' when [InspectionCompletedDateTime] IS NOT NULL AND [InspectionCompletedDateTime]>coalesce([InspectionStartedDateTime],'') AND [InspectionCompletedDateTime]>coalesce([VehicleNotFoundDateTime],'') AND [InspectionCompletedDateTime]>coalesce([HasConditionReportDateTime],'') then 'COMPLETED'  end),
    [InspectorName]                       VARCHAR (100) NULL,
    [InspectorEmail]                      VARCHAR (100) NULL,
    [InspectorEmployeeID]                 VARCHAR (20)  NULL,
    [IsDeleted]                           BIT           DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_BuyAuctionVehicleInspectionStatus_BuyAuctionVehicleInspectionStatusID] PRIMARY KEY CLUSTERED ([BuyAuctionVehicleInspectionStatusID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblBuyAuctionVehicleInspectionStatus_BuyAuctionVehicleID] FOREIGN KEY ([BuyAuctionVehicleID]) REFERENCES [dbo].[tblBuyAuctionVehicle] ([BuyAuctionVehicleID])
);

