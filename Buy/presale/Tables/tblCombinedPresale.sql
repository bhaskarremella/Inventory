CREATE TABLE [presale].[tblCombinedPresale] (
    [CombinedPresaleID]        BIGINT         IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]        DATETIME2 (7)  CONSTRAINT [DF_tblCombinedPresale_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]       DATETIME2 (7)  NULL,
    [LastChangedByEmpID]       VARCHAR (128)  NULL,
    [PresaleRowLoadedDateTime] DATETIME2 (7)  NULL,
    [BuyAuctionHouseTypeID]    BIGINT         NULL,
    [AuctionID]                VARCHAR (50)   NULL,
    [AuctionName]              VARCHAR (200)  NULL,
    [AuctionEndDateTime]       DATETIME2 (3)  NULL,
    [VIN]                      VARCHAR (17)   NOT NULL,
    [SaleDate]                 DATE           NULL,
    [MMRMID]                   VARCHAR (16)   NULL,
    [MMRValue]                 BIGINT         NULL,
    [Channel]                  VARCHAR (50)   NULL,
    [CRScore]                  VARCHAR (10)   NULL,
    [Year]                     SMALLINT       NULL,
    [Make]                     VARCHAR (50)   NULL,
    [Model]                    VARCHAR (100)  NULL,
    [ExteriorColor]            VARCHAR (250)  NULL,
    [Mileage]                  INT            NULL,
    [Engine]                   VARCHAR (50)   NULL,
    [Transmission]             VARCHAR (100)  NULL,
    [Announcements]            VARCHAR (4000) NULL,
    [VehicleDetailURL]         VARCHAR (1000) NULL,
    [CRLink]                   VARCHAR (1000) NULL,
    [AsIs]                     TINYINT        NULL,
    [LaneNumber]               VARCHAR (50)   NULL,
    [RunNumber]                VARCHAR (50)   NULL,
    [Seller]                   VARCHAR (200)  NULL,
    [IsDecommissioned]         TINYINT        NULL,
    [IsDecommissionedDateTime] DATETIME2 (7)  NULL,
    [YearsOld]                 SMALLINT       NULL,
    CONSTRAINT [PK_tblCombinedPresale] PRIMARY KEY CLUSTERED ([CombinedPresaleID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [PK_tblCombinedPresale_House_AuctionID_VIN_SaleDate_Channel] UNIQUE NONCLUSTERED ([PresaleRowLoadedDateTime] ASC, [BuyAuctionHouseTypeID] ASC, [AuctionID] ASC, [VIN] ASC, [SaleDate] ASC, [Channel] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblCombinedPresale_AuctionEndTime]
    ON [presale].[tblCombinedPresale]([AuctionEndDateTime] ASC) WITH (FILLFACTOR = 90);

