
CREATE PROCEDURE [dbo].[stpGetFileArchiveID] (@FileName VARCHAR(255))
AS
	BEGIN
		UPDATE
			AuctionEdge.tblVehicle
		SET
			tblVehicle.FileId = FileArchiveId
		FROM
		(	SELECT
				MAX(tblFileArchive.FileArchiveId)FileArchiveId
			FROM
				AuctionEdge.tblFileArchive
			WHERE
				tblFileArchive.IncomingFileName = @FileName) AS t
		WHERE
			tblVehicle.FileId IS NULL;
	END;


