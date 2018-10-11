
CREATE PROCEDURE [dbo].[stpMergeVehicleImages]
AS
	MERGE AuctionEdge.tblVehicleImages AS t
	USING
	(	SELECT
			tblVehicleImages_Stage.VehicleImageReferenceId
		   ,tblVehicleImages_Stage.ImageName
		   ,MAX(tblVehicleImages_Stage.isMainImage)isMainImage
		   ,MAX(tblVehicleImages_Stage.ImageURL)	ImageURL
		FROM
			AuctionEdge.tblVehicleImages_Stage
		GROUP BY
			tblVehicleImages_Stage.VehicleImageReferenceId
		   ,tblVehicleImages_Stage.ImageName) AS s
	ON (t.ImageName = s.ImageName
		AND t.VehicleImageReferenceId = s.VehicleImageReferenceId)
	WHEN MATCHED THEN UPDATE SET
						  t.VehicleImageReferenceId = s.VehicleImageReferenceId
						 ,t.ImageName = s.ImageName
						 ,t.isMainImage = s.isMainImage
						 ,t.ImageURL = s.ImageURL
	WHEN NOT MATCHED BY TARGET THEN INSERT (VehicleImageReferenceId
									   ,ImageName
									   ,isMainImage
									   ,ImageURL)
									VALUES (
										s.VehicleImageReferenceId, s.ImageName, s.isMainImage, s.ImageURL);


