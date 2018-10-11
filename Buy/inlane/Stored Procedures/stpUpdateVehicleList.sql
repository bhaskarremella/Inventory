
CREATE PROCEDURE [inlane].[stpUpdateVehicleList]
/*----------------------------------------------------------------------------------------
Created By  : Lisa Aguilera
Created On  :2016-10-26
Application : InLaneBuy
Description : updated InLaneBuy tblVehicleList from SSIS

EXEC inlane.stpUpdateVehicleList
------------------------------------------------------------------------------------------
*/
AS
BEGIN
BEGIN TRY

	/* INSERT NEW ROWS  */
	INSERT INTO inlane.tblVehicleList
	        ( LastUpdatedEmpID ,
	          AuctionID ,
	          AuctionName ,
	          SaleDate ,
	          Run ,
	          Lane ,
	          VIN ,
	          Year ,
	          Make ,
	          Model ,
	          Color ,
	          Odometer ,
	          Size 
	        )
	SELECT vls.LastUpdatedEmpID ,
           vls.AuctionID ,
           vls.AuctionName ,
           vls.SaleDate ,
           vls.Run ,
           vls.Lane ,
           vls.VIN ,
           vls.Year ,
           vls.Make ,
           vls.Model ,
           vls.Color ,
           vls.Odometer ,
           vls.Size
	FROM stage.tblVehicleListStage vls
	JOIN inlane.tblAuction a WITH(NOLOCK) ON a.AuctionID = vls.AuctionID AND a.IsPilot = 1 --Only Insert Pilot Locations
	LEFT JOIN inlane.tblVehicleList vl WITH (NOLOCK) 
		ON vls.AuctionID = vl.AuctionID
		AND vls.SaleDate = vl.SaleDate
		AND vls.vIN = vl.VIN
	WHERE vl.VehicleListID IS NULL


	/* UPDATE EXISTING ROWS */
	UPDATE vl
	SET LastUpdatedEmpID = vls.LastUpdatedEmpID ,
        RowUpdatedDateTime = SYSDATETIME() ,
        AuctionID = vls.AuctionID ,
        AuctionName = vls.AuctionName ,
        SaleDate = vls.SaleDate ,
        Run = vls.Run ,
        Lane = vls.Lane ,
        VIN = vls.VIN ,
        Year = vls.Year ,
        Make = vls.Make ,
        Model = vls.Model ,
        Color = vls.Color ,
        Odometer = vls.Odometer ,
        Size = vls.Size
	FROM stage.tblVehicleListStage vls
	JOIN inlane.tblAuction a WITH(NOLOCK) ON a.AuctionID = vls.AuctionID AND a.IsPilot = 1 --Only Insert Pilot Locations
	JOIN inlane.tblVehicleList vl WITH (NOLOCK) 
		ON vls.AuctionID = vl.AuctionID
		AND vls.SaleDate = vl.SaleDate
		AND vls.vIN = vl.VIN
	WHERE vls.Run <> vl.Run
		OR vls.Lane <> vl.Lane
		OR vls.Year <> vl.Year
		OR vls.Make <> vl.Make
		OR vls.Model <> vl.Model
		OR vls.Color <> vl.Color
		OR vls.Odometer <> vl.Odometer
		OR vls.Size <> vl.Size

	/* DELETE ROWS */
	UPDATE vl	
		SET IsDeletedByFeed = 1
	FROM inlane.tblVehicleList vl WITH (NOLOCK) 
	LEFT JOIN stage.tblVehicleListStage vls
		ON vls.AuctionID = vl.AuctionID
		AND vls.SaleDate = vl.SaleDate
		AND vls.vIN = vl.VIN
	WHERE vls.VehicleListStageID IS NULL

END TRY

/*------------------------------------------------------
Special catch logic only good for SELECT type procedures
Because it does not contain rollback code.
------------------------------------------------------*/
BEGIN CATCH
    DECLARE 
        @ErrorNumber     INT,
        @ErrorSeverity   INT,
        @ErrorState      INT,
        @ErrorLine       INT,
        @ErrorProcedure  NVARCHAR(200),
        @ErrorMessage    VARCHAR(4000)

    -- Assign variables to error-handling functions that capture information for RAISERROR.
    SELECT 
        @ErrorNumber = ERROR_NUMBER(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE(),
        @ErrorLine = ERROR_LINE(),
        @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');

    -- Building the message string that will contain original error information.
    SELECT @ErrorMessage = 
        N'Error %d, Level %d, State %d, Procedure %s, Line %d, ' + 
            'Message: '+ ERROR_MESSAGE();

    -- Use RAISERROR inside the CATCH block to return error
    -- information about the original error that caused
    -- execution to jump to the CATCH block.
    RAISERROR (@ErrorMessage, -- Message text.
               16,  -- must be 16 for Informatica to pick it up
               1,
               @ErrorNumber,
               @ErrorSeverity, -- Severity.
               @ErrorState, -- State.
               @ErrorProcedure,
               @ErrorLine
               );

    -- Return a negative number so that if the calling code is using a LINK server, it will
    -- be able to test that the procedure failed.  Without this, there are some lower type of 
    -- errors that do not show up across the LINK as an error.  This causes ProcessControl 
    -- in particular to not see that the procedure failed which is bad.
    RETURN -1;

END CATCH
END
