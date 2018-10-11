CREATE TABLE [Analytics].[tblManheimVendorConversion] (
    [ManheimVendorConversionID] INT           IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]         DATETIME2 (7) CONSTRAINT [DF_tblManheimVendorConversion_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]        DATETIME2 (7) NULL,
    [LastChangedByEmpID]        VARCHAR (128) NULL,
    [ManheimID]                 VARCHAR (250) NULL,
    [DTVendorID]                VARCHAR (250) NULL,
    [AuctionName]               VARCHAR (250) NULL,
    CONSTRAINT [PK_tblManheimVendorConversion_ManheimVendorConversionID] PRIMARY KEY CLUSTERED ([ManheimVendorConversionID] ASC) WITH (FILLFACTOR = 90)
);

