CREATE TABLE [dbo].[tblBuyInspectionType] (
    [BuyInspectionTypeID]      BIGINT        IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]        DATETIME2 (7) CONSTRAINT [DF_tblBuyInspectionType_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]       DATETIME2 (7) NULL,
    [LastChangedByEmpID]       VARCHAR (128) NULL,
    [BuyInspectionKey]         VARCHAR (50)  NULL,
    [BuyInspectionDescription] VARCHAR (200) NULL,
    [IsActive]                 TINYINT       DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblBuyInspectionType_BuyInspectionTypeID] PRIMARY KEY CLUSTERED ([BuyInspectionTypeID] ASC) WITH (FILLFACTOR = 90)
);

