CREATE TABLE [dbo].[tblBuyAuctionInspectionCheckboxData] (
    [BuyAuctionInspectionCheckboxDataID] INT             IDENTITY (1, 1) NOT NULL,
    [VIN]                                VARCHAR (50)    NULL,
    [Category]                           NVARCHAR (100)  NULL,
    [Question]                           NVARCHAR (400)  NULL,
    [Answer]                             NVARCHAR (100)  NULL,
    [RepairEstimate]                     DECIMAL (20, 4) NULL,
    [SurveyCompletedBy]                  NVARCHAR (100)  NULL,
    [CheckboxSurveyStartDT]              DATETIME2 (3)   NULL,
    [CheckboxSurveyEndDT]                DATETIME2 (3)   NULL,
    [IsDeleted]                          BIT             CONSTRAINT [DF_tblBuyAuctionInspectionCheckboxData_IsDeleted] DEFAULT ((0)) NULL,
    [RowLoadedDateTime]                  DATETIME2 (3)   CONSTRAINT [DF_tblBuyAuctionInspectionCheckboxData_RowLoadedDateTime] DEFAULT (getdate()) NOT NULL,
    [RowUpdatedDateTime]                 DATETIME2 (3)   NULL,
    [ResponseID]                         BIGINT          NULL,
    [AnswerID]                           BIGINT          NULL,
    [CheckboxSurveyEndDate]              AS              (CONVERT([date],[CheckboxSurveyEndDT],(0))) PERSISTED,
    [InspectionTime]                     AS              (CONVERT([float],datediff(second,[CheckboxSurveyStartDT],[CheckboxSurveyEndDT]),(0))/(60)) PERSISTED,
    CONSTRAINT [PK_tblBuyAuctionInspectionCheckboxData] PRIMARY KEY CLUSTERED ([BuyAuctionInspectionCheckboxDataID] ASC) WITH (FILLFACTOR = 90)
);

