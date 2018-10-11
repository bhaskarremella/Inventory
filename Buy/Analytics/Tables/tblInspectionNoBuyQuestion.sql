CREATE TABLE [Analytics].[tblInspectionNoBuyQuestion] (
    [InspectionNoBuyQuestionID] INT           IDENTITY (1, 1) NOT NULL,
    [RowLoadedDateTime]         DATETIME2 (7) CONSTRAINT [DF_tblInspectionNoBuyQuestion_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowUpdatedDateTime]        DATETIME2 (7) NULL,
    [LastChangedByEmpID]        VARCHAR (128) NULL,
    [Category]                  VARCHAR (100) NULL,
    [Question]                  VARCHAR (400) NULL,
    [Answer]                    VARCHAR (100) NULL,
    [NoBuy]                     TINYINT       NOT NULL,
    [StartDate]                 DATETIME2 (3) NULL,
    [EndDate]                   DATETIME2 (3) NULL,
    CONSTRAINT [PK_tblInspectionNoBuyQuestion_BuyAuctionLaneStartTimeID] PRIMARY KEY CLUSTERED ([InspectionNoBuyQuestionID] ASC) WITH (FILLFACTOR = 90)
);

