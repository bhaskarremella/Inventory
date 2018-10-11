CREATE TABLE [dbo].[tblJMeterTest] (
    [JMeterTestID]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]     DATETIME       CONSTRAINT [DF_tblJMeterTest_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowLoadedByEmpID]      VARCHAR (128)  CONSTRAINT [DF_tblJMeterTest_RowLoadedByEmpID] DEFAULT (suser_sname()) NOT NULL,
    [RowUpdatedDateTime]    DATETIME       CONSTRAINT [DF_tblJMeterTest_RowUpdatedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedByEmpID]     VARCHAR (128)  NOT NULL,
    [JMeterTestKey]         VARCHAR (50)   NOT NULL,
    [JMeterTestNumber]      INT            NOT NULL,
    [JMeterTestDescription] VARCHAR (1000) NOT NULL,
    [IsABitFlag1]           BIT            CONSTRAINT [DF_tblJMeterTest_IsABitFlag1] DEFAULT ((1)) NOT NULL,
    [IsABitFlag2]           BIT            CONSTRAINT [DF_tblJMeterTest_IsABitFlag2] DEFAULT ((0)) NOT NULL,
    [SomeNullableField]     VARCHAR (256)  NULL,
    CONSTRAINT [pk_JMeterTest] PRIMARY KEY CLUSTERED ([JMeterTestID] ASC) WITH (FILLFACTOR = 90)
);

