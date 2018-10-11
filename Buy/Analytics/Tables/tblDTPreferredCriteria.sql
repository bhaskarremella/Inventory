CREATE TABLE [Analytics].[tblDTPreferredCriteria] (
    [DTPreferredCriteriaID] INT           IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]     DATETIME2 (7) CONSTRAINT [DF_tblDTPreferredCriteria_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]    DATETIME2 (7) NULL,
    [LastChangedByEmpID]    VARCHAR (128) NULL,
    [Question]              VARCHAR (400) NULL,
    [Category]              VARCHAR (100) NOT NULL,
    [Answer]                VARCHAR (100) NOT NULL,
    [DTPreferred]           INT           NOT NULL,
    [IsDeleted]             INT           NOT NULL,
    [StartDate]             DATETIME2 (3) NULL,
    [EndDate]               DATETIME2 (3) NULL,
    CONSTRAINT [PK_tblDTPreferredCriteria_DTPreferredCriteriaID] PRIMARY KEY CLUSTERED ([DTPreferredCriteriaID] ASC) WITH (FILLFACTOR = 90)
);

