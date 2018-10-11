
   CREATE   PROCEDURE [presale].[stpSearchNoBuy]
   (
      @VIN VARCHAR(17)
   )
   /*
   ------------------------------------------------------------------------------------------------
   Created By:       Daniel Folz
   Created On:       October 11, 2018
   Procedure Name:   presale.stpSearchNoBuy
   Application:      Called by Buyonic Vehicle Search
   Description:      Determine if a VIN in presale.tblCombinedPresale is a NoBuy decision for:
                        Exclusions from the BuyDirection table only for size make model and year
                        Exclude Group1 "Likes" that are found in the Announcements column
                        Exclude Vehicles with either a diesel engine or a manual transmission
   ------------------------------------------------------------------------------------------------
   */
   AS

      --SET @VIN = '1GCHK24U75E290527';

      SET NOCOUNT ON; 
      SET ANSI_NULLS, ANSI_WARNINGS ON;
      SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

      DECLARE @mult        FLOAT       = 1.20;
      DECLARE @sec         INTEGER     = 45;
      DECLARE @TodayDate   DATE        = CAST(GETDATE() AS DATE);

      --Create temp table for Likes -- These are only Group 1 LIKES
      DECLARE @Likes TABLE ([Like] VARCHAR(100));
      INSERT @Likes ([Like])
      VALUES
         ('frame'), ('unib'), ('struct'), ('sludge'), ('trans'), ('blown'), ('unidmg'), ('flood'), ('alt susp'), ('altered susp')
      ,  ('low susp'), ('tmu'), ('rollback'), ('water'), ('lemon'), ('engine'), ('eng light'), ('canad'), ('tra '), (' tra ')
      ,  ('tra/'), ('as is  tra'), ('cdn'), ('salv'), ('buyback'), ('buy back');

      --Create temp table for Years
      DECLARE @Years TABLE ([Year] SMALLINT PRIMARY KEY CLUSTERED);
      INSERT @Years
         EXECUTE('SELECT [Year] = td.Calendar_Year FROM [OLTP].SharedDimensions.dbo.tblTime_Dimension td WITH (NOLOCK) GROUP BY td.Calendar_Year ORDER BY td.Calendar_Year;');

      --Create temp table for CalendarDate
      DECLARE @CalendarDate TABLE ([Date] DATE, [DayName] VARCHAR(10) PRIMARY KEY CLUSTERED (Date));
      INSERT @CalendarDate
         EXECUTE('SELECT [Date] = td.Calendar_Date, [DayName] = td.Day_Name FROM [OLTP].SharedDimensions.dbo.tblTime_Dimension td WITH (NOLOCK) GROUP BY td.Calendar_Date, td.Day_Name ORDER BY td.Calendar_Date;');

      DROP TABLE IF EXISTS #Direction

      SELECT
         bd.BuyProcessBuyDirectionID
      ,  bd.RowLoadedDateTime
      ,  bd.RowUpdatedDateTime
      ,  bd.LastChangedByEmpID
      ,  bd.Size
      ,  bd.Make
      ,  bd.CommonModel
      ,  bd.BeginYear
      ,  bd.EndYear
      ,  bd.MinPrice
      ,  bd.MaxPrice
      ,  bd.MaxAboveBook
      ,  bd.MinMileage
      ,  bd.MaxMileage
      ,  bd.NoBuy
      ,  bd.ProductType
      ,  td.[Year]
      ,  [LookUp]       = CAST(ISNULL(bd.Size, '') + ISNULL(bd.Make, '') + ISNULL(bd.CommonModel, '') + 
                         (CASE WHEN td.[Year] IS NULL THEN '' ELSE CONVERT(VARCHAR, ISNULL(td.[Year], '')) END) AS VARCHAR(500))
      INTO
         #Direction
      FROM
         Analytics.tblBuyProcessBuyDirection bd WITH (NOLOCK)
      LEFT JOIN
      (
         SELECT DISTINCT
            td.[Year] 
         FROM
            @Years td
      ) td ON td.[Year] BETWEEN bd.BeginYear AND bd.EndYear
      WHERE
         bd.ProductType <= 1;

      CREATE NONCLUSTERED INDEX idx_Direction ON #Direction ([LookUp]);

      --Grab data from presale.tblCombinedPresale
      DROP TABLE IF EXISTS #CombinedPresale;
      CREATE TABLE #CombinedPresale
      (
         CombinedPresaleID          BIGINT                  NOT NULL 
      ,  RowLoadedDateTime          DATETIME2(7)            NOT NULL 
      ,  RowUpdatedDateTime         DATETIME2(7)            NULL
      ,  LastChangedByEmpID         VARCHAR (128)           NULL
      ,  PresaleRowLoadedDateTime   DATETIME2(7)            NULL
      ,  BuyAuctionHouseTypeID      BIGINT                  NULL
      ,  AuctionID                  VARCHAR(50)             NULL
      ,  AuctionName                VARCHAR(200)            NULL
      ,  AuctionEndDateTime         DATETIME2(3)            NULL     
      ,  VIN                        VARCHAR(17)             NOT NULL
      ,  SaleDate                   DATE                    NULL
      ,  MMRMID                     VARCHAR(16)             NULL
      ,  MMRValue                   BIGINT                  NULL
      ,  Channel                    VARCHAR(50)             NULL     
      ,  CRScore                    VARCHAR(10)             NULL
      ,  [Year]                     SMALLINT                NULL
      ,  Make                       VARCHAR(50)             NULL
      ,  Model                      VARCHAR(100)            NULL
      ,  ExteriorColor              VARCHAR(250)            NULL
      ,  Mileage                    INTEGER                 NULL
      ,  Engine                     VARCHAR(50)             NULL
      ,  Transmission               VARCHAR(100)            NULL
      ,  Announcements              VARCHAR(4000)           NULL
      ,  VehicleDetailURL           VARCHAR(1000)           NULL        
      ,  CRLink                     VARCHAR(1000)           NULL
      ,  AsIs                       TINYINT                 NULL
      ,  LaneNumber                 VARCHAR(10)             NULL
      ,  RunNumber                  INTEGER                 NULL
      ,  Seller                     VARCHAR(200)            NULL
      ,  IsDecommissioned           TINYINT                 NULL
      ,  IsDecommissionedDateTime   DATETIME2(7)            NULL
      ,  YearsOld                   SMALLINT                NULL
      ); 

      INSERT #CombinedPresale
      (
         CombinedPresaleID
      ,  RowLoadedDateTime
      ,  RowUpdatedDateTime
      ,  LastChangedByEmpID
      ,  PresaleRowLoadedDateTime
      ,  BuyAuctionHouseTypeID
      ,  AuctionID
      ,  AuctionName
      ,  AuctionEndDateTime
      ,  VIN
      ,  SaleDate
      ,  MMRMID
      ,  MMRValue
      ,  Channel
      ,  CRScore
      ,  [Year]
      ,  Make
      ,  Model
      ,  ExteriorColor
      ,  Mileage
      ,  Engine
      ,  Transmission
      ,  Announcements
      ,  VehicleDetailURL
      ,  CRLink
      ,  AsIs
      ,  LaneNumber
      ,  RunNumber
      ,  Seller
      ,  IsDecommissioned
      ,  IsDecommissionedDateTime
      ,  YearsOld
      )
      SELECT 
         cp.CombinedPresaleID
      ,  cp.RowLoadedDateTime
      ,  cp.RowUpdatedDateTime
      ,  cp.LastChangedByEmpID
      ,  cp.PresaleRowLoadedDateTime
      ,  cp.BuyAuctionHouseTypeID
      ,  cp.AuctionID
      ,  cp.AuctionName
      ,  cp.AuctionEndDateTime
      ,  cp.VIN
      ,  cp.SaleDate
      ,  cp.MMRMID
      ,  cp.MMRValue
      ,  cp.Channel
      ,  cp.CRScore
      ,  cp.[Year]
      ,  cp.Make
      ,  cp.Model
      ,  cp.ExteriorColor
      ,  cp.Mileage
      ,  cp.Engine
      ,  cp.Transmission
      ,  cp.Announcements
      ,  cp.VehicleDetailURL
      ,  cp.CRLink
      ,  cp.AsIs
      ,  cp.LaneNumber
      ,  cp.RunNumber
      ,  cp.Seller
      ,  cp.IsDecommissioned
      ,  cp.IsDecommissionedDateTime
      ,  cp.YearsOld
      FROM 
         presale.tblCombinedPresale cp WITH (NOLOCK)
      WHERE
            cp.VIN      =  @VIN
      AND   cp.SaleDate >= @TodayDate;

      DROP TABLE IF EXISTS #PresaleList

      SELECT
         psm.AuctionName
      ,  psm.SaleDate
      ,  psm.Channel
      ,  psm.LaneNumber
      ,  psm.RunNumber
      ,  psm.Seller
      ,  psm.VIN
      ,  psm.ExteriorColor
      ,  psm.[Year]
      ,  Make                 = ISNULL(mvd.Make, psm.Make)
      ,  Model                = ISNULL(mvd.CommonModel, psm.Model)
      ,  psm.Mileage
      ,  mvd.Size
      ,  mvd.BodyStyle
      ,  f.SizeGroup
      ,  psm.MMRValue
      ,  psm.CRScore
      ,  Announcements        = CASE WHEN psm.AsIs = 1 THEN 'AS IS ' + ISNULL(psm.Announcements, '') ELSE psm.Announcements END
      ,  psm.VehicleDetailURL
      ,  psm.CRLink
      ,  nb.Nobuyflag
      ,  LookUp1              = mvd.Size + ISNULL(mvd.Make, psm.Make) + ISNULL(mvd.CommonModel, psm.Model) + CONVERT(VARCHAR, psm.[Year])
      ,  LookUp2              = mvd.Size + ISNULL(mvd.Make, psm.Make) + ISNULL(mvd.CommonModel, psm.Model)
      ,  LookUp3              = ISNULL(mvd.Make, psm.Make) + CONVERT(VARCHAR, psm.[Year])
      ,  LookUp4              = ISNULL(mvd.Make, psm.Make) + ISNULL(mvd.CommonModel, psm.Model)
      ,  LookUp5              = mvd.Size + ISNULL(mvd.Make, psm.Make) + CONVERT(VARCHAR, psm.[Year])
      ,  LookUp6              = ISNULL(mvd.Make, psm.Make)
      ,  LookUp7              = mvd.Size
      ,  LookUp8              = mvd.Size + CONVERT(VARCHAR, psm.[Year])
      ,  LookUp9              = ISNULL(mvd.Make, psm.Make) + ISNULL(mvd.CommonModel, psm.Model) + CONVERT(VARCHAR, psm.[Year])
      ,  LookUp1A             = f.SizeFlag + f.MakeFlag + f.CommonModelFlag + f.YearFlag
      ,  LookUp2A             = f.SizeFlag + f.MakeFlag + f.CommonModelFlag
      ,  LookUp3A             = f.MakeFlag + f.YearFlag
      ,  LookUp4A             = f.MakeFlag + f.CommonModelFlag
      ,  LookUp5A             = f.SizeFlag + f.MakeFlag
      ,  LookUp6A             = f.MakeFlag
      ,  LookUp7A             = f.SizeFlag
      ,  LookUp8A             = f.SizeFlag + f.YearFlag
      ,  LookUp9A             = f.MakeFlag + f.CommonModelFlag + f.YearFlag
      ,  Diesels              = CASE WHEN psm.Engine LIKE '%diesel%' THEN 1 ELSE 0 END
      ,  Manuals              = CASE WHEN psm.Transmission LIKE '%manual%' THEN 1 ELSE 0 END
      INTO
         #PresaleList
      FROM
                  #CombinedPresale              psm
      LEFT JOIN   dbo.tblMMRVehicleDescription  mvd WITH (NOLOCK) ON mvd.MMR_MID = psm.MMRMID
      OUTER APPLY
      (
         SELECT
            Nobuyflag = 1
         FROM
            @Likes l
         WHERE
            psm.Announcements LIKE '%' + l.[Like] + '%'
         OR psm.Engine        LIKE '%diesel%'
         OR psm.Transmission  LIKE '%manual%'
      ) nb
      CROSS APPLY
      (
         SELECT
            SizeFlag        = CASE WHEN mvd.Size IS NOT NULL                           THEN 'Size'    ELSE NULL END
         ,  MakeFlag        = CASE WHEN ISNULL(mvd.Make, psm.Make) IS NOT NULL         THEN 'Make'    ELSE NULL END
         ,  CommonModelFlag = CASE WHEN ISNULL(mvd.CommonModel, psm.Model) IS NOT NULL THEN 'Model'   ELSE NULL END
         ,  YearFlag        = CASE WHEN psm.[Year] IS NOT NULL                         THEN 'Year'    ELSE NULL END
         ,  SizeGroup       = CASE
                                 WHEN mvd.Size IN ('COMPACT', 'LARGE', 'MEDIUM')                               THEN 'CAR'
                                 WHEN mvd.Size IN ('EURO', 'SPECIALTY', 'SPORTS')                              THEN 'PREMIUM CAR'
                                 WHEN mvd.Size IN ('CROSSOVER', 'LARGE SUV', 'MEDIUM SUV', 'SMALL SUV', 'VAN') THEN 'SUV'
                                 WHEN mvd.Size IN ('LARGE TRUCK', 'SMALL TRUCK')                               THEN 'TRUCK'
                              END
         ,  isTruck         = CASE
                                 WHEN
                                 (
                                    ISNULL(mvd.CommonModel, psm.Model) LIKE '%AVALANCHE%'
                                 OR ISNULL(mvd.CommonModel, psm.Model) LIKE '%F150%'
                                 OR ISNULL(mvd.CommonModel, psm.Model) LIKE '%F250%'
                                 OR ISNULL(mvd.CommonModel, psm.Model) LIKE '%F350%'
                                 OR ISNULL(mvd.CommonModel, psm.Model) LIKE '%SIERRA%'
                                 OR ISNULL(mvd.CommonModel, psm.Model) LIKE '%QUAD CAB 4.7L ST%'
                                 OR ISNULL(mvd.CommonModel, psm.Model) LIKE '%RAM 1500%'
                                 OR ISNULL(mvd.CommonModel, psm.Model) LIKE '%RAM 2500%'
                                 OR ISNULL(mvd.CommonModel, psm.Model) LIKE '%RIDGELINE%'
                                 OR ISNULL(mvd.CommonModel, psm.Model) LIKE '%BIG HORN%'
                                 OR ISNULL(mvd.CommonModel, psm.Model) LIKE '%SILVERADO%'
                                 OR ISNULL(mvd.CommonModel, psm.Model) LIKE '%TITAN%'
                                 OR ISNULL(mvd.CommonModel, psm.Model) LIKE '%TUNDRA%'
                                 OR ISNULL(mvd.CommonModel, psm.Model) LIKE '%MARK LT%'
                                 ) THEN 1
                                 WHEN mvd.Size = 'Large Truck' THEN 1
                                 ELSE 0
                              END
      ) f
      WHERE
         psm.SaleDate >= @TodayDate;

      CREATE CLUSTERED    INDEX #ind_VIN_presalelist  ON #PresaleList (VIN);
      CREATE NONCLUSTERED INDEX #idx1a                ON #PresaleList (LookUp1A);    
      CREATE NONCLUSTERED INDEX #idx2a                ON #PresaleList (LookUp2A);
      CREATE NONCLUSTERED INDEX #idx3a                ON #PresaleList (LookUp3A);
      CREATE NONCLUSTERED INDEX #idx4a                ON #PresaleList (LookUp4A);
      CREATE NONCLUSTERED INDEX #idx5a                ON #PresaleList (LookUp5A);
      CREATE NONCLUSTERED INDEX #idx6a                ON #PresaleList (LookUp6A);
      CREATE NONCLUSTERED INDEX #idx7a                ON #PresaleList (LookUp7A);
      CREATE NONCLUSTERED INDEX #idx8a                ON #PresaleList (LookUp8A);
      CREATE NONCLUSTERED INDEX #idx9a                ON #PresaleList (LookUp9A);           
      CREATE NONCLUSTERED INDEX #idx1                 ON #PresaleList (LookUp1);     
      CREATE NONCLUSTERED INDEX #idx2                 ON #PresaleList (LookUp2);
      CREATE NONCLUSTERED INDEX #idx3                 ON #PresaleList (LookUp3);
      CREATE NONCLUSTERED INDEX #idx4                 ON #PresaleList (LookUp4);
      CREATE NONCLUSTERED INDEX #idx5                 ON #PresaleList (LookUp5);
      CREATE NONCLUSTERED INDEX #idx6                 ON #PresaleList (LookUp6);
      CREATE NONCLUSTERED INDEX #idx7                 ON #PresaleList (LookUp7);
      CREATE NONCLUSTERED INDEX #idx8                 ON #PresaleList (LookUp8);
      CREATE NONCLUSTERED INDEX #idx9                 ON #PresaleList (LookUp9);     
   
      DROP TABLE IF EXISTS #ValidInspections;
      SELECT
         bv.VIN
      ,  AuctionName                = lt.AuctionListKey
      ,  bav.SaleDate
      ,  InspectionDate             = bai.InspectionCompletedDateTime
      ,  InspectionVehicleID        = bav.BuyAuctionVehicleID
      ,  IsBuyerInspectionRequested = bav.IsDTInspectionRequested
      ,  HasManheimCR               = (CASE WHEN bai.InspectionStatusKey = 'CRCOMPLETED' THEN 1 ELSE 0 END)
      INTO #ValidInspections
      FROM
            dbo.tblBuyAuctionVehicle      bav
      JOIN  dbo.tblBuyVehicle             bv    ON    bav.BuyVehicleID           = bv.BuyVehicleID
      JOIN  dbo.tblBuyAuctionListType     lt    ON    bav.BuyAuctionListTypeID   = lt.BuyAuctionListTypeID
      JOIN  dbo.tblBuyAuctionInspection   bai   ON    bav.BuyAuctionVehicleID    = bai.BuyAuctionVehicleID
      JOIN  #PresaleList                  p     ON    lt.AuctionListKey          = p.AuctionName
                                                AND   bav.SaleDate               = p.SaleDate
                                                AND   bv.VIN                     = p.VIN;
  
      DROP TABLE IF EXISTS #InspectionNoBuys
      SELECT DISTINCT
         vi.VIN
      ,  vi.AuctionName
      ,  vi.SaleDate
      ,  vi.InspectionDate
      ,  FailedInspection = SUM(ISNULL(nbq.NoBuy, 0))
      ,  FailedDate       = MAX(cbd.CheckboxSurveyEndDT)
      INTO
         #InspectionNoBuys
      FROM
                  #ValidInspections                         vi
      LEFT JOIN   dbo.tblBuyAuctionInspectionCheckboxData   cbd   WITH (NOLOCK)  ON    vi.VIN                     = cbd.VIN
                                                                                 AND   ISNULL(cbd.IsDeleted, 0)   = 0
      LEFT JOIN   Analytics.tblInspectionNoBuyQuestion      nbq   WITH (NOLOCK)  ON    cbd.Category               = nbq.Category
                                                                                 AND   cbd.Question               = nbq.Question
                                                                                 AND   cbd.Answer                 = nbq.Answer
                                                                                 AND   cbd.CheckboxSurveyEndDT BETWEEN nbq.StartDate AND ISNULL(nbq.EndDate, GETDATE())
      WHERE
         vi.InspectionDate IS NOT NULL
      GROUP BY
         vi.VIN
      ,  vi.AuctionName
      ,  vi.SaleDate
      ,  vi.InspectionDate
      HAVING
         SUM(ISNULL(nbq.NoBuy, 0)) > 0;
   
      DROP TABLE IF EXISTS #VehicleLights
      SELECT DISTINCT
         pv.VIN
      ,  pv.AuctionName
      ,  pv.SaleDate
      ,  pv.InspectionDate
      ,  Light1 = ISNULL(pv.[1], '')
      ,  Light2 = ISNULL(pv.[2], '')
      ,  Light3 = ISNULL(pv.[3], '')
      ,  Light4 = ISNULL(pv.[4], '')
      ,  Light5 = ISNULL(pv.[5], '')
      ,  Light6 = ISNULL(pv.[6], '')
      ,  Light7 = ISNULL(pv.[7], '')
      ,  Light8 = ISNULL(pv.[8], '')
      ,  Light9 = ISNULL(pv.[9], '')
      INTO #VehicleLights
      FROM
                  #ValidInspections vi
      INNER JOIN 
      ( 
         SELECT
            FullVIN     = cbd.VIN
         ,  Light       = REPLACE(cbd.Answer, 'None Of The Above', '')
         ,  LightNumber = ROW_NUMBER() OVER (PARTITION BY cbd.VIN ORDER BY REPLACE(cbd.Answer, 'None Of The Above', ''))
         FROM
            dbo.tblBuyAuctionInspectionCheckboxData cbd WITH ( NOLOCK )
         WHERE
               cbd.Question = 'Dash warning lights on?'
         AND   ISNULL(cbd.IsDeleted, 0) = 0
         AND   cbd.VIN IN 
         (
            SELECT DISTINCT 
               VIN 
            FROM 
               #ValidInspections 
            WHERE InspectionDate IS NOT NULL
         )
      
      ) l ON vi.VIN = l.FullVIN 
      PIVOT
         (MAX(Light) FOR LightNumber IN ([1], [2], [3], [4], [5], [6], [7], [8], [9])) pv;

      DROP TABLE IF EXISTS #ReconSplits
      SELECT DISTINCT
         vi.VIN
      ,  vi.SaleDate
      ,  vi.AuctionName
      ,  vi.InspectionDate
      ,  RepairCategory    = ISNULL(pc.Category, 'Other')
      ,  EstimatedRecon    = SUM(ISNULL(cbd.RepairEstimate, 0))
      ,  ReconDate         = MAX(CONVERT(DATE, cbd.CheckboxSurveyEndDT))
      INTO
         #ReconSplits
      FROM
                  #ValidInspections                         vi
      INNER JOIN  dbo.tblBuyAuctionInspectionCheckboxData   cbd   WITH (NOLOCK)  ON    vi.VIN         = cbd.VIN
      LEFT JOIN   Analytics.tblDTPreferredCriteria          pc    WITH (NOLOCK)  ON    cbd.Question   = pc.Question
                                                                                 AND   vi.SaleDate BETWEEN pc.StartDate AND ISNULL(pc.EndDate, vi.SaleDate)
      WHERE
            vi.InspectionDate             IS NOT NULL
      AND   ISNULL(cbd.IsDeleted, 0)      = 0                                       ----cbd.IsDeleted IS NULL
      AND   ISNULL(pc.Category, 'Other')  NOT IN ('Vehicle Description', 'Cap')
      GROUP BY
         vi.VIN
      ,  vi.SaleDate
      ,  vi.AuctionName
      ,  vi.InspectionDate
      ,  ISNULL(pc.Category, 'Other')
      ORDER BY
         vi.SaleDate
      ,  vi.VIN
      ,  vi.InspectionDate DESC;

      DECLARE @ReconCap MONEY = (SELECT DISTINCT Answer FROM Analytics.tblDTPreferredCriteria WITH (NOLOCK) WHERE Category = 'Cap');
   
      /*Updated this table to be a stage table given the new buy direction changes for salmon vehicles*/
      DROP TABLE IF EXISTS #FinalStage;
      SELECT DISTINCT
         psl.SaleDate
      ,  psl.AuctionName
      ,  psl.LaneNumber
      ,  psl.RunNumber
      ,  psl.VIN
      ,  Color                      = psl.ExteriorColor
      ,  psl.[Year]
      ,  psl.Make
      ,  psl.Model
      ,  psl.BodyStyle
