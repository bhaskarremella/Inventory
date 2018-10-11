CREATE TABLE [Audit].[tblAccuCheckHistory] (
    [AccuCheckHistoryID]           INT           NOT NULL,
    [RowLoadedDateTime]            DATETIME2 (3) NOT NULL,
    [RowUpdatedDateTime]           DATETIME2 (3) NOT NULL,
    [AccuCheckID]                  INT           NOT NULL,
    [AccidentSeqNum]               INT           NULL,
    [ActCode]                      INT           NOT NULL,
    [Case]                         VARCHAR (200) NULL,
    [Type]                         VARCHAR (200) NOT NULL,
    [Date]                         DATETIME2 (3) NULL,
    [Category]                     VARCHAR (200) NOT NULL,
    [CheckListGrp]                 INT           NOT NULL,
    [Odometer]                     INT           NULL,
    [OriginalIncidentReportedDate] DATETIME2 (3) NULL,
    [ORU]                          VARCHAR (1)   NULL,
    [City]                         VARCHAR (200) NULL,
    [UOM]                          VARCHAR (1)   NULL,
    [State]                        VARCHAR (20)  NULL,
    [FileID]                       INT           NULL,
    [FileSource]                   VARCHAR (200) NULL,
    [FileType]                     VARCHAR (200) NULL,
    [Title]                        VARCHAR (200) NULL,
    [Lease]                        TINYINT       NULL,
    [Lien]                         TINYINT       NULL,
    [TitleRegStorm]                TINYINT       NULL,
    [Color]                        VARCHAR (200) NULL,
    [URL]                          VARCHAR (200) NULL,
    [URLLink]                      TINYINT       NULL,
    [RecallCode]                   VARCHAR (200) NULL,
    [RecallTxt]                    VARCHAR (MAX) NULL,
    [RecallLinkTxt]                VARCHAR (MAX) NULL,
    [RecallURL]                    VARCHAR (MAX) NULL,
    [OrgName]                      VARCHAR (200) NULL,
    [Phone]                        VARCHAR (30)  NULL,
    [ValidFromDate]                DATETIME2 (7) NOT NULL,
    [ValidToDate]                  DATETIME2 (7) NOT NULL
);


GO
CREATE CLUSTERED INDEX [ix_tblAccuCheckHistory]
    ON [Audit].[tblAccuCheckHistory]([ValidToDate] ASC, [ValidFromDate] ASC) WITH (DATA_COMPRESSION = PAGE);

