CREATE TABLE [presale].[tblAdesaPreSale] (
    [pkAdesaPreSaleID]       INT            IDENTITY (1, 1) NOT NULL,
    [SaleDate]               VARCHAR (10)   NULL,
    [SaleType]               VARCHAR (50)   NULL,
    [OwnerID]                INT            NULL,
    [ConsignorType]          VARCHAR (50)   NULL,
    [Consignor]              VARCHAR (50)   NULL,
    [Location]               VARCHAR (150)  NULL,
    [Lot]                    VARCHAR (10)   NULL,
    [RunNumber]              INT            NULL,
    [Year]                   INT            NULL,
    [Make]                   VARCHAR (30)   NULL,
    [Model]                  VARCHAR (30)   NULL,
    [Body]                   VARCHAR (50)   NULL,
    [Series]                 VARCHAR (30)   NULL,
    [Engine]                 VARCHAR (30)   NULL,
    [Color]                  VARCHAR (250)  NULL,
    [Odometer]               INT            NULL,
    [OdometerType]           VARCHAR (10)   NULL,
    [VIN]                    VARCHAR (17)   NULL,
    [FrameDamageIndicator]   VARCHAR (5)    NULL,
    [Transmission]           VARCHAR (100)  NULL,
    [Options]                VARCHAR (5000) NULL,
    [Announcement]           VARCHAR (4000) NULL,
    [RowLoadTimeStamp]       DATETIME       CONSTRAINT [DF_tblAdesaPreSale_RowLoadTimeStamp] DEFAULT (getdate()) NULL,
    [RowUpdateTimeStamp]     DATETIME       NULL,
    [OpenLaneVehicleID]      INT            NULL,
    [Status]                 VARCHAR (20)   NULL,
    [Displacement]           VARCHAR (30)   NULL,
    [Cylinders]              INT            NULL,
    [DriveTrain]             VARCHAR (32)   NULL,
    [ChromeStyleID]          BIGINT         NULL,
    [InteriorColor]          VARCHAR (250)  NULL,
    [VehicleType]            VARCHAR (64)   NULL,
    [State]                  VARCHAR (5)    NULL,
    [ZipCode]                VARCHAR (10)   NULL,
    [CurrentHighBid]         BIGINT         NULL,
    [BINPrice]               BIGINT         NULL,
    [AuctionEndDateTime]     VARCHAR (20)   NULL,
    [TotalDamages]           INT            NULL,
    [VehicleDetailURL]       VARCHAR (1000) NULL,
    [ImageViewerURL]         VARCHAR (1000) NULL,
    [DealerCodes]            INT            NULL,
    [ImageURL]               VARCHAR (1000) NULL,
    [Lane]                   VARCHAR (10)   NULL,
    [IsRunListVehicle]       VARCHAR (30)   NULL,
    [IsLiveBlockVehicle]     VARCHAR (30)   NULL,
    [IsDealerBlockVehicle]   VARCHAR (30)   NULL,
    [AssetType]              VARCHAR (30)   NULL,
    [EqualsReserve]          VARCHAR (5)    NULL,
    [VehicleListingCategory] VARCHAR (80)   NULL,
    [VehicleGrade]           VARCHAR (10)   NULL,
    [ProcessingAuctionOrgID] INT            NULL,
    [IsAutograde]            VARCHAR (5)    NULL,
    [Comment]                VARCHAR (30)   NULL,
    [ChromeYear]             INT            NULL,
    [ChromeMake]             VARCHAR (30)   NULL,
    [ChromeModel]            VARCHAR (30)   NULL,
    [ChromeSeries]           VARCHAR (50)   NULL,
    [TitleState]             VARCHAR (5)    NULL,
    [Tires]                  VARCHAR (500)  NULL,
    [InspectionDate]         VARCHAR (10)   NULL,
    [InspectionCompany]      VARCHAR (50)   NULL,
    [InspectionComments]     VARCHAR (1000) NULL,
    [PriorPaint]             VARCHAR (10)   NULL,
    [Reserved1]              VARCHAR (50)   NULL,
    [Reserved2]              VARCHAR (50)   NULL,
    [InTransitIndicator]     VARCHAR (50)   NULL,
    [AdesaAssurance]         VARCHAR (50)   NULL,
    CONSTRAINT [PK_tblAdesaPreSale] PRIMARY KEY CLUSTERED ([pkAdesaPreSaleID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [idxtblAdesaPreSale_SaleDate_Year_Odometer_INCL]
    ON [presale].[tblAdesaPreSale]([SaleDate] ASC, [Year] ASC, [Odometer] ASC)
    INCLUDE([Announcement], [Consignor], [Location], [Lot], [Make], [Model], [RowLoadTimeStamp], [RunNumber], [VIN]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idxtblAdesaPreSale_Status_INCL]
    ON [presale].[tblAdesaPreSale]([Status] ASC)
    INCLUDE([Announcement], [Color], [Consignor], [Location], [Lot], [Make], [Model], [Odometer], [RowLoadTimeStamp], [RunNumber], [SaleDate], [SaleType], [VIN], [Year]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idx_tblAdesaPresale_VIN]
    ON [presale].[tblAdesaPreSale]([VIN] ASC) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Column decommissioned by Adesa 25-Jan-2016 and represented their internal ID of the Consignor', @level0type = N'SCHEMA', @level0name = N'presale', @level1type = N'TABLE', @level1name = N'tblAdesaPreSale', @level2type = N'COLUMN', @level2name = N'OwnerID';

