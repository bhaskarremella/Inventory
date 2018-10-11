
CREATE PROCEDURE [dbo].[getFileArchiveID] (@FileName VARCHAR(255))
AS
	BEGIN
		UPDATE
			AuctionEdge.Vehicle
		SET
			Vehicle.FileId = FileArchiveId
		FROM
		(	SELECT
				MAX(FileArchive.FileArchiveId)FileArchiveId
			FROM
				AuctionEdge.FileArchive
			WHERE
				FileArchive.IncomingFileName = @FileName) AS t
		WHERE
			Vehicle.FileId IS NULL;
	END;

