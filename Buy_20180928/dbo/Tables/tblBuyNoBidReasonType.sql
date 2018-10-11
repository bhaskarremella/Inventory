CREATE TABLE [dbo].[tblBuyNoBidReasonType] (
    [BuyNoBidReasonTypeID]      BIGINT        IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]         DATETIME2 (7) CONSTRAINT [DF_tblBuyNoBidReasonType_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]        DATETIME2 (7) NULL,
    [LastChangedByEmpID]        VARCHAR (128) NULL,
    [BuyNoBidReasonKey]         VARCHAR (50)  NULL,
    [BuyNoBidReasonDescription] VARCHAR (200) NULL,
    [IsPreSaleReason]           BIT           CONSTRAINT [DF_tblBuyNoBidReasonType_IsPreSaleReason] DEFAULT ((0)) NOT NULL,
    [IsPostSaleReason]          BIT           CONSTRAINT [DF_tblBuyNoBidReasonType_IsPostSaleReason] DEFAULT ((0)) NOT NULL,
    [IsActive]                  TINYINT       CONSTRAINT [DF_tblBuyNoBidReasonType_IsActive] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblBuyNoBidReasonType_BuyNoBidReasonTypeID] PRIMARY KEY CLUSTERED ([BuyNoBidReasonTypeID] ASC) WITH (FILLFACTOR = 90)
);

