
         CREATE PROCEDURE [postsale].[stpInsertManheimFeed]
         (
            @JSON VARCHAR(MAX)
         )
         AS
         /*----------------------------------------------------------------------------------------------
         Created By  : Andrew Manginelli
         Created On  : Feb 3, 2017
         Description : This proc will take incoming JSON records for Manheim Post Sale and insert them 
                       into postsale.tblManheimFeedStage, then insert them from stage to the main tables. 
                       It will also delete stage records older than 48 hours.
         ------------------------------------------------------------------------------------------------
         */

            --Set Environment
            SET NOCOUNT ON;
            SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

            --Prevent Parameter Sniffing
            DECLARE @JSON_internal VARCHAR(MAX) = @JSON

            --InternalID (SetID) to designate a batch of records in the stage table
            DECLARE @ManheimFeedStageSetID UNIQUEIDENTIFIER = (SELECT NEWID());

            --Set MaxAge for stage delete logic
            DECLARE @MaxAge DATETIME2(3) = DATEADD(DAY, -2, SYSUTCDATETIME())
                    
            --Delete all records in the stage table that are older than 48 hours
            DELETE FROM postsale.tblManheimFeedStage
            WHERE RowLoadedDateTime < @MaxAge
            
            --Insert all JSON data into stage table. We are using lax path mode at this time because it is just a system of record.
            INSERT INTO postsale.tblManheimFeedStage
                  ( 
                     ManheimFeedStageSetID, ListingID , CreatedOn , ManheimFeedPurchaseDate , Channel , ManheimFeedVIN , ManheimFeedStatus , UniqueID , ManheimFeedListingPurchaseDate , BlockTimestamp , PurchaseOfferExists ,
                     PurchasePrice , Currency , VehicleStatus , PurchaseApplication , PurchaseMethod , ManheimFeedListingConsignmentWorkOrderNumber , StartDate , EndDate , RegistrationDate , OfferingApplication ,
                     OfferMethod , SaleType , AsIs , Salvage , ConsignorCode , BidRestriction , OfferingStatus , OfferingStatusReason , ManheimFeedListingBuyerDealerNumber , ManheimFeedListingBuyerDealerName ,
                     BidderBadge , ManheimFeedListingBuyerHref , ManheimFeedListingInvoiceHref , ReceivedOn , UpdatedOn , ManheimFeedListingTitleStatus , TitleNotRequired , ManheimFeedListingTitleVIN ,
                     ManheimFeedListingTitleYear , ManheimFeedListingTitleMake , ManheimFeedListingTitleModel , BodyStyle , ManheimFeedListingTitleHref , StatusTimestamp , ManheimFeedListingPostSaleInspectionStatus ,
                     StatusReason , InspectionType , LegacyPSICode , LegacyDay14Flag , ManheimFeedListingPostSaleInspectionHref , [Count] , ManheimFeedListingCommentsHref , ManheimFeedListingConsignmentUnitVIN ,
                     ManheimFeedListingConsignmentUnitModelYear , ManheimFeedListingConsignmentUnitMake , ManheimFeedListingConsignmentUnitModel , Trim , Body , EngineDescription , OdometerReading , OdometerUnits ,
                     VehicleType , InteriorColor , ExteriorColor , ManheimFeedListingConsignmentSellerDealerNumber , ManheimFeedListingConsignmentSellerDealerName , ManheimFeedListingOfferingOperatingLocationLocationName ,
                     ManheimFeedListingOfferingOperatingLocationLocationCode , ManheimFeedListingOfferingOperatingLocationHref , SaleYear , SaleNumber , LaneNumber , RunNumber , RepNumber , RepName , ManheimFeedListingBuyerRepHref ,
                     Reading , Units , ManheimFeedListingTitleOperatingLocationLocationName , ManheimFeedListingTitleOperatingLocationLocationCode , ManheimFeedListingTitleOperatingLocationHref ,
                     ManheimFeedListingPostSaleInspectionOperatingLocationLocationName , ManheimFeedListingPostSaleInspectionOperatingLocationLocationCode , ManheimFeedListingPostSaleInspectionOperatingLocationHref ,
                     ManheimFeedListingPostSaleInspectionConsignmentWorkOrderNumber , Offsite , ManheimFeedListingConsignmentUnitPhysicalLocationLocationName , ManheimFeedListingConsignmentUnitPhysicalLocationLocationCode ,
                     ManheimFeedListingConsignmentUnitPhysicalLocationHref , ManheimFeedListingPostSaleInspectionConsignmentUnitVIN , ManheimFeedListingPostSaleInspectionConsignmentUnitModelYear ,
                     ManheimFeedListingPostSaleInspectionConsignmentUnitMake , ManheimFeedListingPostSaleInspectionConsignmentUnitModel , Address1 , City , StateProvinceRegion , Country , PostalCode
                  )
            SELECT
                  ManheimFeedStageSetID = @ManheimFeedStageSetID
               ,  ListingID                                                        
               ,  CreatedOn                                                        
               ,  ManheimFeedPurchaseDate                                          
               ,  Channel                                                          
               ,  ManheimFeedVIN                                                   
               ,  ManheimFeedStatus                                                
               ,  UniqueID                                                         
               ,  ManheimFeedListingPurchaseDate                                   
               ,  BlockTimestamp                                                   
               ,  PurchaseOfferExists                                              
               ,  PurchasePrice                                                    
               ,  Currency                                                         
               ,  VehicleStatus                                                    
               ,  PurchaseApplication                                              
               ,  PurchaseMethod                                                   
               ,  ManheimFeedListingConsignmentWorkOrderNumber                     
               ,  StartDate                                                        
               ,  EndDate                                                          
               ,  RegistrationDate                                                 
               ,  OfferingApplication                                              
               ,  OfferMethod                                                      
               ,  SaleType                                                         
               ,  AsIs                                                             
               ,  Salvage                                                          
               ,  ConsignorCode                                                    
               ,  BidRestriction                                                   
               ,  OfferingStatus                                                   
               ,  OfferingStatusReason                                             
               ,  ManheimFeedListingBuyerDealerNumber                              
               ,  ManheimFeedListingBuyerDealerName                                
               ,  BidderBadge                                                      
               ,  ManheimFeedListingBuyerHref                                      
               ,  ManheimFeedListingInvoiceHref                                    
               ,  ReceivedOn                                                       
               ,  UpdatedOn                                                        
               ,  ManheimFeedListingTitleStatus                                    
               ,  TitleNotRequired                                                 
               ,  ManheimFeedListingTitleVIN                                       
               ,  ManheimFeedListingTitleYear                                      
               ,  ManheimFeedListingTitleMake                                      
               ,  ManheimFeedListingTitleModel                                     
               ,  BodyStyle                                                        
               ,  ManheimFeedListingTitleHref                                      
               ,  StatusTimestamp                                                  
               ,  ManheimFeedListingPostSaleInspectionStatus                       
               ,  StatusReason                                                     
               ,  InspectionType                                                   
               ,  LegacyPSICode                                                    
               ,  LegacyDay14Flag                                                  
               ,  ManheimFeedListingPostSaleInspectionHref                         
               ,  [Count]                                                          
               ,  ManheimFeedListingCommentsHref                                   
               ,  ManheimFeedListingConsignmentUnitVIN                             
               ,  ManheimFeedListingConsignmentUnitModelYear                       
               ,  ManheimFeedListingConsignmentUnitMake                            
               ,  ManheimFeedListingConsignmentUnitModel                           
               ,  Trim                                                             
               ,  Body                                                             
               ,  EngineDescription                                                
               ,  OdometerReading                                                  
               ,  OdometerUnits                                                    
               ,  VehicleType                                                      
               ,  InteriorColor                                                    
               ,  ExteriorColor                                                    
               ,  ManheimFeedListingConsignmentSellerDealerNumber                  
               ,  ManheimFeedListingConsignmentSellerDealerName                    
               ,  ManheimFeedListingOfferingOperatingLocationLocationName          
               ,  ManheimFeedListingOfferingOperatingLocationLocationCode          
               ,  ManheimFeedListingOfferingOperatingLocationHref                  
               ,  SaleYear                                                         
               ,  SaleNumber                                                       
               ,  LaneNumber                                                       
               ,  RunNumber                                                        
               ,  RepNumber                                                        
               ,  RepName                                                          
               ,  ManheimFeedListingBuyerRepHref                                   
               ,  Reading                                                          
               ,  Units                                                            
               ,  ManheimFeedListingTitleOperatingLocationLocationName             
               ,  ManheimFeedListingTitleOperatingLocationLocationCode             
               ,  ManheimFeedListingTitleOperatingLocationHref                     
               ,  ManheimFeedListingPostSaleInspectionOperatingLocationLocationName
               ,  ManheimFeedListingPostSaleInspectionOperatingLocationLocationCode
               ,  ManheimFeedListingPostSaleInspectionOperatingLocationHref        
               ,  ManheimFeedListingPostSaleInspectionConsignmentWorkOrderNumber   
               ,  Offsite                                                          
               ,  ManheimFeedListingConsignmentUnitPhysicalLocationLocationName    
               ,  ManheimFeedListingConsignmentUnitPhysicalLocationLocationCode    
               ,  ManheimFeedListingConsignmentUnitPhysicalLocationHref            
               ,  ManheimFeedListingPostSaleInspectionConsignmentUnitVIN           
               ,  ManheimFeedListingPostSaleInspectionConsignmentUnitModelYear     
               ,  ManheimFeedListingPostSaleInspectionConsignmentUnitMake          
               ,  ManheimFeedListingPostSaleInspectionConsignmentUnitModel         
               ,  Address1                                                         
               ,  City                                                             
               ,  StateProvinceRegion                                              
               ,  Country                                                          
               ,  PostalCode                                                       
            FROM OPENJSON (@JSON_internal, '$')
            WITH 
               (
                  ListingID                                                               VARCHAR(36)             N'lax$.listingId',
                  CreatedOn                                                               VARCHAR(40)             N'lax$.createdOn',
                  ManheimFeedPurchaseDate                                                 VARCHAR(40)             N'lax$.purchaseDate',
                  Channel                                                                 VARCHAR(10)             N'lax$.channel',
                  ManheimFeedVIN                                                          VARCHAR(17)             N'lax$.vin',
                  ManheimFeedStatus                                                       TINYINT                 N'lax$.status',
                  UniqueID                                                                VARCHAR(36)             N'lax$.listing.uniqueId',
                  ManheimFeedListingPurchaseDate                                          VARCHAR(40)             N'lax$.listing.purchaseDate',
                  BlockTimestamp                                                          VARCHAR(40)             N'lax$.listing.blockTimestamp',
                  PurchaseOfferExists                                                     VARCHAR(20)             N'lax$.listing.purchaseOfferExists',
                  PurchasePrice                                                           MONEY                   N'lax$.listing.purchasePrice',
                  Currency                                                                VARCHAR(5)              N'lax$.listing.currency',
                  VehicleStatus                                                           VARCHAR(64)             N'lax$.listing.vehicleStatus',
                  PurchaseApplication                                                     VARCHAR(40)             N'lax$.listing.purchaseApplication',
                  PurchaseMethod                                                          VARCHAR(40)             N'lax$.listing.purchaseMethod',
                  ManheimFeedListingConsignmentWorkOrderNumber                            INT                     N'lax$.listing.consignment.workOrderNumber',
                  StartDate                                                               VARCHAR(40)             N'lax$.listing.offering.startDate',
                  EndDate                                                                 VARCHAR(40)             N'lax$.listing.offering.endDate',
                  RegistrationDate                                                        VARCHAR(40)             N'lax$.listing.offering.registrationDate',
                  OfferingApplication                                                     VARCHAR(40)             N'lax$.listing.offering.offeringApplication',
                  OfferMethod                                                             VARCHAR(20)             N'lax$.listing.offering.offerMethod',
                  SaleType                                                                VARCHAR(13)             N'lax$.listing.offering.saleType',
                  AsIs                                                                    VARCHAR(20)             N'lax$.listing.offering.asIs',
                  Salvage                                                                 VARCHAR(20)             N'lax$.listing.offering.salvage',
                  ConsignorCode                                                           VARCHAR(10)             N'lax$.listing.offering.consignorCode',
                  BidRestriction                                                          VARCHAR(13)             N'lax$.listing.offering.bidRestriction',
                  OfferingStatus                                                          VARCHAR(16)             N'lax$.listing.offering.offeringStatus',
                  OfferingStatusReason                                                    VARCHAR(96)             N'lax$.listing.offering.offeringStatusReason',
                  ManheimFeedListingBuyerDealerNumber                                     VARCHAR(24)             N'lax$.listing.buyer.dealerNumber',
                  ManheimFeedListingBuyerDealerName                                       VARCHAR(200)            N'lax$.listing.buyer.dealerName',
                  BidderBadge                                                             VARCHAR(10)             N'lax$.listing.buyer.bidderBadge',
                  ManheimFeedListingBuyerHref                                             VARCHAR(1000)           N'lax$.listing.buyer.href',
                  ManheimFeedListingInvoiceHref                                           VARCHAR(1000)           N'lax$.listing.invoice.href',
                  ReceivedOn                                                              VARCHAR(40)             N'lax$.listing.title.receivedOn',
                  UpdatedOn                                                               VARCHAR(40)             N'lax$.listing.title.updatedOn',
                  ManheimFeedListingTitleStatus                                           VARCHAR(20)             N'lax$.listing.title.status',
                  TitleNotRequired                                                        VARCHAR(20)             N'lax$.listing.title.titleNotRequired',
                  ManheimFeedListingTitleVIN                                              VARCHAR(17)             N'lax$.listing.title.vin',
                  ManheimFeedListingTitleYear                                             SMALLINT                N'lax$.listing.title.year',
                  ManheimFeedListingTitleMake                                             VARCHAR(50)             N'lax$.listing.title.make',
                  ManheimFeedListingTitleModel                                            VARCHAR(100)            N'lax$.listing.title.model',
                  BodyStyle                                                               VARCHAR(16)             N'lax$.listing.title.bodyStyle',
                  ManheimFeedListingTitleHref                                             VARCHAR(1000)           N'lax$.listing.title.href',
                  StatusTimestamp                                                         VARCHAR(40)             N'lax$.listing.postSaleInspection.statusTimestamp',
                  ManheimFeedListingPostSaleInspectionStatus                              VARCHAR(20)             N'lax$.listing.postSaleInspection.status',
                  StatusReason                                                            VARCHAR(96)             N'lax$.listing.postSaleInspection.statusReason',
                  InspectionType                                                          VARCHAR(32)             N'lax$.listing.postSaleInspection.inspectionType',
                  LegacyPSICode                                                           VARCHAR(32)             N'lax$.listing.postSaleInspection.legacyPSICode',
                  LegacyDay14Flag                                                         VARCHAR(20)             N'lax$.listing.postSaleInspection.legacyDay14Flag',
                  ManheimFeedListingPostSaleInspectionHref                                VARCHAR(1000)           N'lax$.listing.postSaleInspection.href',
                  [Count]                                                                 INT                     N'lax$.listing.comments.count',
                  ManheimFeedListingCommentsHref                                          VARCHAR(1000)           N'lax$.listing.comments.href',
                  ManheimFeedListingConsignmentUnitVIN                                    VARCHAR(17)             N'lax$.listing.consignment.unit.vin',
                  ManheimFeedListingConsignmentUnitModelYear                              SMALLINT                N'lax$.listing.consignment.unit.modelYear',
                  ManheimFeedListingConsignmentUnitMake                                   VARCHAR(50)             N'lax$.listing.consignment.unit.make',
                  ManheimFeedListingConsignmentUnitModel                                  VARCHAR(100)            N'lax$.listing.consignment.unit.model',
                  Trim                                                                    VARCHAR(65)             N'lax$.listing.consignment.unit.trim',
                  Body                                                                    VARCHAR(16)             N'lax$.listing.consignment.unit.body',
                  EngineDescription                                                       VARCHAR(64)             N'lax$.listing.consignment.unit.engineDescription',
                  OdometerReading                                                         INT                     N'lax$.listing.consignment.unit.odometerReading',
                  OdometerUnits                                                           VARCHAR(20)             N'lax$.listing.consignment.unit.odometerUnits',
                  VehicleType                                                             VARCHAR(48)             N'lax$.listing.consignment.unit.vehicleType',
                  InteriorColor                                                           VARCHAR(15)             N'lax$.listing.consignment.unit.interiorColor',
                  ExteriorColor                                                           VARCHAR(15)             N'lax$.listing.consignment.unit.exteriorColor',
                  ManheimFeedListingConsignmentSellerDealerNumber                         VARCHAR(24)             N'lax$.listing.consignment.seller.dealerNumber',
                  ManheimFeedListingConsignmentSellerDealerName                           VARCHAR(200)            N'lax$.listing.consignment.seller.dealerName',
                  ManheimFeedListingOfferingOperatingLocationLocationName                 VARCHAR(80)             N'lax$.listing.offering.operatingLocation.locationName',
                  ManheimFeedListingOfferingOperatingLocationLocationCode                 VARCHAR(24)             N'lax$.listing.offering.operatingLocation.locationCode',
                  ManheimFeedListingOfferingOperatingLocationHref                         VARCHAR(1000)           N'lax$.listing.offering.operatingLocation.href',
                  SaleYear                                                                SMALLINT                N'lax$.listing.offering.saleKey.saleYear',
                  SaleNumber                                                              TINYINT                 N'lax$.listing.offering.saleKey.saleNumber',
                  LaneNumber                                                              TINYINT                 N'lax$.listing.offering.saleKey.laneNumber',
                  RunNumber                                                               SMALLINT                N'lax$.listing.offering.saleKey.runNumber',
                  RepNumber                                                               VARCHAR(480)            N'lax$.listing.buyer.rep.repNumber',
                  RepName                                                                 VARCHAR(96)             N'lax$.listing.buyer.rep.repName',
                  ManheimFeedListingBuyerRepHref                                          VARCHAR(1000)           N'lax$.listing.buyer.rep.href',
                  Reading                                                                 INT                     N'lax$.listing.title.odometer.reading',
                  Units                                                                   VARCHAR(20)             N'lax$.listing.title.odometer.units',
                  ManheimFeedListingTitleOperatingLocationLocationName                    VARCHAR(80)             N'lax$.listing.title.operatingLocation.locationName',
                  ManheimFeedListingTitleOperatingLocationLocationCode                    VARCHAR(24)             N'lax$.listing.title.operatingLocation.locationCode',
                  ManheimFeedListingTitleOperatingLocationHref                            VARCHAR(1000)           N'lax$.listing.title.operatingLocation.href',
                  ManheimFeedListingPostSaleInspectionOperatingLocationLocationName       VARCHAR(80)             N'lax$.listing.postSaleInspection.operatingLocation.locationName',
                  ManheimFeedListingPostSaleInspectionOperatingLocationLocationCode       VARCHAR(24)             N'lax$.listing.postSaleInspection.operatingLocation.locationCode',
                  ManheimFeedListingPostSaleInspectionOperatingLocationHref               VARCHAR(1000)           N'lax$.listing.postSaleInspection.operatingLocation.href',
                  ManheimFeedListingPostSaleInspectionConsignmentWorkOrderNumber          INT                     N'lax$.listing.postSaleInspection.consignment.workOrderNumber',
                  Offsite                                                                 VARCHAR(20)             N'lax$.listing.consignment.unit.physicalLocation.offsite', 
                  ManheimFeedListingConsignmentUnitPhysicalLocationLocationName           VARCHAR(80)             N'lax$.listing.consignment.unit.physicalLocation.locationName', 
                  ManheimFeedListingConsignmentUnitPhysicalLocationLocationCode           VARCHAR(24)             N'lax$.listing.consignment.unit.physicalLocation.locationCode', 
                  ManheimFeedListingConsignmentUnitPhysicalLocationHref                   VARCHAR(1000)           N'lax$.listing.consignment.unit.physicalLocation.href',
                  ManheimFeedListingPostSaleInspectionConsignmentUnitVIN                  VARCHAR(17)             N'lax$.listing.postSaleInspection.consignment.unit.vin',
                  ManheimFeedListingPostSaleInspectionConsignmentUnitModelYear            SMALLINT                N'lax$.listing.postSaleInspection.consignment.unit.modelYear',
                  ManheimFeedListingPostSaleInspectionConsignmentUnitMake                 VARCHAR(50)             N'lax$.listing.postSaleInspection.consignment.unit.make',
                  ManheimFeedListingPostSaleInspectionConsignmentUnitModel                VARCHAR(100)            N'lax$.listing.postSaleInspection.consignment.unit.model',
                  Address1                                                                VARCHAR(96)             N'lax$.listing.consignment.unit.physicalLocation.address.address1',
                  City                                                                    VARCHAR(40)             N'lax$.listing.consignment.unit.physicalLocation.address.city',
                  StateProvinceRegion                                                     VARCHAR(10)             N'lax$.listing.consignment.unit.physicalLocation.address.stateProvinceRegion',
                  Country                                                                 VARCHAR(25)             N'lax$.listing.consignment.unit.physicalLocation.address.country',
                  PostalCode                                                              VARCHAR(24)             N'lax$.listing.consignment.unit.physicalLocation.address.postalCode'
               );
            
            --Insert into 'lake' tables
            INSERT INTO postsale.tblManheimFeed (ManheimFeedID, ListingID, CreatedOn, PurchaseDate, Channel, VIN, [Status])
            SELECT ManheimFeedID, ListingID, CreatedOn, ManheimFeedPurchaseDate, Channel, ManheimFeedVIN, ManheimFeedStatus
            FROM postsale.tblManheimFeedStage AS MFS
            WHERE MFS.ManheimFeedStageSetID = @ManheimFeedStageSetID;
            
            INSERT INTO postsale.tblManheimFeedListing (ManheimFeedListingID, UniqueID, ManheimFeedID, PurchaseDate, BlockTimestamp, PurchaseOfferExists, PurchasePrice, Currency, VehicleStatus, PurchaseApplication, PurchaseMethod)
            SELECT ManheimFeedListingID, UniqueID, ManheimFeedID, ManheimFeedListingPurchaseDate, BlockTimestamp, PurchaseOfferExists, PurchasePrice, Currency, VehicleStatus, PurchaseApplication, PurchaseMethod
            FROM postsale.tblManheimFeedStage AS MFS
            WHERE MFS.ManheimFeedStageSetID = @ManheimFeedStageSetID;
            
            INSERT INTO postsale.tblManheimFeedListingConsignment (ManheimFeedListingConsignmentID, ManheimFeedListingID, WorkOrderNumber)
            SELECT ManheimFeedListingConsignmentID, ManheimFeedListingID, ManheimFeedListingConsignmentWorkOrderNumber
            FROM postsale.tblManheimFeedStage AS MFS
            WHERE MFS.ManheimFeedStageSetID = @ManheimFeedStageSetID;
            
            INSERT INTO postsale.tblManheimFeedListingOffering (ManheimFeedListingOfferingID, ManheimFeedListingID, StartDate, EndDate, RegistrationDate, OfferingApplication, OfferMethod, SaleType, AsIs, Salvage, ConsignorCode, BidRestriction, OfferingStatus, OfferingStatusReason)
            SELECT ManheimFeedListingOfferingID, ManheimFeedListingID, StartDate, EndDate, RegistrationDate, OfferingApplication, OfferMethod, SaleType, AsIs, Salvage, ConsignorCode, BidRestriction, OfferingStatus, OfferingStatusReason
            FROM postsale.tblManheimFeedStage AS MFS
            WHERE MFS.ManheimFeedStageSetID = @ManheimFeedStageSetID;
            
            INSERT INTO postsale.tblManheimFeedListingBuyer (ManheimFeedListingBuyerID, ManheimFeedListingID, DealerNumber, DealerName, BidderBadge, Href)
            SELECT ManheimFeedListingBuyerID, ManheimFeedListingID, ManheimFeedListingBuyerDealerNumber, ManheimFeedListingBuyerDealerName, BidderBadge, ManheimFeedListingBuyerHref
            FROM postsale.tblManheimFeedStage AS MFS
            WHERE MFS.ManheimFeedStageSetID = @ManheimFeedStageSetID;
            
            INSERT INTO postsale.tblManheimFeedListingInvoice (ManheimFeedListingInvoiceID, ManheimFeedListingID, Href)
            SELECT ManheimFeedListingInvoiceID, ManheimFeedListingID, ManheimFeedListingInvoiceHref
            FROM postsale.tblManheimFeedStage AS MFS
            WHERE MFS.ManheimFeedStageSetID = @ManheimFeedStageSetID;
            
            INSERT INTO postsale.tblManheimFeedListingTitle (ManheimFeedListingTitleID, ManheimFeedListingID, ReceivedOn, UpdatedOn, [Status], TitleNotRequired,VIN, [Year], Make, Model, BodyStyle, Href)
            SELECT ManheimFeedListingTitleID, ManheimFeedListingID, ReceivedOn, UpdatedOn, ManheimFeedListingTitleStatus, TitleNotRequired, ManheimFeedListingTitleVIN, ManheimFeedListingTitleYear, ManheimFeedListingTitleMake, ManheimFeedListingTitleModel, BodyStyle, ManheimFeedListingTitleHref
            FROM postsale.tblManheimFeedStage AS MFS
            WHERE MFS.ManheimFeedStageSetID = @ManheimFeedStageSetID;
            
            INSERT INTO postsale.tblManheimFeedListingPostSaleInspection (ManheimFeedListingPostSaleInspectionID, ManheimFeedListingID, StatusTimestamp, [Status], StatusReason, InspectionType, LegacyPSICode, LegacyDay14Flag, Href)
            SELECT ManheimFeedListingPostSaleInspectionID, ManheimFeedListingID, StatusTimestamp, ManheimFeedListingPostSaleInspectionStatus, StatusReason, InspectionType, LegacyPSICode, LegacyDay14Flag, ManheimFeedListingPostSaleInspectionHref
            FROM postsale.tblManheimFeedStage AS MFS
            WHERE MFS.ManheimFeedStageSetID = @ManheimFeedStageSetID;
            
            INSERT INTO postsale.tblManheimFeedListingComments (ManheimFeedListingCommentsID, ManheimFeedListingID, [Count], Href)
            SELECT ManheimFeedListingCommentsID, ManheimFeedListingID, [Count], ManheimFeedListingCommentsHref
            FROM postsale.tblManheimFeedStage AS MFS
            WHERE MFS.ManheimFeedStageSetID = @ManheimFeedStageSetID;
            
            INSERT INTO postsale.tblManheimFeedListingConsignmentUnit (ManheimFeedListingConsignmentUnitID, ManheimFeedListingConsignmentID, VIN, ModelYear, Make, Model, Trim, Body, EngineDescription, OdometerReading, OdometerUnits, VehicleType, InteriorColor, ExteriorColor)
            SELECT ManheimFeedListingConsignmentUnitID, ManheimFeedListingConsignmentID, ManheimFeedListingConsignmentUnitVIN, ManheimFeedListingConsignmentUnitModelYear, ManheimFeedListingConsignmentUnitMake, ManheimFeedListingConsignmentUnitModel, Trim, Body, EngineDescription, OdometerReading, OdometerUnits, VehicleType, InteriorColor, ExteriorColor
            FROM postsale.tblManheimFeedStage AS MFS
            WHERE MFS.ManheimFeedStageSetID = @ManheimFeedStageSetID;
            
            INSERT INTO postsale.tblManheimFeedListingConsignmentSeller (ManheimFeedListingConsignmentSellerID, ManheimFeedListingConsignmentID, DealerNumber, DealerName)
            SELECT ManheimFeedListingConsignmentSellerID, ManheimFeedListingConsignmentID, ManheimFeedListingConsignmentSellerDealerNumber, ManheimFeedListingConsignmentSellerDealerName
            FROM postsale.tblManheimFeedStage AS MFS
            WHERE MFS.ManheimFeedStageSetID = @ManheimFeedStageSetID;
            
            INSERT INTO postsale.tblManheimFeedListingOfferingOperatingLocation (ManheimFeedListingOfferingOperatingLocationID, ManheimFeedListingOfferingID, LocationName, LocationCode, Href)
            SELECT ManheimFeedListingOfferingOperatingLocationID, ManheimFeedListingOfferingID, ManheimFeedListingOfferingOperatingLocationLocationName, ManheimFeedListingOfferingOperatingLocationLocationCode, ManheimFeedListingOfferingOperatingLocationHref
            FROM postsale.tblManheimFeedStage AS MFS
            WHERE MFS.ManheimFeedStageSetID = @ManheimFeedStageSetID;
            
            INSERT INTO postsale.tblManheimFeedListingOfferingSaleKey (ManheimFeedListingOfferingSaleKeyID, ManheimFeedListingOfferingID, SaleYear, SaleNumber, LaneNumber, RunNumber)
            SELECT ManheimFeedListingOfferingSaleKeyID, ManheimFeedListingOfferingID, SaleYear, SaleNumber, LaneNumber, RunNumber
            FROM postsale.tblManheimFeedStage AS MFS
            WHERE MFS.ManheimFeedStageSetID = @ManheimFeedStageSetID;
            
            INSERT INTO postsale.tblManheimFeedListingBuyerRep (ManheimFeedListingBuyerRepID, ManheimFeedListingBuyerID, RepNumber, RepName, Href)
            SELECT ManheimFeedListingBuyerRepID, ManheimFeedListingBuyerID, RepNumber, RepName, ManheimFeedListingBuyerRepHref
            FROM postsale.tblManheimFeedStage AS MFS
            WHERE MFS.ManheimFeedStageSetID = @ManheimFeedStageSetID;
            
            INSERT INTO postsale.tblManheimFeedListingTitleOdometer (ManheimFeedListingTitleOdometerID, ManheimFeedListingTitleID, Reading, Units)
            SELECT ManheimFeedListingTitleOdometerID, ManheimFeedListingTitleID, Reading, Units
            FROM postsale.tblManheimFeedStage AS MFS
            WHERE MFS.ManheimFeedStageSetID = @ManheimFeedStageSetID;
            
            INSERT INTO postsale.tblManheimFeedListingTitleOperatingLocation (ManheimFeedListingTitleOperatingLocationID, ManheimFeedListingTitleID, LocationName, LocationCode, Href)
            SELECT ManheimFeedListingTitleOperatingLocationID, ManheimFeedListingTitleID, ManheimFeedListingTitleOperatingLocationLocationName, ManheimFeedListingTitleOperatingLocationLocationCode, ManheimFeedListingTitleOperatingLocationHref
            FROM postsale.tblManheimFeedStage AS MFS
            WHERE MFS.ManheimFeedStageSetID = @ManheimFeedStageSetID;
            
            INSERT INTO postsale.tblManheimFeedListingPostSaleInspectionOperatingLocation (ManheimFeedListingPostSaleInspectionOperatingLocationID, ManheimFeedListingPostSaleInspectionID, LocationName, LocationCode, Href)
            SELECT ManheimFeedListingPostSaleInspectionOperatingLocationID, ManheimFeedListingPostSaleInspectionID, ManheimFeedListingPostSaleInspectionOperatingLocationLocationName, ManheimFeedListingPostSaleInspectionOperatingLocationLocationCode, ManheimFeedListingPostSaleInspectionOperatingLocationHref
            FROM postsale.tblManheimFeedStage AS MFS
            WHERE MFS.ManheimFeedStageSetID = @ManheimFeedStageSetID;
            
            INSERT INTO postsale.tblManheimFeedListingPostSaleInspectionConsignment (ManheimFeedListingPostSaleInspectionConsignmentID, ManheimFeedListingPostSaleInspectionID, WorkOrderNumber)
            SELECT ManheimFeedListingPostSaleInspectionConsignmentID, ManheimFeedListingPostSaleInspectionID, ManheimFeedListingPostSaleInspectionConsignmentWorkOrderNumber
            FROM postsale.tblManheimFeedStage AS MFS
            WHERE MFS.ManheimFeedStageSetID = @ManheimFeedStageSetID;
            
            INSERT INTO postsale.tblManheimFeedListingConsignmentUnitPhysicalLocation (ManheimFeedListingConsignmentUnitPhysicalLocationID, ManheimFeedListingConsignmentUnitID, Offsite, LocationName, LocationCode, Href)
            SELECT ManheimFeedListingConsignmentUnitPhysicalLocationID, ManheimFeedListingConsignmentUnitID, Offsite, ManheimFeedListingConsignmentUnitPhysicalLocationLocationName, ManheimFeedListingConsignmentUnitPhysicalLocationLocationCode, ManheimFeedListingConsignmentUnitPhysicalLocationHref
            FROM postsale.tblManheimFeedStage AS MFS
            WHERE MFS.ManheimFeedStageSetID = @ManheimFeedStageSetID;
            
            INSERT INTO postsale.tblManheimFeedListingPostSaleInspectionConsignmentUnit (ManheimFeedListingPostSaleInspectionConsignmentUnitID, ManheimFeedListingPostSaleInspectionConsignmentID, VIN, ModelYear, Make, Model)
            SELECT ManheimFeedListingPostSaleInspectionConsignmentUnitID, ManheimFeedListingPostSaleInspectionConsignmentID, ManheimFeedListingPostSaleInspectionConsignmentUnitVIN, ManheimFeedListingPostSaleInspectionConsignmentUnitModelYear, ManheimFeedListingPostSaleInspectionConsignmentUnitMake, ManheimFeedListingPostSaleInspectionConsignmentUnitModel
            FROM postsale.tblManheimFeedStage AS MFS
            WHERE MFS.ManheimFeedStageSetID = @ManheimFeedStageSetID;
            
            INSERT INTO postsale.tblManheimFeedListingConsignmentUnitPhysicalLocationAddress (ManheimFeedListingConsignmentUnitPhysicalLocationAddressID, ManheimFeedListingConsignmentUnitPhysicalLocationID, Address1, City, StateProvinceRegion, Country, PostalCode)
            SELECT ManheimFeedListingConsignmentUnitPhysicalLocationAddressID, ManheimFeedListingConsignmentUnitPhysicalLocationID, Address1, City, StateProvinceRegion, Country, PostalCode
            FROM postsale.tblManheimFeedStage AS MFS
            WHERE MFS.ManheimFeedStageSetID = @ManheimFeedStageSetID;