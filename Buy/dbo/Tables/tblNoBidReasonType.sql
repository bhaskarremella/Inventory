CREATE TABLE [dbo].[tblNoBidReasonType] (
    [NoBidReasonTypeID]      BIGINT        NOT NULL,
    [RowLoadedDateTime]      DATETIME2 (7) CONSTRAINT [DF_tblNoBidReason_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]     DATETIME2 (7) NULL,
    [LastChangedByEmpID]     VARCHAR (20)  NULL,
    [NoBidReasonKey]         VARCHAR (50)  NULL,
    [NoBidReasonDescription] VARCHAR (200) NULL,
    [IsPreSaleReason]        BIT           CONSTRAINT [DF_tblNoBidReason_IsPreSaleReason] DEFAULT ((0)) NOT NULL,
    [IsPostSaleReason]       BIT           CONSTRAINT [DF_NoBidReason_IsPostSaleReason] DEFAULT ((0)) NOT NULL,
    [IsActive]               BIT           CONSTRAINT [DF_tblNoBidReason_IsActive] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblNoBidReason_NoBidReasonTypeID] PRIMARY KEY CLUSTERED ([NoBidReasonTypeID] ASC) WITH (FILLFACTOR = 90)
);

