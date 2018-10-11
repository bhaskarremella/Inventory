
   CREATE   PROCEDURE [presale].[stpIUManheimFeed]
   (
      @passedManheimFeed presale.typManheimFeed READONLY
   )
   AS
   /*
      *********************************************************************************************************************************************************************
      **
      **    Name:          presale.stpIUManheimFeed
      **
      **    Description:   This proc will take the records passed into the @passedManheimFeed variable from type table presale.typManheimFeed and update or insert records
      **                   into presale.tblManheimFeed. It will strip out the Images field and upsert those into presale.tblManheimFeedImage. It will also 
      **                   insert all records into presale.tblManheimFeedTrend.
      **
      **    Parameters:    Type Table presale.typManheimFeed
      **
      **    How To Call:   
      **
      **    Created:       Oct 7, 2016
      **    Author:        Andrew Manginelli
      **    Group:         Inventory
      **
      **    History:
      **
      **    Change Date          Author                                                         Reason
      **    -------------------- -------------------------------------------------------------- -----------------------------------------------------------------------------
      **    Nov 21, 2016			Andrew Manginelli												            Added logic to strip out records of EventType 'ListingUpdateRejected' to be
		**																							                     inserted into the new table presale.tblManheimFeedTrendUpdateRejected so they
      **                                                                                        can still be tracked if needed.
      **
      **    Feb 9, 2017          Andrew Manginelli                                              Added IsDeleted column to the insert for the Trend table. This is so 
      **                                                                                        Analytics can track whether a record is marked deleted and then shows up 
      **                                                                                        in the feed again. Also added a filter on the Image table merge to exclude
      **                                                                                        ListingRemoved events so the service doesn't have to make another round trip
      **                                                                                        to the Image table when doing soft deletes. 
      **
      **    Mar 9, 2017          Andrew Manginelli                                              Added Region and Announcements columns to the Feed, Trend and 
      **                                                                                        TrendUpdateRejected.
      **
      **    Nov 9, 2017          Gwendolyn Lukemire                                             Added four new columns to Feed, Trend and TrendUpdateRejected:
      **                                                                                        AuctionComments, Remarks, PickupLocationState, PickupLocationZip
      **
      **    May 23, 2018         Daniel Folz                                                    Removed code that inserts into presale.tblManheimFeedTrend and
      **                                                                                        presale.tblManheimFeedTrendUpdateRejected.  This will no longer happen
      **                                                                                        in the SQLPRODINV\INVENTORY Buy db; however, trending will still be 
      **                                                                                        recorded in SQLPRODDM\DATAMART InventoryDM  (US #70371)
      **********************************************************************************************************************************************************************
      */

       --Set Environment
       SET NOCOUNT ON;
       SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

       --Prevent Parameter Sniffing
       DECLARE @ManheimFeed presale.typManheimFeed;
       INSERT @ManheimFeed
       SELECT *
       FROM @passedManheimFeed;

       --Grab only the records with the latest RowLoadedDateTime as those are the most up to date records
       DECLARE @ManheimFeedProcess presale.typManheimFeed;
       INSERT @ManheimFeedProcess
       SELECT DISTINCT
           f.*
       FROM @ManheimFeed f
           JOIN
            (
                SELECT m.ListingID,
                    RowLoadedDateTime = MAX(m.RowLoadedDateTime)
                FROM @ManheimFeed m
                WHERE EventType <> 'ListingUpdateRejected'
                GROUP BY m.ListingID
                HAVING MAX(m.RowLoadedDateTime) = MAX(m.RowLoadedDateTime)
            ) t
               ON f.ListingID = t.ListingID
                  AND f.RowLoadedDateTime = t.RowLoadedDateTime;

       --UPSERT Feed records into presale.tblManheimFeed
       MERGE presale.tblManheimFeed AS target
       USING
       (
           SELECT *
           FROM @ManheimFeedProcess
       ) AS source
       ON target.ListingID = source.ListingID
       WHEN MATCHED THEN
           UPDATE SET RowUpdatedDateTime = SYSUTCDATETIME(),
               EventType = ISNULL(source.EventType, target.EventType),
               SaleDate = ISNULL(source.SaleDate, target.SaleDate),
               SaleYear = ISNULL(source.SaleYear, target.SaleYear),
               AuctionStartDate = ISNULL(
                                      source.AuctionStartDate,
                                      target.AuctionStartDate
                                        ),
               AuctionEndDate = ISNULL(
                                    source.AuctionEndDate, target.AuctionEndDate
                                      ),
               AuctionID = ISNULL(source.AuctionID, target.AuctionID),
               AuctionLocation = ISNULL(
                                     source.AuctionLocation,
                                     target.AuctionLocation
                                       ),
               Channel = ISNULL(source.Channel, target.Channel),
               DealerGroup = ISNULL(source.DealerGroup, target.DealerGroup),
               GroupCode = ISNULL(source.GroupCode, target.GroupCode),
               UniqueID = ISNULL(source.UniqueID, target.UniqueID),
               LaneNumber = ISNULL(source.LaneNumber, target.LaneNumber),
               SaleNumber = ISNULL(source.SaleNumber, target.SaleNumber),
               AsIs = ISNULL(source.AsIs, target.AsIs),
               DoorCount = ISNULL(source.DoorCount, target.DoorCount),
               FrameDamage = ISNULL(source.FrameDamage, target.FrameDamage),
               HasAirConditioning = ISNULL(
                                        source.HasAirConditioning,
                                        target.HasAirConditioning
                                          ),
               OffsiteFlag = ISNULL(source.OffsiteFlag, target.OffsiteFlag),
               PriorPaint = ISNULL(source.PriorPaint, target.PriorPaint),
               Salvage = ISNULL(source.Salvage, target.Salvage),
               IsDeleted = ISNULL(source.IsDeleted, target.IsDeleted),
               VIN = ISNULL(source.VIN, target.VIN),
               VinPrefix = ISNULL(source.VinPrefix, target.VinPrefix),
               [Year] = ISNULL(source.[Year], target.[Year]),
               Make = ISNULL(source.Make, target.Make),
               Model = ISNULL(source.Model, target.Model),
               Trim = ISNULL(source.Trim, target.Trim),
               BodyStyle = ISNULL(source.BodyStyle, target.BodyStyle),
               ExteriorColor = ISNULL(source.ExteriorColor, target.ExteriorColor),
               Mileage = ISNULL(source.Mileage, target.Mileage),
               Drivetrain = ISNULL(source.Drivetrain, target.Drivetrain),
               Transmission = ISNULL(source.Transmission, target.Transmission),
               Engine = ISNULL(source.Engine, target.Engine),
               FuelType = ISNULL(source.FuelType, target.FuelType),
               Airbags = ISNULL(source.Airbags, target.Airbags),
               InteriorColor = ISNULL(source.InteriorColor, target.InteriorColor),
               InteriorType = ISNULL(source.InteriorType, target.InteriorType),
               Roof = ISNULL(source.Roof, target.Roof),
               EcrGrade = ISNULL(source.EcrGrade, target.EcrGrade),
               ConditionGradeNumDecimal = ISNULL(
                                              source.ConditionGradeNumDecimal,
                                              target.ConditionGradeNumDecimal
                                                ),
               LocationZip = ISNULL(source.LocationZip, target.LocationZip),
               LotID = ISNULL(source.LotID, target.LotID),
               Mid = ISNULL(source.Mid, target.Mid),
               PickupLocation = ISNULL(
                                    source.PickupLocation, target.PickupLocation
                                      ),
               TypeCode = ISNULL(source.TypeCode, target.TypeCode),
               YearCharacter = ISNULL(source.YearCharacter, target.YearCharacter),
               Options = ISNULL(source.Options, target.Options),
               Seller = ISNULL(source.Seller, target.Seller),
               TitleState = ISNULL(source.TitleState, target.TitleState),
               TitleStatus = ISNULL(source.TitleStatus, target.TitleStatus),
               CurrentBidPrice = ISNULL(
                                     source.CurrentBidPrice,
                                     target.CurrentBidPrice
                                       ),
               BuyNowPrice = ISNULL(source.BuyNowPrice, target.BuyNowPrice),
               RunNumber = ISNULL(source.RunNumber, target.RunNumber),
               BuyerGroupID = ISNULL(source.BuyerGroupID, target.BuyerGroupID),
               VehicleSaleURL = ISNULL(
                                    source.VehicleSaleURL, target.VehicleSaleURL
                                      ),
               CrURL = ISNULL(source.CrURL, target.CrURL),
               MobileCrURL = ISNULL(source.MobileCrURL, target.MobileCrURL),
               EcrURL = ISNULL(source.EcrURL, target.EcrURL),
               SdURL = ISNULL(source.SdURL, target.SdURL),
               MobileSdURL = ISNULL(source.MobileSdURL, target.MobileSdURL),
               MobileVdpURL = ISNULL(source.MobileVdpURL, target.MobileVdpURL),
               VdpURL = ISNULL(source.VdpURL, target.VdpURL),
               Comments = ISNULL(source.Comments, target.Comments),
               Region = ISNULL(source.Region, target.Region),
               Announcements = ISNULL(source.Announcements, target.Announcements),
               AuctionComments = ISNULL(source.AuctionComments, target.AuctionComments),
               Remarks = ISNULL(source.Remarks, target.Remarks),
               PickupLocationState = ISNULL(source.PickupLocationState, target.PickupLocationState),
               PickupLocationZip = ISNULL(source.PickupLocationZip, target.PickupLocationZip)
       WHEN NOT MATCHED THEN
           INSERT
           (
               ListingID,
               RowLoadedDateTime,
               EventType,
               SaleDate,
               SaleYear,
               AuctionStartDate,
               AuctionEndDate,
               AuctionID,
               AuctionLocation,
               Channel,
               DealerGroup,
               GroupCode,
               UniqueID,
               LaneNumber,
               SaleNumber,
               AsIs,
               DoorCount,
               FrameDamage,
               HasAirConditioning,
               OffsiteFlag,
               PriorPaint,
               Salvage,
               IsDeleted,
               VIN,
               VinPrefix,
               [Year],
               Make,
               Model,
               Trim,
               BodyStyle,
               ExteriorColor,
               Mileage,
               Drivetrain,
               Transmission,
               Engine,
               FuelType,
               Airbags,
               InteriorColor,
               InteriorType,
               Roof,
               EcrGrade,
               ConditionGradeNumDecimal,
               LocationZip,
               LotID,
               Mid,
               PickupLocation,
               TypeCode,
               YearCharacter,
               Options,
               Seller,
               TitleState,
               TitleStatus,
               CurrentBidPrice,
               BuyNowPrice,
               RunNumber,
               BuyerGroupID,
               VehicleSaleURL,
               CrURL,
               MobileCrURL,
               EcrURL,
               SdURL,
               MobileSdURL,
               MobileVdpURL,
               VdpURL,
               Comments,
               Region,
               Announcements,
               AuctionComments,
               Remarks,
               PickupLocationState,
               PickupLocationZip
           )
           VALUES
           (   source.ListingID,
               SYSUTCDATETIME(),
               source.EventType,
               source.SaleDate,
               source.SaleYear,
               source.AuctionStartDate,
               source.AuctionEndDate,
               source.AuctionID,
               source.AuctionLocation,
               source.Channel,
               source.DealerGroup,
               source.GroupCode,
               source.UniqueID,
               source.LaneNumber,
               source.SaleNumber,
               source.AsIs,
               source.DoorCount,
               source.FrameDamage,
               source.HasAirConditioning,
               source.OffsiteFlag,
               source.PriorPaint,
               source.Salvage,
               source.IsDeleted,
               source.VIN,
               source.VinPrefix,
               source.[Year],
               source.Make,
               source.Model,
               source.Trim,
               source.BodyStyle,
               source.ExteriorColor,
               source.Mileage,
               source.Drivetrain,
               source.Transmission,
               source.Engine,
               source.FuelType,
               source.Airbags,
               source.InteriorColor,
               source.InteriorType,
               source.Roof,
               source.EcrGrade,
               source.ConditionGradeNumDecimal,
               source.LocationZip,
               source.LotID,
               source.Mid,
               source.PickupLocation,
               source.TypeCode,
               source.YearCharacter,
               source.Options,
               source.Seller,
               source.TitleState,
               source.TitleStatus,
               source.CurrentBidPrice,
               source.BuyNowPrice,
               source.RunNumber,
               source.BuyerGroupID,
               source.VehicleSaleURL,
               source.CrURL,
               source.MobileCrURL,
               source.EcrURL,
               source.SdURL,
               source.MobileSdURL,
               source.MobileVdpURL,
               source.VdpURL,
               source.Comments,
               source.Region,
               source.Announcements,
               source.AuctionComments,
               source.Remarks,
               source.PickupLocationState,
               source.PickupLocationZip
           );

       --UPSERT Image records into presale.tblManheimFeedImage
       MERGE presale.tblManheimFeedImage AS target
       USING
       (
           SELECT *
           FROM @ManheimFeedProcess
           WHERE EventType <> 'ListingRemoved' --added so the soft delete logic on app side doesn't also have to make a round trip to image table
       ) AS source
       ON target.ListingID = source.ListingID
       WHEN MATCHED THEN
           UPDATE SET Images = source.Images
       WHEN NOT MATCHED THEN
           INSERT
           (
               ImageID,
               ListingID,
               Images
           )
           VALUES
           (NEWID(), source.ListingID, source.Images);

       --** Code Segment Removed May 23, 2018 -- See Comments in the Header **--

       ----INSERT all messages into Trend table (except records with EventType of 'ListingUpdateRejected')
       --INSERT presale.tblManheimFeedTrend
       --(
       --    TrendID,
       --    ListingID,
       --    RowLoadedDateTime,
       --    EventType,
       --    SaleDate,
       --    SaleYear,
       --    AuctionStartDate,
       --    AuctionEndDate,
       --    AuctionID,
       --    AuctionLocation,
       --    Channel,
       --    DealerGroup,
       --    GroupCode,
       --    UniqueID,
       --    LaneNumber,
       --    SaleNumber,
       --    AsIs,
       --    DoorCount,
       --    FrameDamage,
       --    HasAirConditioning,
       --    OffsiteFlag,
       --    PriorPaint,
       --    Salvage,
       --    VIN,
       --    VinPrefix,
       --    [Year],
       --    Make,
       --    Model,
       --    Trim,
       --    BodyStyle,
       --    ExteriorColor,
       --    Mileage,
       --    Drivetrain,
       --    Transmission,
       --    Engine,
       --    FuelType,
       --    Airbags,
       --    InteriorColor,
       --    InteriorType,
       --    Roof,
       --    EcrGrade,
       --    ConditionGradeNumDecimal,
       --    LocationZip,
       --    LotID,
       --    Mid,
       --    PickupLocation,
       --    TypeCode,
       --    YearCharacter,
       --    Options,
       --    Seller,
       --    TitleState,
       --    TitleStatus,
       --    CurrentBidPrice,
       --    BuyNowPrice,
       --    RunNumber,
       --    BuyerGroupID,
       --    VehicleSaleURL,
       --    CrURL,
       --    MobileCrURL,
       --    EcrURL,
       --    SdURL,
       --    MobileSdURL,
       --    MobileVdpURL,
       --    VdpURL,
       --    Comments,
       --    IsDeleted,
       --    Region,
       --    Announcements,
       --    AuctionComments,
       --    Remarks,
       --    PickupLocationState,
       --    PickupLocationZip
       --)
       --SELECT NEWID(),
       --    ListingID,
       --    SYSUTCDATETIME(),
       --    EventType,
       --    SaleDate,
       --    SaleYear,
       --    AuctionStartDate,
       --    AuctionEndDate,
       --    AuctionID,
       --    AuctionLocation,
       --    Channel,
       --    DealerGroup,
       --    GroupCode,
       --    UniqueID,
       --    LaneNumber,
       --    SaleNumber,
       --    AsIs,
       --    DoorCount,
       --    FrameDamage,
       --    HasAirConditioning,
       --    OffsiteFlag,
       --    PriorPaint,
       --    Salvage,
       --    VIN,
       --    VinPrefix,
       --    [Year],
       --    Make,
       --    Model,
       --    Trim,
       --    BodyStyle,
       --    ExteriorColor,
       --    Mileage,
       --    Drivetrain,
       --    Transmission,
       --    Engine,
       --    FuelType,
       --    Airbags,
       --    InteriorColor,
       --    InteriorType,
       --    Roof,
       --    EcrGrade,
       --    ConditionGradeNumDecimal,
       --    LocationZip,
       --    LotID,
       --    Mid,
       --    PickupLocation,
       --    TypeCode,
       --    YearCharacter,
       --    Options,
       --    Seller,
       --    TitleState,
       --    TitleStatus,
       --    CurrentBidPrice,
       --    BuyNowPrice,
       --    RunNumber,
       --    BuyerGroupID,
       --    VehicleSaleURL,
       --    CrURL,
       --    MobileCrURL,
       --    EcrURL,
       --    SdURL,
       --    MobileSdURL,
       --    MobileVdpURL,
       --    VdpURL,
       --    Comments,
       --    IsDeleted,
       --    Region,
       --    Announcements,
       --    AuctionComments,
       --    Remarks,
       --    PickupLocationState,
       --    PickupLocationZip
       --FROM @ManheimFeed
       --WHERE EventType <> 'ListingUpdateRejected'
       --ORDER BY RowLoadedDateTime ASC;

       ----INSERT all messages with EventType 'ListingUpdateRejected' into tblManheimFeedTrendUpdateRejected
       --INSERT presale.tblManheimFeedTrendUpdateRejected
       --(
       --    TrendUpdateRejectedID,
       --    ListingID,
       --    RowLoadedDateTime,
       --    EventType,
       --    SaleDate,
       --    SaleYear,
       --    AuctionStartDate,
       --    AuctionEndDate,
       --    AuctionID,
       --    AuctionLocation,
       --    Channel,
       --    DealerGroup,
       --    GroupCode,
       --    UniqueID,
       --    LaneNumber,
       --    SaleNumber,
       --    AsIs,
       --    DoorCount,
       --    FrameDamage,
       --    HasAirConditioning,
       --    OffsiteFlag,
       --    PriorPaint,
       --    Salvage,
       --    VIN,
       --    VinPrefix,
       --    [Year],
       --    Make,
       --    Model,
       --    Trim,
       --    BodyStyle,
       --    ExteriorColor,
       --    Mileage,
       --    Drivetrain,
       --    Transmission,
       --    Engine,
       --    FuelType,
       --    Airbags,
       --    InteriorColor,
       --    InteriorType,
       --    Roof,
       --    EcrGrade,
       --    ConditionGradeNumDecimal,
       --    LocationZip,
       --    LotID,
       --    Mid,
       --    PickupLocation,
       --    TypeCode,
       --    YearCharacter,
       --    Options,
       --    Seller,
       --    TitleState,
       --    TitleStatus,
       --    CurrentBidPrice,
       --    BuyNowPrice,
       --    RunNumber,
       --    BuyerGroupID,
       --    VehicleSaleURL,
       --    CrURL,
       --    MobileCrURL,
       --    EcrURL,
       --    SdURL,
       --    MobileSdURL,
       --    MobileVdpURL,
       --    VdpURL,
       --    Comments,
       --    Region,
       --    Announcements,
       --    AuctionComments,
       --    Remarks,
       --    PickupLocationState,
       --    PickupLocationZip
       --)
       --SELECT NEWID(),
       --    ListingID,
       --    SYSUTCDATETIME(),
       --    EventType,
       --    SaleDate,
       --    SaleYear,
       --    AuctionStartDate,
       --    AuctionEndDate,
       --    AuctionID,
       --    AuctionLocation,
       --    Channel,
       --    DealerGroup,
       --    GroupCode,
       --    UniqueID,
       --    LaneNumber,
       --    SaleNumber,
       --    AsIs,
       --    DoorCount,
       --    FrameDamage,
       --    HasAirConditioning,
       --    OffsiteFlag,
       --    PriorPaint,
       --    Salvage,
       --    VIN,
       --    VinPrefix,
       --    [Year],
       --    Make,
       --    Model,
       --    Trim,
       --    BodyStyle,
       --    ExteriorColor,
       --    Mileage,
       --    Drivetrain,
       --    Transmission,
       --    Engine,
       --    FuelType,
       --    Airbags,
       --    InteriorColor,
       --    InteriorType,
       --    Roof,
       --    EcrGrade,
       --    ConditionGradeNumDecimal,
       --    LocationZip,
       --    LotID,
       --    Mid,
       --    PickupLocation,
       --    TypeCode,
       --    YearCharacter,
       --    Options,
       --    Seller,
       --    TitleState,
       --    TitleStatus,
       --    CurrentBidPrice,
       --    BuyNowPrice,
       --    RunNumber,
       --    BuyerGroupID,
       --    VehicleSaleURL,
       --    CrURL,
       --    MobileCrURL,
       --    EcrURL,
       --    SdURL,
       --    MobileSdURL,
       --    MobileVdpURL,
       --    VdpURL,
       --    Comments,
       --    Region,
       --    Announcements,
       --    AuctionComments,
       --    Remarks,
       --    PickupLocationState,
       --    PickupLocationZip
       --FROM @ManheimFeed
       --WHERE EventType = 'ListingUpdateRejected'
       --ORDER BY RowLoadedDateTime ASC;
