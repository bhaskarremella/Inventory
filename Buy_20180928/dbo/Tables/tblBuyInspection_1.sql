CREATE TABLE [dbo].[tblBuyInspection] (
    [BuyInspectionID]                BIGINT          IDENTITY (1, 1) NOT NULL,
    [BuyInspectionTypeID]            BIGINT          NOT NULL,
    [BuyVehicleID]                   BIGINT          NOT NULL,
    [BuyInspectionFailReasonTypeID]  BIGINT          NULL,
    [RowLoadedDateTime]              DATETIME2 (7)   CONSTRAINT [DF_tblBuyInspection_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]             DATETIME2 (7)   NULL,
    [LastChangedByEmpID]             VARCHAR (128)   NULL,
    [InspectionDateTime]             DATETIME2 (7)   NOT NULL,
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
    [IsDTPreferred]                  BIT             CONSTRAINT [DF_tblBuyInspection_IsDTPreferred] DEFAULT ((0)) NOT NULL,
    [IsInspectionFailed]             BIT             CONSTRAINT [DF_tblBuyInspection_IsInspectionFailed] DEFAULT ((0)) NOT NULL,
    [InspectorName]                  VARCHAR (100)   NULL,
    [InspectorEmail]                 VARCHAR (100)   NULL,
    [InspectorEmployeeID]            VARCHAR (20)    NULL,
    [IsDeleted]                      BIT             DEFAULT ((0)) NOT NULL,
    [SurveyResultsDateTime]          DATETIME2 (3)   NULL,
    CONSTRAINT [PK_tblBuyInspection_BuyInspectionID] PRIMARY KEY CLUSTERED ([BuyInspectionID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblBuyInspection_BuyInspectionFailReasonTypeID] FOREIGN KEY ([BuyInspectionFailReasonTypeID]) REFERENCES [dbo].[tblBuyInspectionFailReasonType] ([BuyInspectionFailReasonTypeID]),
    CONSTRAINT [FK_tblBuyInspection_BuyInspectionTypeID] FOREIGN KEY ([BuyInspectionTypeID]) REFERENCES [dbo].[tblBuyInspectionType] ([BuyInspectionTypeID]),
    CONSTRAINT [FK_tblBuyInspection_BuyVehicleID] FOREIGN KEY ([BuyVehicleID]) REFERENCES [dbo].[tblBuyVehicle] ([BuyVehicleID])
);


GO
CREATE NONCLUSTERED INDEX [idx_tblBuyInspection_BuyVehicleID_incl]
    ON [dbo].[tblBuyInspection]([BuyVehicleID] ASC)
    INCLUDE([BuyInspectionTypeID], [RowUpdatedDateTime], [ManualBookValue], [KBBValue], [InspectionNotes], [EstimatedReconTireGlass], [EstimatedReconExteriorCosmetic], [EstimatedReconInterior], [EstimatedReconOther], [EstimatedReconTotal], [DashboardLights], [IsDTPreferred], [IsInspectionFailed], [InspectorName]) WITH (FILLFACTOR = 90);

