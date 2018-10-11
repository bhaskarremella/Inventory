CREATE TABLE [dbo].[tblBuyAuctionDecode] (
    [BuyAuctionDecodeID]  BIGINT          IDENTITY (1, 1) NOT NULL,
    [BuyDecodeTypeID]     BIGINT          NOT NULL,
    [BuyAuctionVehicleID] BIGINT          NOT NULL,
    [RowLoadedDateTime]   DATETIME2 (7)   CONSTRAINT [DF_tblBuyAuctionDecode_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]  DATETIME2 (7)   NULL,
    [LastChangedByEmpID]  VARCHAR (128)   NULL,
    [DecodeDateTime]      DATETIME2 (7)   NOT NULL,
    [DecodeAmount]        DECIMAL (10, 4) NULL,
    [DecodedBy]           VARCHAR (100)   NULL,
    [DecodedByEmail]      VARCHAR (100)   NULL,
    [DecodedByEmployeeID] VARCHAR (20)    NULL,
    [IsDeleted]           BIT             DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblBuyAuctionDecode_BuyAuctionDecodeID] PRIMARY KEY CLUSTERED ([BuyAuctionDecodeID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblBuyAuctionDecode_BuyAuctionVehicleID] FOREIGN KEY ([BuyAuctionVehicleID]) REFERENCES [dbo].[tblBuyAuctionVehicle] ([BuyAuctionVehicleID]),
    CONSTRAINT [FK_tblBuyAuctionDecode_BuyDecodeTypeID] FOREIGN KEY ([BuyDecodeTypeID]) REFERENCES [dbo].[tblBuyDecodeType] ([BuyDecodeTypeID])
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblBuyAuctionDecode_BuyAuctionVehicleID]
    ON [dbo].[tblBuyAuctionDecode]([BuyAuctionVehicleID] ASC) WITH (FILLFACTOR = 90);

