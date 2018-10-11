﻿CREATE TABLE [presale].[tblManheimFeed] (
    [ListingID]                UNIQUEIDENTIFIER NOT NULL,
    [RowLoadedDateTime]        DATETIME2 (7)    CONSTRAINT [DF_tblManheimFeed_RowLoadedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [RowUpdatedDateTime]       SMALLDATETIME    NULL,
    [RowLoadedDate]            AS               (CONVERT([date],dateadd(hour,(-7),[RowLoadedDateTime]),(0))) PERSISTED NOT NULL,
    [EventType]                VARCHAR (25)     NOT NULL,
    [SaleDate]                 DATE             NULL,
    [SaleYear]                 SMALLINT         NULL,
    [AuctionStartDate]         DATETIME2 (7)    NULL,
    [AuctionEndDate]           DATETIME2 (7)    NULL,
    [AuctionID]                VARCHAR (4)      NULL,
    [AuctionLocation]          VARCHAR (40)     NULL,
    [Channel]                  VARCHAR (100)    NULL,
    [DealerGroup]              VARCHAR (4)      NULL,
    [GroupCode]                VARCHAR (15)     NULL,
    [UniqueID]                 VARCHAR (64)     NULL,
    [LaneNumber]               TINYINT          NULL,
    [SaleNumber]               TINYINT          NULL,
    [AsIs]                     TINYINT          NULL,
    [DoorCount]                TINYINT          NULL,
    [FrameDamage]              TINYINT          NULL,
    [HasAirConditioning]       TINYINT          NULL,
    [OffsiteFlag]              TINYINT          NULL,
    [PriorPaint]               TINYINT          NULL,
    [Salvage]                  TINYINT          NULL,
    [IsDeleted]                TINYINT          NULL,
    [VIN]                      VARCHAR (17)     NULL,
    [VinPrefix]                VARCHAR (8)      NULL,
    [Year]                     SMALLINT         NULL,
    [Make]                     VARCHAR (50)     NULL,
    [Model]                    VARCHAR (100)    NULL,
    [Trim]                     VARCHAR (65)     NULL,
    [BodyStyle]                VARCHAR (16)     NULL,
    [ExteriorColor]            VARCHAR (15)     NULL,
    [Mileage]                  INT              NULL,
    [Drivetrain]               VARCHAR (20)     NULL,
    [Transmission]             VARCHAR (9)      NULL,
    [Engine]                   VARCHAR (50)     NULL,
    [FuelType]                 VARCHAR (10)     NULL,
    [Airbags]                  VARCHAR (11)     NULL,
    [InteriorColor]            VARCHAR (15)     NULL,
    [InteriorType]             VARCHAR (20)     NULL,
    [Roof]                     VARCHAR (40)     NULL,
    [EcrGrade]                 VARCHAR (20)     NULL,
    [ConditionGradeNumDecimal] NUMERIC (3, 1)   NULL,
    [LocationZip]              VARCHAR (15)     NULL,
    [LotID]                    VARCHAR (100)    NULL,
    [Mid]                      VARCHAR (16)     NULL,
    [PickupLocation]           VARCHAR (60)     NULL,
    [TypeCode]                 VARCHAR (20)     NULL,
    [YearCharacter]            CHAR (1)         NULL,
    [Options]                  VARCHAR (4000)   NULL,
    [Seller]                   VARCHAR (200)    NULL,
    [TitleState]               VARCHAR (20)     NULL,
    [TitleStatus]              VARCHAR (40)     NULL,
    [CurrentBidPrice]          MONEY            NULL,
    [BuyNowPrice]              MONEY            NULL,
    [RunNumber]                SMALLINT         NULL,
    [BuyerGroupID]             SMALLINT         NULL,
    [VehicleSaleURL]           VARCHAR (1000)   NULL,
    [CrURL]                    VARCHAR (1000)   NULL,
    [MobileCrURL]              VARCHAR (1000)   NULL,
    [EcrURL]                   VARCHAR (1000)   NULL,
    [SdURL]                    VARCHAR (1000)   NULL,
    [MobileSdURL]              VARCHAR (1000)   NULL,
    [MobileVdpURL]             VARCHAR (1000)   NULL,
    [VdpURL]                   VARCHAR (1000)   NULL,
    [Comments]                 VARCHAR (8000)   NULL,
    [IsDecoded]                TINYINT          CONSTRAINT [DF_tblManheimFeed_IsDecoded] DEFAULT ((0)) NULL,
    [Region]                   VARCHAR (50)     NULL,
    [Announcements]            VARCHAR (8000)   NULL,
    [AuctionComments]          VARCHAR (8000)   NULL,
    [Remarks]                  VARCHAR (8000)   NULL,
    [PickupLocationState]      VARCHAR (20)     NULL,
    [PickupLocationZip]        VARCHAR (15)     NULL,
    CONSTRAINT [PK_tblManheimFeed] PRIMARY KEY CLUSTERED ([ListingID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblManheimFeed_Channel_VIN_IsDeleted]
    ON [presale].[tblManheimFeed]([Channel] ASC, [VIN] ASC, [IsDeleted] ASC)
    INCLUDE([ListingID]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IDX_tblManheimFeed_IsDeleted_MID]
    ON [presale].[tblManheimFeed]([IsDeleted] ASC, [Mid] ASC)
    INCLUDE([RowLoadedDateTime], [RowUpdatedDateTime], [VIN]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IDX_tblManheimFeed_IsDeleted_SaleDate_Year_WithIncludes]
    ON [presale].[tblManheimFeed]([IsDeleted] ASC, [SaleDate] ASC, [Year] ASC)
    INCLUDE([VIN], [Make], [Model], [BodyStyle], [Mileage], [Mid], [IsDecoded]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IDX_tblManheimFeed_VIN_SaleDate]
    ON [presale].[tblManheimFeed]([VIN] ASC, [SaleDate] ASC) WITH (FILLFACTOR = 90);

