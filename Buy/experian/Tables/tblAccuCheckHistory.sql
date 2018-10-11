CREATE TABLE [experian].[tblAccuCheckHistory] (
    [AccuCheckHistoryID]           INT                                                IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [RowLoadedDateTime]            DATETIME2 (3)                                      CONSTRAINT [DF_tblAccuCheckHistory_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]           DATETIME2 (3)                                      CONSTRAINT [DF_tblAccuCheckHistory_RowUpdatedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [AccuCheckID]                  INT                                                NOT NULL,
    [AccidentSeqNum]               INT                                                NULL,
    [ActCode]                      INT                                                NOT NULL,
    [Case]                         VARCHAR (200)                                      NULL,
    [Type]                         VARCHAR (200)                                      NOT NULL,
    [Date]                         DATETIME2 (3)                                      NULL,
    [Category]                     VARCHAR (200)                                      NOT NULL,
    [CheckListGrp]                 INT                                                NOT NULL,
    [Odometer]                     INT                                                NULL,
    [OriginalIncidentReportedDate] DATETIME2 (3)                                      NULL,
    [ORU]                          VARCHAR (1)                                        NULL,
    [City]                         VARCHAR (200)                                      NULL,
    [UOM]                          VARCHAR (1)                                        NULL,
    [State]                        VARCHAR (20)                                       NULL,
    [FileID]                       INT                                                NULL,
    [FileSource]                   VARCHAR (200)                                      NULL,
    [FileType]                     VARCHAR (200)                                      NULL,
    [Title]                        VARCHAR (200)                                      NULL,
    [Lease]                        TINYINT                                            NULL,
    [Lien]                         TINYINT                                            NULL,
    [TitleRegStorm]                TINYINT                                            NULL,
    [Color]                        VARCHAR (200)                                      NULL,
    [URL]                          VARCHAR (200)                                      NULL,
    [URLLink]                      TINYINT                                            NULL,
    [RecallCode]                   VARCHAR (200)                                      NULL,
    [RecallTxt]                    VARCHAR (MAX)                                      NULL,
    [RecallLinkTxt]                VARCHAR (MAX)                                      NULL,
    [RecallURL]                    VARCHAR (MAX)                                      NULL,
    [OrgName]                      VARCHAR (200)                                      NULL,
    [Phone]                        VARCHAR (30)                                       NULL,
    [ValidFromDate]                DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_tblAccuCheckHistory_ValidFromDate] DEFAULT (sysdatetime()) NOT NULL,
    [ValidToDate]                  DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_tblAccuCheckHistory_ValidToDate] DEFAULT (sysdatetime()) NOT NULL,
    CONSTRAINT [PK_tblAccuCheckHistory] PRIMARY KEY CLUSTERED ([AccuCheckHistoryID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblAccuCheckHistory_AccuCheckID] FOREIGN KEY ([AccuCheckID]) REFERENCES [experian].[tblAccuCheck] ([AccuCheckID]),
    PERIOD FOR SYSTEM_TIME ([ValidFromDate], [ValidToDate])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Audit].[tblAccuCheckHistory], DATA_CONSISTENCY_CHECK=ON));


GO
CREATE NONCLUSTERED INDEX [IDX_tblAccuCheckHistory_AccuCheckID]
    ON [experian].[tblAccuCheckHistory]([AccuCheckID] ASC) WITH (FILLFACTOR = 90);

