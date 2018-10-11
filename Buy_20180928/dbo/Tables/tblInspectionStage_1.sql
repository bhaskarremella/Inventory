CREATE TABLE [dbo].[tblInspectionStage] (
    [InspectionStageID]                  BIGINT          IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]                  DATETIME2 (7)   CONSTRAINT [DF_tblInspectionStage_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]                 DATETIME2 (7)   NULL,
    [LastChangedByEmpID]                 VARCHAR (128)   NULL,
    [VIN]                                VARCHAR (17)    NULL,
    [AuctionName]                        VARCHAR (100)   NULL,
    [SaleDate]                           DATE            NULL,
    [Lane]                               VARCHAR (50)    NULL,
    [Run]                                VARCHAR (50)    NULL,
    [Year]                               SMALLINT        NULL,
    [Make]                               VARCHAR (100)   NULL,
    [Model]                              VARCHAR (100)   NULL,
    [Color]                              VARCHAR (50)    NULL,
    [Odometer]                           INT             NULL,
    [Size]                               VARCHAR (50)    NULL,
    [SellerName]                         VARCHAR (220)   NULL,
    [Announcement]                       VARCHAR (250)   NULL,
    [IsDecommissionedInspection]         BIT             CONSTRAINT [DF_tblInspectionStage_IsDecommissionedInspection] DEFAULT ((0)) NOT NULL,
    [IsDecommissionedInspectionDateTime] DATETIME2 (7)   NULL,
    [DTValue]                            DECIMAL (20, 4) NULL,
    [InspectionBucket]                   VARCHAR (100)   NULL,
    [InspectionSurveyStartDT]            DATETIME2 (3)   NULL,
    [InspectionSurveyEndDT]              DATETIME2 (3)   NULL,
    [IsAccuCheckIssue]                   TINYINT         CONSTRAINT [DF_tblInspectionStage_IsAccuCheckIssue] DEFAULT ((0)) NULL,
    [IsAccuCheckIssueDateTime]           DATETIME2 (7)   NULL
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblInspectionStage_AuctionName_Includes]
    ON [dbo].[tblInspectionStage]([AuctionName] ASC)
    INCLUDE([VIN], [SaleDate], [Lane], [Run], [Odometer], [SellerName], [Announcement], [IsDecommissionedInspection], [IsDecommissionedInspectionDateTime], [IsAccuCheckIssue], [IsAccuCheckIssueDateTime]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IDX_tblInspectionStage_VIN_Includes]
    ON [dbo].[tblInspectionStage]([VIN] ASC)
    INCLUDE([Year], [Make], [Model], [Color], [Size]) WITH (FILLFACTOR = 90);