--      ,  Odometer                   = COALESCE(Odom.Odom, psl.Mileage)
--      ,  Size                       = CASE WHEN cd.ProductType = 1 THEN 'SALMON ' + psl.Size ELSE psl.Size END
      ,  psl.CRScore
      ,  EstimatedRecon             = re.RepairEst
      ,  RecommendedBidValue        = 0
--      ,  VehiclePriceCap            = cd.MaxPrice
      ,  BookValue                  = Nada.NADAValue
      ,  ProxyBidAmount             = 0
      ,  LastBidValue               = 0
      ,  Purchased                  = 0
      ,  PurchasePrice              = 0
      ,  DeliveryLocation           = NULL
      ,  OverAllowance              = 0
      ,  NoBidReason                = NULL
      ,  Announcement               = psl.Announcements
      ,  psl.Seller
      ,  PreviousDTVehicle          = CASE WHEN stk.VIN IS NOT NULL THEN 1 ELSE 0 END
      ,  VehicleLink                = psl.VehicleDetailURL
      ,  psl.CRLink
      ,  IsDTInspected              = CASE WHEN (bi.VIN IS NOT NULL AND  bi.InspectionDate IS NOT NULL) THEN 1 ELSE 0 END
      ,  FailedInspection           = CASE WHEN inb.FailedInspection IS NOT NULL THEN 1 ELSE 0 END
      ,  IsDTPreferred              = ISNULL(pref.IsDTPreferred, 0)
      ,  DashboardLights            = ISNULL(vl.Light1 + CASE WHEN vl.Light2 <> '' THEN ', ' ELSE '' END + vl.Light2 + CASE WHEN vl.Light3 <> '' THEN ', ' ELSE '' END + vl.Light3 + CASE WHEN vl.Light4 <> '' THEN ', ' ELSE '' END + vl.Light4 + CASE WHEN vl.Light5 <> '' THEN ', ' ELSE '' END + vl.Light5 + CASE WHEN vl.Light6 <> '' THEN ', ' ELSE '' END + vl.Light6 + CASE WHEN vl.Light7 <> '' THEN ', ' ELSE '' END + vl.Light7 + CASE WHEN vl.Light8 <> '' THEN ', ' ELSE '' END + vl.Light8 + CASE WHEN vl.Light9 <> '' THEN ', ' ELSE '' END + vl.Light9, '')
      ,  InspectionNotes            = ISNULL(com.Comments, '')
      ,  ReconTireGlass             = ISNULL(rs.[Tires & Glass], 0)
      ,  ReconExteriorCosmetic      = ISNULL(rs.[Exterior Cosmetic], 0)
      ,  ReconInterior              = ISNULL(rs.Interior, 0)
      ,  ReconOther                 = ISNULL(rs.Other, 0)
      ,  bi.HasManheimCR
      ,  IsBuyerInspectionRequested = ISNULL(bi.IsBuyerInspectionRequested, 0)
      ,  MMRValue                   = COALESCE(Nada.NADAValue, psl.MMRValue)
      ,  clu.CostLookUp
      ,  mlu.MilesLookUp
