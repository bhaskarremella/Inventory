﻿CREATE TABLE [Buy].[InLaneBuyVehicle] (
    [ID]                             INT             IDENTITY (1, 1) NOT NULL,
    [VIN]                            NVARCHAR (17)   NULL,
    [Year]                           INT             CONSTRAINT [DF_InLaneBuyVehicle_6DF371AD_B3C5_4C46_994E_F6EC1A79DB3E] DEFAULT ((0.0)) NULL,
    [Make]                           NVARCHAR (220)  NULL,
    [Model]                          NVARCHAR (220)  NULL,
    [Color]                          NVARCHAR (220)  NULL,
    [YMMC]                           NVARCHAR (220)  NULL,
    [SaleDate]                       DATE            NULL,
    [Auction]                        NVARCHAR (220)  NULL,
    [Lane]                           INT             CONSTRAINT [DF_InLaneBuyVehicle_311FBAE5_6449_44FD_93C8_5FA1335B3BC5] DEFAULT ((0.0)) NULL,
    [Run]                            INT             CONSTRAINT [DF_InLaneBuyVehicle_DF149AA3_5312_486D_9B01_1AEB9F72C5EA] DEFAULT ((0.0)) NULL,
    [Odometer]                       INT             CONSTRAINT [DF_InLaneBuyVehicle_2E2B2634_7C08_4EBA_9031_4F25C6F8F85B] DEFAULT ((0.0)) NULL,
    [Size]                           NVARCHAR (220)  NULL,
    [InspectionSurveyStart]          DATETIME2 (3)   NULL,
    [InspectionSurveyEnd]            DATE            NULL,
    [AuctionShort]                   AS              (replace([Auction],N'Manheim ',N'')) PERSISTED,
    [IsInspectionComplete]           INT             CONSTRAINT [DF_InLaneBuyVehicle_EAAE4199_58C8_4B5F_B8B8_4BA50D7FAF8E] DEFAULT ((0.0)) NULL,
    [IsInspectionFailed]             INT             CONSTRAINT [DF_InLaneBuyVehicle_0F3F9269_7856_45E2_8A89_961319BEE389] DEFAULT ((0.0)) NULL,
    [InspectorName]                  NVARCHAR (220)  NULL,
    [InspectorEmail]                 NVARCHAR (220)  NULL,
    [VehicleFound]                   NVARCHAR (220)  NULL,
    [Pass3FtInspection]              NVARCHAR (220)  NULL,
    [VehicleHasKeys]                 NVARCHAR (220)  NULL,
    [ReconFrontEnd]                  NVARCHAR (220)  NULL,
    [ReconRightSide]                 NVARCHAR (220)  NULL,
    [ReconRightSideTW]               NVARCHAR (220)  NULL,
    [ReconRearEnd]                   NVARCHAR (220)  NULL,
    [ReconLeftSide]                  NVARCHAR (220)  NULL,
    [ReconLeftSideTW]                NVARCHAR (220)  NULL,
    [ReconGlass]                     NVARCHAR (220)  NULL,
    [ReconRoof]                      NVARCHAR (220)  NULL,
    [ReconInterior]                  NVARCHAR (220)  NULL,
    [ReconTotal]                     INT             CONSTRAINT [DF_InLaneBuyVehicle_F33BC12E_E9B2_4581_991F_9259D6F2A456] DEFAULT ((0.0)) NULL,
    [NADAValue]                      DECIMAL (28, 6) CONSTRAINT [DF_InLaneBuyVehicle_05AE4E93_A900_4EBE_BF3D_4CA7354E0B04] DEFAULT ((0.0)) NULL,
    [StructuralMechanicalInspection] NVARCHAR (220)  NULL,
    [StructuralMechanicalFailReason] NVARCHAR (220)  NULL,
    [InspectionLatitude]             NVARCHAR (220)  NULL,
    [InspectionLongitude]            NVARCHAR (220)  NULL,
    [BuyerName]                      NVARCHAR (220)  NULL,
    [BuyerEmail]                     NVARCHAR (220)  NULL,
    [BuyerBucket]                    NVARCHAR (220)  NULL,
    [LastBid]                        INT             CONSTRAINT [DF_InLaneBuyVehicle_5926876C_DAA3_4792_B04F_01EF3CCFD852] DEFAULT ((0.0)) NULL,
    [RowLoadedDateTime]              DATETIME2 (3)   NULL,
    [BuyLatitude]                    DECIMAL (28, 6) CONSTRAINT [DF_InLaneBuyVehicle_F7D892E8_9084_4DFA_8556_7D7A9E4A830D] DEFAULT ((0.0)) NULL,
    [BuyLongitude]                   DECIMAL (28, 6) CONSTRAINT [DF_InLaneBuyVehicle_8809A274_6E4F_4A7A_AF69_27F7BA6520DC] DEFAULT ((0.0)) NULL,
    [IsBuyerPreferred]               INT             CONSTRAINT [DF_InLaneBuyVehicle_8AC7C31B_B961_4B98_BC5D_AF5D0CA9A434] DEFAULT ((0.0)) NULL,
    [IsBuyComplete]                  INT             CONSTRAINT [DF_InLaneBuyVehicle_D3E1BD26_44B4_44BB_9925_69312D79FFEA] DEFAULT ((0.0)) NULL,
    [IsLaneSelected]                 INT             CONSTRAINT [DF_InLaneBuyVehicle_D500E7F9_4754_441D_9CC6_DCB46DC21948] DEFAULT ((0.0)) NULL,
    [LaneSelectedBy]                 NVARCHAR (220)  NULL,
    CONSTRAINT [PK_InLaneBuyVehicle] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

