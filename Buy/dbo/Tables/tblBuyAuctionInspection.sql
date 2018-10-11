﻿CREATE TABLE [dbo].[tblBuyAuctionInspection] (
    [BuyAuctionInspectionID]         BIGINT          IDENTITY (1, 1) NOT NULL,
    [BuyInspectionTypeID]            BIGINT          NOT NULL,
    [BuyAuctionVehicleID]            BIGINT          NOT NULL,
    [BuyInspectionFailReasonTypeID]  BIGINT          NULL,
    [RowLoadedDateTime]              DATETIME2 (7)   CONSTRAINT [DF_tblBuyAuctionInspection_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]             DATETIME2 (7)   NULL,
    [LastChangedByEmpID]             VARCHAR (128)   NULL,
    [InspectionStartedDateTime]      DATETIME2 (3)   NULL,
    [InspectionCompletedDateTime]    DATETIME2 (3)   NULL,
    [VehicleNotFoundDateTime]        DATETIME2 (3)   NULL,
    [HasConditionReportDateTime]     DATETIME2 (3)   NULL,
    [InspectionStatusKey]            AS              (case when [HasConditionReportDateTime] IS NOT NULL AND [HasConditionReportDateTime]>coalesce([VehicleNotFoundDateTime],'') AND [HasConditionReportDateTime]>coalesce([InspectionStartedDateTime],'') AND [HasConditionReportDateTime]>coalesce([InspectionCompletedDateTime],'') then 'CRCOMPLETED' when [VehicleNotFoundDateTime] IS NOT NULL AND [VehicleNotFoundDateTime]>coalesce([InspectionStartedDateTime],'') AND [VehicleNotFoundDateTime]>coalesce([InspectionCompletedDateTime],'') AND [VehicleNotFoundDateTime]>coalesce([HasConditionReportDateTime],'') then 'VEHICLENOTFOUND' when [InspectionStartedDateTime] IS NULL AND [InspectionCompletedDateTime] IS NULL AND [VehicleNotFoundDateTime] IS NULL AND [HasConditionReportDateTime] IS NULL then 'NOTSTARTED' when [InspectionStartedDateTime] IS NOT NULL AND [InspectionStartedDateTime]>coalesce([VehicleNotFoundDateTime],'') AND [InspectionStartedDateTime]>coalesce([InspectionCompletedDateTime],'') AND [InspectionStartedDateTime]>coalesce([HasConditionReportDateTime],'') then 'STARTED' when [InspectionCompletedDateTime] IS NOT NULL AND [InspectionCompletedDateTime]>coalesce([InspectionStartedDateTime],'') AND [InspectionCompletedDateTime]>coalesce([VehicleNotFoundDateTime],'') AND [InspectionCompletedDateTime]>coalesce([HasConditionReportDateTime],'') then 'COMPLETED'  end),
    [ManualBookValue]                DECIMAL (10, 4) NULL,
    [KBBValue]                       DECIMAL (10, 4) NULL,
    [InspectionLatitude]             FLOAT (53)      NULL,
    [InspectionLongitude]            FLOAT (53)      NULL,
    [InspectionNotes]                VARCHAR (500)   NULL,
    [IsVehicleNotFound]              BIT             NULL,
    [EstimatedReconTireGlass]        DECIMAL (10, 4) NULL,
    [EstimatedReconExteriorCosmetic] DECIMAL (10, 4) NULL,
    [EstimatedReconInterior]         DECIMAL (10, 4) NULL,
    [EstimatedReconOther]            DECIMAL (10, 4) NULL,
    [EstimatedReconTotal]            DECIMAL (10, 4) NULL,
    [DashboardLights]                VARCHAR (500)   NULL,
    [IsDTPreferred]                  BIT             CONSTRAINT [DF_tblBuyAuctionInspection_IsDTPreferred] DEFAULT ((0)) NOT NULL,
    [IsInspectionFailed]             BIT             CONSTRAINT [DF_tblBuyAuctionInspection_IsInspectionFailed] DEFAULT ((0)) NOT NULL,
    [InspectorName]                  VARCHAR (100)   NULL,
    [InspectorEmail]                 VARCHAR (100)   NULL,
    [InspectorEmployeeID]            VARCHAR (20)    NULL,
    [IsDeleted]                      BIT             DEFAULT ((0)) NOT NULL,
    [SurveyResultsDateTime]          DATETIME2 (3)   NULL,
    [SurveyCompletedDateTime]        DATETIME2 (7)   NULL,
    CONSTRAINT [PK_tblBuyAuctionInspection_BuyAuctionInspectionID] PRIMARY KEY CLUSTERED ([BuyAuctionInspectionID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblBuyAuctionInspection_BuyAuctionVehicleID] FOREIGN KEY ([BuyAuctionVehicleID]) REFERENCES [dbo].[tblBuyAuctionVehicle] ([BuyAuctionVehicleID]),
    CONSTRAINT [FK_tblBuyAuctionInspection_BuyInspectionFailReasonTypeID] FOREIGN KEY ([BuyInspectionFailReasonTypeID]) REFERENCES [dbo].[tblBuyInspectionFailReasonType] ([BuyInspectionFailReasonTypeID]),
    CONSTRAINT [FK_tblBuyAuctionInspection_BuyInspectionTypeID] FOREIGN KEY ([BuyInspectionTypeID]) REFERENCES [dbo].[tblBuyInspectionType] ([BuyInspectionTypeID])
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblBuyAuctionInspection_BuyAuctionVehicleID]
    ON [dbo].[tblBuyAuctionInspection]([BuyAuctionVehicleID] ASC) WITH (FILLFACTOR = 90);

