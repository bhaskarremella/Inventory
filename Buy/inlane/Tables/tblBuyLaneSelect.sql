CREATE TABLE [inlane].[tblBuyLaneSelect] (
    [InspectionVehicleSelectID] BIGINT        IDENTITY (1, 1) NOT NULL,
    [LastUpdatedEmpID]          VARCHAR (128) CONSTRAINT [DF_tbBuyVehicleSelect_LastUpdatedByEmpID] DEFAULT (suser_sname()) NOT NULL,
    [RowUpdatedDateTime]        DATETIME2 (3) CONSTRAINT [DF_tblBuyVehicleSelect_RowUpdatedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [RowLoadedDateTime]         DATETIME2 (3) CONSTRAINT [DF_tblBuyVehicleSelect_RowLoadedDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [UserName]                  VARCHAR (100) NOT NULL,
    [AuctionNameShort]          VARCHAR (50)  NOT NULL,
    [SaleDateString]            VARCHAR (10)  NOT NULL,
    [LaneString]                VARCHAR (11)  NOT NULL,
    [IsDeleted]                 BIT           CONSTRAINT [DF_tblBuyVehicleSelect_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblBuyVehicleSelect] PRIMARY KEY CLUSTERED ([InspectionVehicleSelectID] ASC) WITH (FILLFACTOR = 90)
);


GO


	
	CREATE trigger [inlane].[trgItblBuyLaneSelect] on [inlane].[tblBuyLaneSelect]
	  FOR INSERT
	  AS
	/***********************************************************************
	*                                                                      
	* Name:
	*   trgItblBuyLaneSelect                                      
	*                                                                      
	* Description
	*   Updated IsLaneSelected and LaneSelectedBy Fields in tblBuyLaneSelect
	*
	*
	*   Created By: Lisa Aguilera
	*   Created On: 10/28/2016            
	*                                                                      
	**********************************************************************/
	BEGIN
	
	/*Set this so that the trigger can have a raiserror command rollback all changes*/
	SET XACT_ABORT ON
	

	UPDATE vl
		SET IsLaneSelected = 1
		  , LaneSelectedBy = i.UserName
	FROM inserted i 
	JOIN inlane.tblVehicleList vl 
		ON vl.AuctionNameShort = i.AuctionNameShort
		AND vl.SaleDateString = i.SaleDateString
		AND vl.LaneString = i.LaneString



	END


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This is used by PowerApps In Lane Buy App which requires the date to be a string.', @level0type = N'SCHEMA', @level0name = N'inlane', @level1type = N'TABLE', @level1name = N'tblBuyLaneSelect', @level2type = N'COLUMN', @level2name = N'SaleDateString';

