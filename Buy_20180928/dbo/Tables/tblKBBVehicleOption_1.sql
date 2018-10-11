CREATE TABLE [dbo].[tblKBBVehicleOption] (
    [KBBVehicleOptionID]  BIGINT          IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]   DATETIME2 (3)   CONSTRAINT [DF_tblKBBVehicleOption_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]  DATETIME2 (3)   NULL,
    [KBBVehicleID]        BIGINT          NOT NULL,
    [OptionName]          VARCHAR (200)   NULL,
    [OptionID]            INT             NULL,
    [RetailOptionAdj]     DECIMAL (10, 4) NULL,
    [RetailOptionAdjType] VARCHAR (100)   NULL,
    [FPPOptionAdj]        DECIMAL (10, 4) NULL,
    [FPPOptionAdjType]    VARCHAR (100)   NULL,
    [IsOptionStandard]    TINYINT         NULL,
    CONSTRAINT [PK_tblKBBVehicleOption] PRIMARY KEY CLUSTERED ([KBBVehicleOptionID] ASC) WITH (FILLFACTOR = 90)
);

