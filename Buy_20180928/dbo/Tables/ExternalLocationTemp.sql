CREATE TABLE [dbo].[ExternalLocationTemp] (
    [ExternalLocationTypeID]      BIGINT        NULL,
    [RowLoadedDateTime]           DATETIME2 (7) NULL,
    [RowUpdatedDateTime]          DATETIME2 (7) NULL,
    [LastChangedByEmpID]          VARCHAR (128) NULL,
    [ExternalLocationKey]         VARCHAR (50)  NULL,
    [ExternalLocationDescription] VARCHAR (200) NULL,
    [IsActive]                    TINYINT       NULL,
    [CRLLT]                       INT           NULL,
    [SourcingRegion]              VARCHAR (50)  NULL
);

