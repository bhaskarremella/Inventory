CREATE TABLE [dbo].[tblBuyDecodeType] (
    [BuyDecodeTypeID]      BIGINT        IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]    DATETIME2 (7) CONSTRAINT [DF_tblBuyDecodeType_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]   DATETIME2 (7) NULL,
    [LastChangedByEmpID]   VARCHAR (128) NULL,
    [BuyDecodeKey]         VARCHAR (50)  NULL,
    [BuyDecodeDescription] VARCHAR (200) NULL,
    [IsActive]             TINYINT       DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblBuyDecodeType_BuyDecodeTypeID] PRIMARY KEY CLUSTERED ([BuyDecodeTypeID] ASC) WITH (FILLFACTOR = 90)
);

