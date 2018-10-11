CREATE TABLE [dbo].[tblBuyInspectionFailReasonCategoryType] (
    [BuyInspectionFailReasonCategoryTypeID]      BIGINT        IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]                          DATETIME2 (7) CONSTRAINT [DF_tblBuyInspectionFailReasonCategoryType_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]                         DATETIME2 (7) NULL,
    [LastChangedByEmpID]                         VARCHAR (128) NULL,
    [BuyInspectionFailReasonCategoryKey]         VARCHAR (50)  NULL,
    [BuyInspectionFailReasonCategoryDescription] VARCHAR (200) NULL,
    [IsActive]                                   TINYINT       DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblBuyInspectionFailReasonCategiryType_BuyInspectionFailReasonCategoryTypeID] PRIMARY KEY CLUSTERED ([BuyInspectionFailReasonCategoryTypeID] ASC) WITH (FILLFACTOR = 90)
);

