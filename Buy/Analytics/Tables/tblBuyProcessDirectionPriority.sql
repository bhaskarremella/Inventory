CREATE TABLE [Analytics].[tblBuyProcessDirectionPriority] (
    [BuyProcessDirectionPriorityID] INT           IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]             DATETIME2 (7) CONSTRAINT [DF_tblBuyProcessDirectionPriority_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]            DATETIME2 (7) NULL,
    [LastChangedByEmpID]            VARCHAR (128) NULL,
    [LookUp]                        VARCHAR (250) NULL,
    [CostPriority]                  INT           NULL,
    [MileagePriority]               INT           NULL,
    CONSTRAINT [PK_tblBuyProcessDirectionPriority_BuyProcessDirectionPriorityID] PRIMARY KEY CLUSTERED ([BuyProcessDirectionPriorityID] ASC) WITH (FILLFACTOR = 90)
);

