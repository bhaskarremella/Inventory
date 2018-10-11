CREATE TABLE [presale].[tblAuctionEdgeFeedVehicleMiscItem] (
    [AuctionEdgeFeedVehicleMiscItemID] BIGINT         IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]                DATETIME2 (7)  CONSTRAINT [DF_tblAuctionEdgeFeedVehicleMiscItem_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [BatchID]                          INT            NOT NULL,
    [VehicleID]                        BIGINT         NULL,
    [Type]                             VARCHAR (100)  NULL,
    [SecurityLevel]                    VARCHAR (50)   NULL,
    [Value]                            VARCHAR (1000) NULL,
    CONSTRAINT [PK_tblAuctionEdgeFeedVehicleMiscItem] PRIMARY KEY NONCLUSTERED ([AuctionEdgeFeedVehicleMiscItemID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE CLUSTERED INDEX [idx_tblAuctionEdgeFeedVehicleMiscItem_VehicleID_BatchID]
    ON [presale].[tblAuctionEdgeFeedVehicleMiscItem]([VehicleID] ASC, [BatchID] ASC) WITH (FILLFACTOR = 90);