--      ,  cd.MinPrice
--      ,  cd.ProductType
      INTO
         #FinalStage
      FROM
                  #PresaleList      psl
      LEFT JOIN   @CalendarDate     td ON psl.SaleDate = td.[Date]
      LEFT JOIN
      (
         SELECT DISTINCT
            stk.VIN 
         FROM
            dbo.tblStock stk WITH (NOLOCK)
      ) stk ON psl.VIN = stk.VIN
      --OUTER APPLY
      --(
      --   SELECT
      --      Odom = CAST(temp2.Answer AS DECIMAL(15, 4))
      --   FROM
      --               #ValidInspections                       vio
      --   INNER JOIN  dbo.tblBuyAuctionInspectionCheckboxData temp2 WITH (NOLOCK) ON vio.VIN = temp2.VIN
      --   WHERE
      --         psl.VIN                    = vio.VIN
      --   AND   psl.SaleDate               = vio.SaleDate
      --   AND   psl.AuctionName            = vio.AuctionName
      --   AND   vio.InspectionDate         IS NOT NULL
      --   AND   temp2.Question             IN ('Correct Odometer Value:', 'Odometer Value:')
      --   AND   ISNULL(temp2.IsDeleted, 0) =  0
      --   AND   temp2.Answer               <> ''
      --) Odom
      LEFT JOIN
      (
         SELECT DISTINCT
            psl.VIN
         ,  MinCostPriority  = MIN(p.CostPriority)
         ,  MinMilesPriority = MIN(p.MileagePriority)
         FROM
                     #PresaleList   psl
         INNER JOIN  #Direction     d ON  d.[LookUp] IN 
                                          (
                                             psl.LookUp1
                                          ,  psl.LookUp2
                                          ,  psl.LookUp3
                                          ,  psl.LookUp4
                                          ,  psl.LookUp5
                                          ,  psl.LookUp6
                                          ,  psl.LookUp7
                                          ,  psl.LookUp8
                                          ,  psl.LookUp9
                                          )
         CROSS APPLY
         (
            SELECT
               DirectionLookUp = CASE
                                    WHEN d.[LookUp] = psl.LookUp1 THEN psl.LookUp1A
                                    WHEN d.[LookUp] = psl.LookUp2 THEN psl.LookUp2A
                                    WHEN d.[LookUp] = psl.LookUp3 THEN psl.LookUp3A
                                    WHEN d.[LookUp] = psl.LookUp4 THEN psl.LookUp4A
                                    WHEN d.[LookUp] = psl.LookUp5 THEN psl.LookUp5A
                                    WHEN d.[LookUp] = psl.LookUp6 THEN psl.LookUp6A
                                    WHEN d.[LookUp] = psl.LookUp7 THEN psl.LookUp7A
                                    WHEN d.[LookUp] = psl.LookUp8 THEN psl.LookUp8A
                                    WHEN d.[LookUp] = psl.LookUp9 THEN psl.LookUp9A
                                    ELSE 'All' + CONVERT(VARCHAR, psl.[Year])
                                 END
         )                     dlu
         LEFT JOIN Analytics.tblBuyProcessDirectionPriority p WITH (NOLOCK) ON dlu.DirectionLookUp = p.[LookUp]
         GROUP BY
            psl.VIN
      ) p ON psl.VIN = p.VIN
      LEFT JOIN   Analytics.tblBuyProcessDirectionPriority cp WITH (NOLOCK) ON p.MinCostPriority = cp.CostPriority
      CROSS APPLY
      (
         SELECT
            CostLookUp = CASE
                            WHEN cp.[LookUp] = psl.LookUp1A THEN psl.LookUp1
                            WHEN cp.[LookUp] = psl.LookUp2A THEN psl.LookUp2
                            WHEN cp.[LookUp] = psl.LookUp3A THEN psl.LookUp3
                            WHEN cp.[LookUp] = psl.LookUp4A THEN psl.LookUp4
                            WHEN cp.[LookUp] = psl.LookUp5A THEN psl.LookUp5
                            WHEN cp.[LookUp] = psl.LookUp6A THEN psl.LookUp6
                            WHEN cp.[LookUp] = psl.LookUp7A THEN psl.LookUp7
                            WHEN cp.[LookUp] = psl.LookUp8A THEN psl.LookUp8
                            WHEN cp.[LookUp] = psl.LookUp9A THEN psl.LookUp9
                            ELSE 'All' + CONVERT(VARCHAR, psl.[Year])
                         END
      ) clu
      --LEFT JOIN   #Direction cd  ON    clu.CostLookUp = cd.[LookUp]
      --                           AND   CASE WHEN COALESCE(Odom.Odom, psl.Mileage) IN ( 0, 1 ) THEN 50000 
      --                                      ELSE COALESCE(Odom.Odom, psl.Mileage) END BETWEEN cd.MinMileage AND cd.MaxMileage
      LEFT JOIN Analytics.tblBuyProcessDirectionPriority mp WITH (NOLOCK) ON p.MinMilesPriority = mp.MileagePriority
      CROSS APPLY
      (
         SELECT
            MilesLookUp = CASE
                             WHEN mp.[LookUp] = psl.LookUp1A THEN psl.LookUp1
                             WHEN mp.[LookUp] = psl.LookUp2A THEN psl.LookUp2
                             WHEN mp.[LookUp] = psl.LookUp3A THEN psl.LookUp3
                             WHEN mp.[LookUp] = psl.LookUp4A THEN psl.LookUp4
                             WHEN mp.[LookUp] = psl.LookUp5A THEN psl.LookUp5
                             WHEN mp.[LookUp] = psl.LookUp6A THEN psl.LookUp6
                             WHEN mp.[LookUp] = psl.LookUp7A THEN psl.LookUp7
                             WHEN mp.[LookUp] = psl.LookUp8A THEN psl.LookUp8
                             WHEN mp.[LookUp] = psl.LookUp9A THEN psl.LookUp9
                             ELSE 'All' + CONVERT(VARCHAR, psl.[Year])
                          END
      ) mlu
      --LEFT JOIN #Direction md ON    mlu.MilesLookUp = md.[LookUp]
      --                        AND   CASE WHEN COALESCE(Odom.Odom, psl.Mileage) IN (0, 1) THEN 50000 
      --                                   ELSE COALESCE(Odom.Odom, psl.Mileage) END BETWEEN md.MinMileage AND md.MaxMileage
      --CROSS APPLY
      --(
      --   SELECT
      --      NoBuy = CASE WHEN ISNULL(cd.NoBuy, 0) + ISNULL(md.NoBuy, 0) + ISNULL(psl.Nobuyflag, 0) >= 1 THEN 1 ELSE 0 END
      --) nb
      LEFT JOIN #ValidInspections bi   WITH (NOLOCK)  ON    psl.VIN           = bi.VIN
                                                      AND   psl.SaleDate      = bi.SaleDate
                                                      AND   psl.AuctionName   = bi.AuctionName
      LEFT JOIN
      (
         SELECT DISTINCT
            vi.VIN
         ,  vi.AuctionName
         ,  vi.SaleDate
         ,  RepairEst      = SUM(cbd.RepairEstimate)
         FROM
                     #ValidInspections                         vi
         LEFT JOIN   dbo.tblBuyAuctionInspectionCheckboxData   cbd WITH (NOLOCK) ON vi.VIN = cbd.VIN
         WHERE
               ISNULL(cbd.IsDeleted, 0)   = 0            ----cbd.IsDeleted IS null
         AND   vi.InspectionDate          IS NOT NULL
         GROUP BY
            vi.VIN
         ,  vi.AuctionName
         ,  vi.SaleDate
      ) re  ON    psl.VIN           = re.VIN
             AND  psl.SaleDate      = re.SaleDate
             AND  psl.AuctionName   = re.AuctionName
      LEFT JOIN   #InspectionNoBuys inb   ON    psl.VIN           = inb.VIN
                                          AND   psl.SaleDate      = inb.SaleDate
                                          AND   psl.AuctionName   = inb.AuctionName
      --LEFT JOIN   Analytics.tblBuyAuctionLaneStartTime   alst  WITH (NOLOCK)  ON    psl.AuctionName   = alst.AuctionName
      --                                                                        AND   psl.LaneNumber    = CONVERT(VARCHAR, alst.LaneNumber)
      --                                                                        AND   td.[DayName]      = alst.SaleDay
      --                                                                        AND   alst.isActive     = 1
      --LEFT JOIN   Analytics.tblBuyAuctionDayException    ade   WITH (NOLOCK)  ON    psl.AuctionName   = ade.AuctionName
      --                                                                        AND   td.[DayName]      = ade.[DayOfWeek]
      --                                                                        AND   ade.IsCurrent     = 1
      --LEFT JOIN Analytics.tblBuyProcessLaneExclusion     le    WITH (NOLOCK)  ON    psl.AuctionName   = le.AuctionName
      --                                                                        AND  psl.LaneNumber = CONVERT(VARCHAR, le.LaneNumber)
      --                                                                        AND  td.DayName = le.DayofWeek
      --                                                                        AND  le.IsCurrent = 1
      OUTER APPLY
      (
         SELECT
            NADAValue = CAST(dbo.RemoveNonNumericChar(temp.Answer) AS DECIMAL(15, 4))  --added function to remove non-numeric values from the answers in checkbox
         FROM
            #ValidInspections                               vi1
         INNER JOIN dbo.tblBuyAuctionInspectionCheckboxData temp WITH (NOLOCK) ON vi1.VIN = temp.VIN
         WHERE
            psl.VIN                    = vi1.VIN
         AND psl.SaleDate              = vi1.SaleDate
         AND psl.AuctionName           = vi1.AuctionName
         AND vi1.InspectionDate IS NOT NULL
         AND temp.Question             = 'Book Value:'
         AND ISNULL(temp.IsDeleted, 0) = 0
         AND temp.Answer               <> ''
      )                                              Nada
      OUTER APPLY
      (
         SELECT
            Comments = REPLACE(temp3.Answer, 'Yes:', '')
         FROM
            #ValidInspections                              vi2
         LEFT JOIN dbo.tblBuyAuctionInspectionCheckboxData temp3 WITH (NOLOCK) ON vi2.VIN = temp3.VIN
         WHERE
            psl.VIN                       = vi2.VIN
         AND psl.SaleDate                 = vi2.SaleDate
         AND psl.AuctionName              = vi2.AuctionName
         AND vi2.InspectionDate           IS NOT NULL
         AND temp3.Question               = 'Additional Items:'
         AND temp3.Answer                 LIKE 'Yes:%'
         AND ISNULL(temp3.IsDeleted, 0)   = 0
      ) com
      LEFT JOIN #VehicleLights vl ON psl.VIN = vl.VIN
      LEFT JOIN
      (
         SELECT DISTINCT
            vi.VIN
         ,  vi.SaleDate
         ,  vi.AuctionName
         ,  DTPreferred = MAX(ISNULL(pc.DTPreferred, 0))
         FROM
            #ValidInspections                               vi    WITH (NOLOCK)
         INNER JOIN dbo.tblBuyAuctionInspectionCheckboxData cbd   WITH (NOLOCK)  ON    vi.VIN         = cbd.VIN
         LEFT JOIN Analytics.tblDTPreferredCriteria         pc    WITH (NOLOCK)  ON    cbd.Question   = pc.Question
                                                                                 AND   vi.SaleDate    BETWEEN pc.StartDate AND ISNULL(pc.EndDate, vi.SaleDate)
                                                                                 AND   cbd.Answer     = pc.Answer
         WHERE
               ISNULL(cbd.IsDeleted, 0)   = 0
         AND   vi.InspectionDate          IS NOT NULL
         GROUP BY
            vi.VIN
         ,  vi.SaleDate
         ,  vi.AuctionName
      ) pc  ON    psl.VIN           = pc.VIN
            AND   psl.SaleDate      = pc.SaleDate
            AND   psl.AuctionName   = pc.AuctionName
      LEFT JOIN
      (
         SELECT
            pv.VIN
         ,  pv.SaleDate
         ,  pv.AuctionName
         ,  [Tires & Glass]     = ISNULL(pv.[Tires & Glass], 0)
         ,  [Exterior Cosmetic] = ISNULL(pv.[Exterior Cosmetic], 0)
         ,  Interior            = ISNULL(pv.Interior, 0)
         ,  Other               = ISNULL(pv.Other, 0)
         FROM
            #ReconSplits rs
         PIVOT (SUM(EstimatedRecon) FOR RepairCategory IN ([Tires & Glass], [Exterior Cosmetic], Interior, Other)) pv
      ) rs  ON    psl.VIN           = rs.VIN
            AND   psl.SaleDate      = rs.SaleDate
            AND   psl.AuctionName   = rs.AuctionName
      LEFT JOIN
      (
         SELECT DISTINCT
            rs.VIN
         ,  rs.SaleDate
         ,  rs.AuctionName
         ,  pc.DTPreferred
         ,  PreferredRecon = SUM(rs.EstimatedRecon)
         FROM
            #ReconSplits rs
         LEFT JOIN
         (SELECT DISTINCT  pc.Category, pc.DTPreferred, pc.StartDate, pc.EndDate FROM  Analytics.tblDTPreferredCriteria pc WITH (NOLOCK)) pc ON rs.RepairCategory = pc.Category
                                                                                                                                             AND rs.SaleDate BETWEEN pc.StartDate AND ISNULL(pc.EndDate, rs.SaleDate)
         WHERE
            pc.DTPreferred = 1
         AND rs.RepairCategory NOT IN ( 'Vehicle Description', 'Cap' )
         GROUP BY
            rs.VIN
         ,  rs.SaleDate
         ,  rs.AuctionName
         ,  pc.DTPreferred
      ) prefrecon ON    psl.VIN           = prefrecon.VIN
                  AND   psl.SaleDate      = prefrecon.SaleDate
                  AND   psl.AuctionName   = prefrecon.AuctionName
      CROSS APPLY
      (
         SELECT
            IsDTPreferred = CASE WHEN pc.DTPreferred = 1 AND CASE WHEN inb.FailedInspection IS NOT NULL THEN 1 ELSE 0 END = 0 AND prefrecon.PreferredRecon <= @ReconCap THEN 1 ELSE 0 END
      ) pref
      --WHERE
      --   (
      --      COALESCE(Odom.Odom, psl.Mileage) BETWEEN md.MinMileage AND md.MaxMileage
      --   OR COALESCE(Odom.Odom, psl.Mileage, 0) IN ( 0, 1 )
      --   )
      --AND
      --(
      --   COALESCE(Nada.NADAValue, psl.MMRValue) BETWEEN cd.MinPrice AND CASE WHEN clu.CostLookUp NOT LIKE 'All%' THEN (cd.MaxPrice) * @mult ELSE (cd.MaxPrice) END
      --OR COALESCE(Nada.NADAValue, psl.MMRValue) IS NULL
      --)
      --AND nb.NoBuy = 0
      --AND le.LaneNumber IS NULL
      --AND   ade.AuctionName IS NULL;


      /*New Final table maintains existing columns but changes the VehiclePriceCap field to be calculated based off logic to eliminate duplicate caps for select salmon vehicles*/   
         IF OBJECT_ID('tempdb.dbo.#Final') IS NOT NULL
            DROP TABLE #Final;
         SELECT   DISTINCT
               fs.SaleDate ,
               fs.AuctionName ,
               fs.LaneNumber ,
               fs.RunNumber ,
               --fs.EstimatedRunTime ,
               fs.VIN ,
               fs.Color ,
               fs.Year ,
               fs.Make ,
               fs.Model ,
               fs.BodyStyle ,
               --fs.Odometer ,
               --fs.Size ,
               fs.CRScore ,
               fs.EstimatedRecon ,
               fs.RecommendedBidValue ,
               --vpc.VehiclePriceCap ,
               fs.BookValue ,
               fs.ProxyBidAmount ,
               fs.LastBidValue ,
               fs.Purchased ,
               fs.PurchasePrice ,
               fs.DeliveryLocation ,
               fs.OverAllowance ,
               fs.NoBidReason ,
               fs.Announcement ,
               fs.Seller ,
               fs.PreviousDTVehicle ,
               fs.VehicleLink ,
               fs.CRLink ,
               fs.IsDTInspected ,
               fs.FailedInspection ,
               fs.IsDTPreferred ,
               fs.DashboardLights ,
               fs.InspectionNotes ,
               fs.ReconTireGlass ,
               fs.ReconExteriorCosmetic ,
               fs.ReconInterior ,
               fs.ReconOther ,
               fs.HasManheimCR ,
               fs.IsBuyerInspectionRequested ,
               fs.MMRValue ,
               fs.CostLookUp ,
               fs.MilesLookUp 
      --          KBBMultiplier        = CASE WHEN fs.Size LIKE '%Salmon%' THEN COALESCE(smm.KBBMultiplier,ssm.KBBMultiplier,0.97) ELSE COALESCE(mm.AvgTradePctofKBB,sm.AvgTradePctofKBB,.75) END , --updated to add COALESCE for salmon specific multipliers
      --          KBBDTAdjustmentValue = CASE WHEN fs.Size LIKE '%Salmon%' THEN COALESCE(smm.KBBDTAdjustmentValue,ssm.KBBDTAdjustmentValue,-3200) ELSE 0 END  --updated to add COALESCE for salmon specific adjustments
      --          ac.AccuCheckID ,
      --          CASE WHEN ISNULL(ac.HasAccuCheckIssue,0) + ISNULL(ac.HasAccuCheckHistoryIssue,0) > 0 THEN 1 ELSE 0 END AS isAccuCheckIssue             
         INTO    #Final
         FROM    #FinalStage fs
               LEFT JOIN ( SELECT   DISTINCT
                                    VIN ,
                                    SaleDate ,
                                    AuctionName ,
                                    MaxMMR = MAX(MMRValue) ,
                                    --MaxMinPrice = MAX(MinPrice) ,
                                    --MaxProductType = MAX(ProductType) ,
                                    UnitCount = COUNT(*)
                           FROM    #FinalStage
                           GROUP BY VIN ,
                                    SaleDate ,
                                    AuctionName
                           ) dup ON fs.VIN = dup.VIN
                                    AND fs.AuctionName = dup.AuctionName
                                    AND fs.SaleDate = dup.SaleDate
                                    --AND dup.MaxProductType = 1
                                    AND dup.UnitCount > 1
            --   CROSS APPLY ( SELECT    VehiclePriceCap = CASE WHEN dup.VIN IS NOT NULL
            --                                                      AND MMRValue < MinPrice
            --                                                   THEN NULL
            --                                                   WHEN dup.VIN IS NOT NULL
            --                                                      AND MMRValue >= MinPrice
            --                                                      AND MMRValue > ( @mult
            --                                                      * VehiclePriceCap )
            --                                                   THEN NULL
            --                                                   WHEN ( dup.VIN IS NOT NULL
            --                                                      AND dup.MaxMMR >= dup.MaxMinPrice
            --                                                      )
            --                                                      AND MMRValue >= MinPrice
            --                                                      AND MMRValue >= VehiclePriceCap
            --                                                      AND MaxProductType = 1
            --                                                      AND ProductType = 0
            --                                                   THEN NULL --Updated to eliminate the unintentional elimination of records from prior logic
            --                                                   WHEN dup.VIN IS NOT NULL
            --                                                      AND fs.ProductType = 0
            --                                                      AND MMRValue IS NULL
            --                                                   THEN NULL
            --                                                   ELSE VehiclePriceCap
            --                                             END
            --               ) vpc
            --   LEFT JOIN Analytics.tblBuyProcessModelMultiplier mm WITH (NOLOCK)
            --      ON fs.Size = mm.Size
            --      AND fs.Make = mm.Make
            --      AND fs.Model = mm.CommonModel 
            --      AND mm.IsCore = 1
            --LEFT JOIN Analytics.tblBuyProcessSizeMultiplier sm WITH (NOLOCK)
            --      ON fs.Size = sm.Size
            --      AND sm.IsCore = 1
            --LEFT JOIN Analytics.tblBuyProcessModelMultiplier smm WITH (NOLOCK)
            --      ON fs.Size = smm.Size
            --      AND fs.Make = smm.Make
            --      AND fs.Model = smm.CommonModel   
            --      AND smm.IsCore = 0
            --LEFT JOIN Analytics.tblBuyProcessSizeMultiplier ssm WITH (NOLOCK)
            --      ON fs.Size = ssm.Size  
            --      AND ssm.IsCore = 0 
            --LEFT JOIN #AccuCheck ac
            --      ON fs.VIN = ac.VIN           
         --WHERE   
            --vpc.VehiclePriceCap IS NOT NULL
            --AND CASE WHEN fs.Size LIKE '%salmon%'
            --              AND ISNULL(CRScore, 0) < 3.5 THEN 1
            --         ELSE 0
            --    END = 0;
               --AND CASE WHEN fs.IsDTInspected = 1 THEN 1
               --      WHEN fs.Size LIKE '%salmon%' AND ISNULL(fs.CRScore,3.0) >= 3.0 THEN 1
               --      WHEN fs.Size NOT LIKE '%salmon%' AND ISNULL(fs.CRScore, 2.5) >= 2.5 THEN 1
               --      WHEN fs.Size IS NULL AND ISNULL(fs.CRScore, 2.5) >= 2.5 THEN 1 --updated to allow vehicles we can't match on to still flow through
               --         ELSE 0
               --      END = 1;  

      -- If a record exists in the #Final Table, it is NOT a NoBuy, set the case statement = 0
      -- If a record does NOT exist in the #Final Table, it IS a NOBuy, set the case statement = 1
      SELECT
         RetVal = CAST((CASE WHEN ISNULL(COUNT(1), 0) = 0 THEN 1 ELSE 0 END) AS BIT)
      FROM
         #Final f;
