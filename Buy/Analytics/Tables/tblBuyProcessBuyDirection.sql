CREATE TABLE [Analytics].[tblBuyProcessBuyDirection] (
    [BuyProcessBuyDirectionID] INT           IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]        DATETIME2 (7) CONSTRAINT [DF_tblBuyProcessBuyDirection_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]       DATETIME2 (7) NULL,
    [LastChangedByEmpID]       VARCHAR (128) NULL,
    [Size]                     VARCHAR (250) NULL,
    [Make]                     VARCHAR (250) NULL,
    [CommonModel]              VARCHAR (250) NULL,
    [BeginYear]                SMALLINT      NULL,
    [EndYear]                  SMALLINT      NULL,
    [MinPrice]                 INT           NULL,
    [MaxPrice]                 INT           NULL,
    [MaxAboveBook]             INT           NULL,
    [MinMileage]               INT           NULL,
    [MaxMileage]               INT           NULL,
    [NoBuy]                    TINYINT       NULL,
    [ProductType]              TINYINT       NULL,
    CONSTRAINT [PK_tblBuyProcessBuyDirection_BuyProcessBuyDirectionID] PRIMARY KEY CLUSTERED ([BuyProcessBuyDirectionID] ASC) WITH (FILLFACTOR = 90)
);

