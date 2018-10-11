CREATE TABLE [dbo].[tblBuyStage] (
    [BuyStageID]                     BIGINT          IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]              DATETIME2 (7)   CONSTRAINT [DF_tblBuyStage_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]             DATETIME2 (7)   NULL,
    [LastChangedByEmpID]             VARCHAR (128)   NULL,
    [VIN]                            VARCHAR (17)    NULL,
    [Year]                           SMALLINT        NULL,
    [Make]                           VARCHAR (100)   NULL,
    [Model]                          VARCHAR (100)   NULL,
    [Color]                          VARCHAR (50)    NULL,
    [BodyStyle]                      VARCHAR (100)   NULL,
    [Size]                           VARCHAR (50)    NULL,
    [SaleDate]                       DATE            NULL,
    [Lane]                           VARCHAR (50)    NULL,
    [Run]                            VARCHAR (50)    NULL,
    [Odometer]                       INT             NULL,
    [SellerName]                     VARCHAR (220)   NULL,
    [VehicleLink]                    VARCHAR (500)   NULL,
    [CRLink]                         VARCHAR (500)   NULL,
    [CRScore]                        VARCHAR (50)    NULL,
    [PreSaleAnnouncement]            VARCHAR (250)   NULL,
    [PriceCap]                       DECIMAL (10, 4) NULL,
    [IsPreviousDTVehicle]            BIT             CONSTRAINT [DF_tblBuyStage_IsPreviousDTVehicle] DEFAULT ((0)) NOT NULL,
    [IsDTInspectionRequested]        BIT             CONSTRAINT [DF_tblBuyStagee_IsDTInspectionRequested] DEFAULT ((0)) NOT NULL,
    [IsDecommissioned]               BIT             CONSTRAINT [DF_tblBuyStage_IsDecommissioned] DEFAULT ((0)) NOT NULL,
    [IsDecommissionedDateTime]       DATETIME2 (7)   NULL,
    [KBBMultiplier]                  DECIMAL (10, 4) CONSTRAINT [DF_tblBuyStage_KBBMultiplier] DEFAULT ((1)) NULL,
    [KBBDTAdjustmentValue]           DECIMAL (10, 4) CONSTRAINT [DF_tblBuyStage_KBBDTAdjustmentValue] DEFAULT ((0)) NULL,
    [MMRValue]                       DECIMAL (10, 4) NULL,
    [BuyStrategyID]                  TINYINT         NULL,
    [Images]                         VARCHAR (MAX)   NULL,
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
    [IsDTPreferred]                  BIT             CONSTRAINT [DF_tblBuyStage_IsDTPreferred] DEFAULT ((0)) NOT NULL,
    [IsInspectionFailed]             BIT             CONSTRAINT [DF_tblBuyStage_IsInspectionFailed] DEFAULT ((0)) NOT NULL,
    [InspectorName]                  VARCHAR (100)   NULL,
    [InspectorEmail]                 VARCHAR (100)   NULL,
    [InspectorEmployeeID]            VARCHAR (20)    NULL,
    [IsDeleted]                      BIT             DEFAULT ((0)) NOT NULL,
    [AuctionName]                    VARCHAR (100)   NULL,
    [InspectionDateTime]             DATETIME2 (7)   NULL,
    [IsAIMInspection]                BIT             CONSTRAINT [DF_tblBuyStage_IsAIMInspection] DEFAULT ((0)) NOT NULL,
    [IsAccuCheckIssue]               TINYINT         CONSTRAINT [DF_tblBuyStage_IsAccuCheckIssue] DEFAULT ((0)) NULL,
    [IsAccuCheckIssueDateTime]       DATETIME2 (7)   NULL
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblBuyStage_VIN_Inc_Year_Make_Model_Color_BodyStyle_Size]
    ON [dbo].[tblBuyStage]([VIN] ASC)
    INCLUDE([Year], [Make], [Model], [Color], [BodyStyle], [Size]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IDX_tblBuyStage_AuctionName_Includes]
    ON [dbo].[tblBuyStage]([AuctionName] ASC)
    INCLUDE([VIN], [SaleDate], [Lane], [Run], [Odometer], [SellerName], [VehicleLink], [CRLink], [CRScore], [PreSaleAnnouncement], [PriceCap], [IsPreviousDTVehicle], [IsDTInspectionRequested], [IsDecommissioned], [IsDecommissionedDateTime], [KBBMultiplier], [KBBDTAdjustmentValue], [MMRValue], [BuyStrategyID], [Images], [IsAccuCheckIssue], [IsAccuCheckIssueDateTime]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IDX_tblBuyStage_InspectionDateTime]
    ON [dbo].[tblBuyStage]([InspectionDateTime] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IDX_tblBuyStage_IsAIMIspection_Includes]
    ON [dbo].[tblBuyStage]([IsAIMInspection] ASC)
    INCLUDE([VIN], [SaleDate], [ManualBookValue], [InspectorName], [InspectorEmail], [InspectorEmployeeID], [InspectionDateTime]) WITH (FILLFACTOR = 90);

