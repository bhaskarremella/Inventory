CREATE TABLE [dbo].[tblBuyAuctionInspectionCheckboxDataStage] (
    [BuyAuctionInspectionCheckboxDataStageID] INT             IDENTITY (1, 1) NOT NULL,
    [VIN]                                     VARCHAR (50)    NULL,
    [Category]                                NVARCHAR (100)  NULL,
    [Question]                                NVARCHAR (400)  NULL,
    [Answer]                                  NVARCHAR (100)  NULL,
    [RepairEstimate]                          DECIMAL (20, 4) NULL,
    [SurveyCompletedBy]                       NVARCHAR (100)  NULL,
    [CheckboxSurveyStartDT]                   DATETIME2 (3)   NULL,
    [CheckboxSurveyEndDT]                     DATETIME2 (3)   NULL,
    [RowLoadedDateTime]                       DATETIME2 (3)   CONSTRAINT [DF_tblBuyAuctionInspectionCheckboxDataStage_RowLoadedDateTime] DEFAULT (getdate()) NOT NULL,
    [RowUpdatedDateTime]                      DATETIME2 (3)   NULL,
    [ResponseID]                              BIGINT          NULL,
    [AnswerID]                                BIGINT          NULL,
    CONSTRAINT [PK_tblBuyAuctionInspectionCheckboxDataStage] PRIMARY KEY CLUSTERED ([BuyAuctionInspectionCheckboxDataStageID] ASC) WITH (FILLFACTOR = 90)
);

