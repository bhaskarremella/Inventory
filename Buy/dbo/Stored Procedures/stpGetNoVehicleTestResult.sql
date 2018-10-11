-- =============================================
-- Author:		Javier Peralta
-- Create date: 90/25/2018
-- Description:	test stored proc
-- =============================================
CREATE PROCEDURE [dbo].[stpGetNoVehicleTestResult] 
	-- Add the parameters for the stored procedure here
	@vin nvarchar(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @vin
	RETURN(0 + RAND() * (2-0))
END
