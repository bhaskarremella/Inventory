CREATE TABLE [dbo].[tblBuyDecode] (
    [BuyDecodeID]         BIGINT          IDENTITY (1, 1) NOT NULL,
    [BuyDecodeTypeID]     BIGINT          NOT NULL,
    [BuyVehicleID]        BIGINT          NOT NULL,
    [RowLoadedDateTime]   DATETIME2 (7)   CONSTRAINT [DF_tblBuyDecode_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]  DATETIME2 (7)   NULL,
    [LastChangedByEmpID]  VARCHAR (128)   NULL,
    [DecodeDateTime]      DATETIME2 (7)   NOT NULL,
    [DecodeAmount]        DECIMAL (10, 4) NULL,
    [DecodedBy]           VARCHAR (100)   NULL,
    [DecodedByEmail]      VARCHAR (100)   NULL,
    [DecodedByEmployeeID] VARCHAR (20)    NULL,
    [IsDeleted]           BIT             DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblBuyDecode_BuyDecodeID] PRIMARY KEY CLUSTERED ([BuyDecodeID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblBuyDecode_BuyDecodeTypeID] FOREIGN KEY ([BuyDecodeTypeID]) REFERENCES [dbo].[tblBuyDecodeType] ([BuyDecodeTypeID]),
    CONSTRAINT [FK_tblBuyDecode_BuyVehicleID] FOREIGN KEY ([BuyVehicleID]) REFERENCES [dbo].[tblBuyVehicle] ([BuyVehicleID])
);

