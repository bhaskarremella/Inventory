CREATE TABLE [dbo].[tblBuyInspectionFailReasonType] (
    [BuyInspectionFailReasonTypeID]         BIGINT        IDENTITY (1, 1) NOT NULL,
    [BuyInspectionFailReasonCategoryTypeID] BIGINT        NOT NULL,
    [RowLoadedDateTime]                     DATETIME2 (7) CONSTRAINT [DF_tblBuyInspectionFailReasonType_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]                    DATETIME2 (7) NULL,
    [LastChangedByEmpID]                    VARCHAR (128) NULL,
    [BuyInspectionFailReasonKey]            VARCHAR (50)  NULL,
    [BuyInspectionFailReasonDescription]    VARCHAR (200) NULL,
    [IsActive]                              TINYINT       DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblBuyInspectionFailReasonType_BuyInspectionFailReasonTypeID] PRIMARY KEY CLUSTERED ([BuyInspectionFailReasonTypeID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblBuyInspectionFailReasonType_tblBuyInspectionFailReasonCategoryTypeID] FOREIGN KEY ([BuyInspectionFailReasonCategoryTypeID]) REFERENCES [dbo].[tblBuyInspectionFailReasonCategoryType] ([BuyInspectionFailReasonCategoryTypeID])
);

