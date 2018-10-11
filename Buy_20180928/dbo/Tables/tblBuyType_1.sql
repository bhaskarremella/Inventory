CREATE TABLE [dbo].[tblBuyType] (
    [BuyTypeID]          BIGINT        IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]  DATETIME2 (7) CONSTRAINT [DF_tblBuyType_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime] DATETIME2 (7) NULL,
    [LastChangedByEmpID] VARCHAR (128) NULL,
    [BuyKey]             VARCHAR (50)  NULL,
    [BuyDescription]     VARCHAR (200) NULL,
    [IsActive]           TINYINT       CONSTRAINT [DF_tblBuyType_IsActive] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblBuyType_BuyTypeID] PRIMARY KEY CLUSTERED ([BuyTypeID] ASC) WITH (FILLFACTOR = 90)
);

