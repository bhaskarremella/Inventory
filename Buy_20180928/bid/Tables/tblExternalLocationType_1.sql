CREATE TABLE [bid].[tblExternalLocationType] (
    [ExternalLocationTypeID]      BIGINT        IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]           DATETIME2 (7) CONSTRAINT [DF_ExternalLocationType_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]          DATETIME2 (7) NULL,
    [LastChangedByEmpID]          VARCHAR (128) NULL,
    [ExternalLocationKey]         VARCHAR (50)  NULL,
    [ExternalLocationDescription] VARCHAR (200) NULL,
    [IsActive]                    TINYINT       DEFAULT ((0)) NOT NULL,
    [CRLLT]                       INT           CONSTRAINT [DF_tblExternalLocationType_CRLLT] DEFAULT ((0)) NOT NULL,
    [SourcingRegion]              VARCHAR (50)  NULL,
    CONSTRAINT [PK_tblExternalLocationType_ExternalLocationTypeID] PRIMARY KEY CLUSTERED ([ExternalLocationTypeID] ASC) WITH (FILLFACTOR = 90)
);

