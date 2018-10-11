CREATE TABLE [dbo].[tblMMRVehicleDescription] (
    [MMR_MID]              VARCHAR (35) NOT NULL,
    [Year]                 INT          NULL,
    [Make]                 VARCHAR (50) NULL,
    [Model]                VARCHAR (50) NULL,
    [BodyStyle]            VARCHAR (50) NULL,
    [Trim]                 VARCHAR (50) NULL,
    [CommonModel]          VARCHAR (50) NULL,
    [MakeID]               INT          NULL,
    [ModelID]              INT          NULL,
    [BodyStyleID]          INT          NULL,
    [VehicleCategory]      VARCHAR (50) NULL,
    [Size]                 VARCHAR (50) NULL,
    [Nationality]          VARCHAR (50) NULL,
    [TopThreeAmericanName] VARCHAR (50) NULL,
    [DateAdded]            DATETIME     CONSTRAINT [DF_tblMMRVehicleDescription_DateAdded] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_tblMMRVehicleDescription_ForProd] PRIMARY KEY CLUSTERED ([MMR_MID] ASC) WITH (FILLFACTOR = 90)
);

