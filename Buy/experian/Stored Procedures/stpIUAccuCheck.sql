
CREATE PROCEDURE [experian].[stpIUAccuCheck]
(@passedAccuCheck experian.typeAccuCheck READONLY,
@passedAccuCheckHistory experian.typeAccuCheckHistory READONLY,
 @passedAccuCheckIds experian.typeAccuCheckIDList READONLY)

    /**********************************************************************************************************************************************************************
         **
         **    Name:          experian.stpIUAccuCheckReport
         **
         **    Description:   This proc will take the records passed into the @@accuCheck variable from type table experian.typeAccuCheck and experian.typeAccuCheckHistory 
         **                   and insert or update records. Records are only deleted or inserted into tblAccuCheckHistory as there is not a way to know what changed.
         **
         **    Parameters:    Type Table experian.typeAccuCheck, Type table experian.typeAccuCheckHistory, Type table experian.typeAccuCheckIDList
         **
         **    How To Call:   
         **
         **    Created:       Jan 20, 2018
         **    Author:        Jeremy Johnson/Gwen Lukemire
         **    Group:         Inventory
         **
         **********************************************************************************************************************************************************************/
AS

BEGIN
    --Set Environment
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


BEGIN TRY;

DECLARE @TranCount int;
      --<other declarations including temp table creations>

-- Get if the session is in transaction state yet or not
SET @TranCount = @@trancount;

-- Detect if the procedure was called from an active transaction and save that for later use. In the procedure, 
-- @TranCount = 0 means there was no active transaction and the procedure started one. @TranCount > 0 means 
-- an active transaction was started before the procedure was called.
IF @TranCount = 0
   -- No active transaction so begin one
   BEGIN TRANSACTION;
ELSE
   -- Create a savepoint to be able to roll back only the work done in the procedure if there is an error
   SAVE TRANSACTION stpIUAccuCheck


    --Prevent Parameter Sniffing
    DECLARE @accuCheck experian.typeAccuCheck;
    INSERT @AccuCheck
    SELECT RowLoadedDateTime,
           RowUpdatedDateTime,
           VehMixedVID,
           VehMixedIDType,
           VehMixedCount,
           VehMixedLastState,
           VehMixedLastTitle,
           VehMixedLastDate,
           VehMixedLastOdometer,
           VehMixedRollback,
           VehMixedSalvage,
           VehMixedFailedEmission,
           VehMixedDamage,
           VehMixedLemon,
           VehMixedOdometerProblem,
           VehMixedTheft,
           VehMixedTheftRecovered,
           VehMixedWaterDamage,
           VehMixedAbandoned,
           VehMixedJunk,
           VehMixedRecycled,
           VehMixedGreyMarket,
           VehMixedRebuilt,
           VehMixedCanadianRegistration,
           VehMixedTitleRegStorm,
           VehMixedRentalFleet,
           VehMixedHailDamage,
           VehMixedNHTSACrashTestVehicle,
           VehMixedFireDamage,
           VehMixedFrameDamage,
           VehMixedInsuranceLoss,
           VINDecodeVIN,
           VINDecodeYear,
           VINDecodeMFG,
           VINDecodeMFGCode,
           VINDecodeModel,
           VINDecodeSeriesCode,
           VINDecodeBody,
           VINDecodeEngine,
           VINDecodeCountry,
           VINDecodeResultCode,
           VINDecodeResultMessage,
           VINDecodeClass,
           ScoreOwnerCount,
           ScoreAge,
           ScoreScore,
           ScoreCompareScoreRangeHigh,
           ScoreCompareScoreRangeLow,
           ScorePosScoreFactor1,
           ScorePosScoreFactor2,
           ScoreNegScoreFactor1,
           ScoreNegScoreFactor2,
           ScoreNegScoreFactor3,
           HistoryCount,
           HistoryOdometer,
           HistoryRollback,
           HistoryMixedOdometer,
           HistoryAssured,
           HistoryBBP,
           HistoryLastOdometer,
           HistoryAccidentCount,
           HistoryRecallCount,
           HistoryConditionRPT,
           HistoryRecallDataAvailable,
           HistoryEstimatedAverageMiles
    FROM @passedAccuCheck;


    --Grab only the records with the latest RowLoadedDateTime as those are the most up to date records
    DECLARE @AccuCheckProcess experian.typeAccuCheck;
    INSERT @AccuCheckProcess
    SELECT DISTINCT
        f.RowLoadedDateTime,
        f.RowUpdatedDateTime,
        f.VehMixedVID,
        f.VehMixedIDType,
        f.VehMixedCount,
        f.VehMixedLastState,
        f.VehMixedLastTitle,
        f.VehMixedLastDate,
        f.VehMixedLastOdometer,
        f.VehMixedRollback,
        f.VehMixedSalvage,
        f.VehMixedFailedEmission,
        f.VehMixedDamage,
        f.VehMixedLemon,
        f.VehMixedOdometerProblem,
        f.VehMixedTheft,
        f.VehMixedTheftRecovered,
        f.VehMixedWaterDamage,
        f.VehMixedAbandoned,
        f.VehMixedJunk,
        f.VehMixedRecycled,
        f.VehMixedGreyMarket,
        f.VehMixedRebuilt,
        f.VehMixedCanadianRegistration,
        f.VehMixedTitleRegStorm,
        f.VehMixedRentalFleet,
        f.VehMixedHailDamage,
        f.VehMixedNHTSACrashTestVehicle,
        f.VehMixedFireDamage,
        f.VehMixedFrameDamage,
        f.VehMixedInsuranceLoss,
        f.VINDecodeVIN,
        f.VINDecodeYear,
        f.VINDecodeMFG,
        f.VINDecodeMFGCode,
        f.VINDecodeModel,
        f.VINDecodeSeriesCode,
        f.VINDecodeBody,
        f.VINDecodeEngine,
        f.VINDecodeCountry,
        f.VINDecodeResultCode,
        f.VINDecodeResultMessage,
        f.VINDecodeClass,
        f.ScoreOwnerCount,
        f.ScoreAge,
        f.ScoreScore,
        f.ScoreCompareScoreRangeHigh,
        f.ScoreCompareScoreRangeLow,
        f.ScorePosScoreFactor1,
        f.ScorePosScoreFactor2,
        f.ScoreNegScoreFactor1,
        f.ScoreNegScoreFactor2,
        f.ScoreNegScoreFactor3,
        f.HistoryCount,
        f.HistoryOdometer,
        f.HistoryRollback,
        f.HistoryMixedOdometer,
        f.HistoryAssured,
        f.HistoryBBP,
        f.HistoryLastOdometer,
        f.HistoryAccidentCount,
        f.HistoryRecallCount,
        f.HistoryConditionRPT,
        f.HistoryRecallDataAvailable,
        f.HistoryEstimatedAverageMiles
    FROM @AccuCheck f
        JOIN
         (
             SELECT m.VINDecodeVIN
             FROM @AccuCheck m
         ) t
            ON f.VINDecodeVIN = t.VINDecodeVIN

    --UPSERT Feed records into experian.tblAccuCheck
    MERGE experian.tblAccuCheck AS target
    USING
    (
        SELECT RowLoadedDateTime,
               RowUpdatedDateTime,
               VehMixedVID,
               VehMixedIDType,
               VehMixedCount,
               VehMixedLastState,
               VehMixedLastTitle,
               VehMixedLastDate,
               VehMixedLastOdometer,
               VehMixedRollback,
               VehMixedSalvage,
               VehMixedFailedEmission,
               VehMixedDamage,
               VehMixedLemon,
               VehMixedOdometerProblem,
               VehMixedTheft,
               VehMixedTheftRecovered,
               VehMixedWaterDamage,
               VehMixedAbandoned,
               VehMixedJunk,
               VehMixedRecycled,
               VehMixedGreyMarket,
               VehMixedRebuilt,
               VehMixedCanadianRegistration,
               VehMixedTitleRegStorm,
               VehMixedRentalFleet,
               VehMixedHailDamage,
               VehMixedNHTSACrashTestVehicle,
               VehMixedFireDamage,
               VehMixedFrameDamage,
               VehMixedInsuranceLoss,
               VINDecodeVIN,
               VINDecodeYear,
               VINDecodeMFG,
               VINDecodeMFGCode,
               VINDecodeModel,
               VINDecodeSeriesCode,
               VINDecodeBody,
               VINDecodeEngine,
               VINDecodeCountry,
               VINDecodeResultCode,
               VINDecodeResultMessage,
               VINDecodeClass,
               ScoreOwnerCount,
               ScoreAge,
               ScoreScore,
               ScoreCompareScoreRangeHigh,
               ScoreCompareScoreRangeLow,
               ScorePosScoreFactor1,
               ScorePosScoreFactor2,
               ScoreNegScoreFactor1,
               ScoreNegScoreFactor2,
               ScoreNegScoreFactor3,
               HistoryCount,
               HistoryOdometer,
               HistoryRollback,
               HistoryMixedOdometer,
               HistoryAssured,
               HistoryBBP,
               HistoryLastOdometer,
               HistoryAccidentCount,
               HistoryRecallCount,
               HistoryConditionRPT,
               HistoryRecallDataAvailable,
               HistoryEstimatedAverageMiles
        FROM @AccuCheckProcess
    ) AS source
    ON target.VINDecodeVIN = source.VINDecodeVIN
    WHEN MATCHED THEN
        UPDATE SET RowUpdatedDateTime = SYSDATETIME(),
		    VehMixedVID = ISNULL(source.VehMixedVID, target.VehMixedVID),
            VehMixedIDType = ISNULL(source.VehMixedIDType, target.VehMixedIDType),
            VehMixedCount = ISNULL(source.VehMixedCount, target.VehMixedCount),
            [VehMixedLastState] = ISNULL(
                                   source.[VehMixedLastState],
                                   target.[VehMixedLastState]
                                     ),
            [VehMixedLastTitle] = ISNULL(
                                 source.[VehMixedLastTitle], target.[VehMixedLastTitle]
                                   ),
            [VehMixedLastDate] = ISNULL(source.[VehMixedLastDate], target.[VehMixedLastDate]),
            [VehMixedLastOdometer] = ISNULL(
                                  source.[VehMixedLastOdometer],
                                  target.[VehMixedLastOdometer]
                                    ),
            [VehMixedRollback] = ISNULL(source.[VehMixedRollback], target.[VehMixedRollback]),
            [VehMixedSalvage] = ISNULL(source.[VehMixedSalvage], target.[VehMixedSalvage]),
            [VehMixedFailedEmission] = ISNULL(source.[VehMixedFailedEmission], target.[VehMixedFailedEmission]),
            [VehMixedDamage] = ISNULL(source.[VehMixedDamage], target.[VehMixedDamage]),
            [VehMixedLemon] = ISNULL(source.[VehMixedLemon], target.[VehMixedLemon]),
            [VehMixedOdometerProblem] = ISNULL(source.[VehMixedOdometerProblem], target.[VehMixedOdometerProblem]),
            [VehMixedTheft] = ISNULL(source.[VehMixedTheft], target.[VehMixedTheft]),
            [VehMixedTheftRecovered] = ISNULL(source.[VehMixedTheftRecovered], target.[VehMixedTheftRecovered]),
            [VehMixedWaterDamage] = ISNULL(source.[VehMixedWaterDamage], target.[VehMixedWaterDamage]),
            [VehMixedAbandoned] = ISNULL(
                                     source.[VehMixedAbandoned],
                                     target.[VehMixedAbandoned]
                                       ),
            [VehMixedJunk] = ISNULL(source.[VehMixedJunk], target.[VehMixedJunk]),
            [VehMixedRecycled] = ISNULL(source.[VehMixedRecycled], target.[VehMixedRecycled]),
            [VehMixedGreyMarket] = ISNULL(source.[VehMixedGreyMarket], target.[VehMixedGreyMarket]),
            [VehMixedRebuilt] = ISNULL(source.[VehMixedRebuilt], target.[VehMixedRebuilt]),
            [VehMixedCanadianRegistration] = ISNULL(source.[VehMixedCanadianRegistration], target.[VehMixedCanadianRegistration]),
            [VehMixedTitleRegStorm] = ISNULL(source.[VehMixedTitleRegStorm], target.[VehMixedTitleRegStorm]),
            [VehMixedRentalFleet] = ISNULL(source.[VehMixedRentalFleet], target.[VehMixedRentalFleet]),
            [VehMixedHailDamage] = ISNULL(source.[VehMixedHailDamage], target.[VehMixedHailDamage]),
            [VehMixedNHTSACrashTestVehicle] = ISNULL(source.[VehMixedNHTSACrashTestVehicle], target.[VehMixedNHTSACrashTestVehicle]),
            [VehMixedFireDamage] = ISNULL(source.[VehMixedFireDamage], target.[VehMixedFireDamage]),
            [VehMixedFrameDamage] = ISNULL(source.[VehMixedFrameDamage], target.[VehMixedFrameDamage]),
            [VehMixedInsuranceLoss] = ISNULL(source.[VehMixedInsuranceLoss], target.[VehMixedInsuranceLoss]),
            [VINDecodeVIN] = ISNULL(source.[VINDecodeVIN], target.[VINDecodeVIN]),
            [VINDecodeYear] = ISNULL(source.[VINDecodeYear], target.[VINDecodeYear]),
            [VINDecodeMFG] = ISNULL(source.[VINDecodeMFG], target.[VINDecodeMFG]),
            [VINDecodeMFGCode] = ISNULL(source.[VINDecodeMFGCode], target.[VINDecodeMFGCode]),
            [VINDecodeModel] = ISNULL(source.[VINDecodeModel], target.[VINDecodeModel]),
            [VINDecodeSeriesCode] = ISNULL(source.[VINDecodeSeriesCode], target.[VINDecodeSeriesCode]),
            [VINDecodeBody] = ISNULL(source.[VINDecodeBody], target.[VINDecodeBody]),
            [VINDecodeEngine] = ISNULL(source.[VINDecodeEngine], target.[VINDecodeEngine]),
            [VINDecodeCountry] = ISNULL(source.[VINDecodeCountry], target.[VINDecodeCountry]),
            [VINDecodeResultCode] = ISNULL(source.[VINDecodeResultCode], target.[VINDecodeResultCode]),
            [VINDecodeResultMessage] = ISNULL(
                                           source.[VINDecodeResultMessage],
                                           target.[VINDecodeResultMessage]
                                             ),
            [VINDecodeClass] = ISNULL(source.[VINDecodeClass], target.[VINDecodeClass]),
            [ScoreOwnerCount] = ISNULL(source.[ScoreOwnerCount], target.[ScoreOwnerCount]),
            [ScoreAge] = ISNULL(source.[ScoreAge], target.[ScoreAge]),
            [ScoreScore] = ISNULL(
                                 source.[ScoreScore], target.[ScoreScore]
                                   ),
            [ScoreCompareScoreRangeHigh] = ISNULL(source.[ScoreCompareScoreRangeHigh], target.[ScoreCompareScoreRangeHigh]),
            [ScoreCompareScoreRangeLow] = ISNULL(source.[ScoreCompareScoreRangeLow], target.[ScoreCompareScoreRangeLow]),
            [ScorePosScoreFactor1] = ISNULL(source.[ScorePosScoreFactor1], target.[ScorePosScoreFactor1]),
            [ScorePosScoreFactor2] = ISNULL(source.[ScorePosScoreFactor2], target.[ScorePosScoreFactor2]),
            [ScoreNegScoreFactor1] = ISNULL(source.[ScoreNegScoreFactor1], target.[ScoreNegScoreFactor1]),
            [ScoreNegScoreFactor2] = ISNULL(source.[ScoreNegScoreFactor2], target.[ScoreNegScoreFactor2]),
            [ScoreNegScoreFactor3] = ISNULL(
                                  source.[ScoreNegScoreFactor3],
                                  target.[ScoreNegScoreFactor3]
                                    ),
            [HistoryCount] = ISNULL(source.[HistoryCount], target.[HistoryCount]),
            [HistoryOdometer] = ISNULL(source.[HistoryOdometer], target.[HistoryOdometer]),
            [HistoryRollback] = ISNULL(source.[HistoryRollback], target.[HistoryRollback]),
            [HistoryMixedOdometer] = ISNULL(
                                 source.[HistoryMixedOdometer], target.[HistoryMixedOdometer]
                                   ),
            [HistoryAssured] = ISNULL(source.[HistoryAssured], target.[HistoryAssured]),
            [HistoryBBP] = ISNULL(source.[HistoryBBP], target.[HistoryBBP]),
            [HistoryLastOdometer] = ISNULL(source.[HistoryLastOdometer], target.[HistoryLastOdometer]),
            [HistoryAccidentCount] = ISNULL(source.[HistoryAccidentCount], target.[HistoryAccidentCount]),
            [HistoryRecallCount] = ISNULL(source.[HistoryRecallCount], target.[HistoryRecallCount]),
            [HistoryConditionRPT] = ISNULL(source.[HistoryConditionRPT], target.[HistoryConditionRPT]),
            [HistoryRecallDataAvailable] = ISNULL(source.[HistoryRecallDataAvailable], target.[HistoryRecallDataAvailable]),
            [HistoryEstimatedAverageMiles] = ISNULL(source.[HistoryEstimatedAverageMiles], target.[HistoryEstimatedAverageMiles])
    WHEN NOT MATCHED THEN
        INSERT
        (
		   [VehMixedVID]
		  ,[VehMixedIDType]
		  ,[VehMixedCount]
		  ,[VehMixedLastState]
		  ,[VehMixedLastTitle]
		  ,[VehMixedLastDate]
		  ,[VehMixedLastOdometer]
		  ,[VehMixedRollback]
		  ,[VehMixedSalvage]
		  ,[VehMixedFailedEmission]
		  ,[VehMixedDamage]
		  ,[VehMixedLemon]
		  ,[VehMixedOdometerProblem]
		  ,[VehMixedTheft]
		  ,[VehMixedTheftRecovered]
		  ,[VehMixedWaterDamage]
		  ,[VehMixedAbandoned]
		  ,[VehMixedJunk]
		  ,[VehMixedRecycled]
		  ,[VehMixedGreyMarket]
		  ,[VehMixedRebuilt]
		  ,[VehMixedCanadianRegistration]
		  ,[VehMixedTitleRegStorm]
		  ,[VehMixedRentalFleet]
		  ,[VehMixedHailDamage]
		  ,[VehMixedNHTSACrashTestVehicle]
		  ,[VehMixedFireDamage]
		  ,[VehMixedFrameDamage]
		  ,[VehMixedInsuranceLoss]
		  ,[VINDecodeVIN]
		  ,[VINDecodeYear]
		  ,[VINDecodeMFG]
		  ,[VINDecodeMFGCode]
		  ,[VINDecodeModel]
		  ,[VINDecodeSeriesCode]
		  ,[VINDecodeBody]
		  ,[VINDecodeEngine]
		  ,[VINDecodeCountry]
		  ,[VINDecodeResultCode]
		  ,[VINDecodeResultMessage]
		  ,[VINDecodeClass]
		  ,[ScoreOwnerCount]
		  ,[ScoreAge]
		  ,[ScoreScore]
		  ,[ScoreCompareScoreRangeHigh]
		  ,[ScoreCompareScoreRangeLow]
		  ,[ScorePosScoreFactor1]
		  ,[ScorePosScoreFactor2]
		  ,[ScoreNegScoreFactor1]
		  ,[ScoreNegScoreFactor2]
		  ,[ScoreNegScoreFactor3]
		  ,[HistoryCount]
		  ,[HistoryOdometer]
		  ,[HistoryRollback]
		  ,[HistoryMixedOdometer]
		  ,[HistoryAssured]
		  ,[HistoryBBP]
		  ,[HistoryLastOdometer]
		  ,[HistoryAccidentCount]
		  ,[HistoryRecallCount]
		  ,[HistoryConditionRPT]
		  ,[HistoryRecallDataAvailable]
		  ,[HistoryEstimatedAverageMiles]
        )
        VALUES
        (  
			source.[VehMixedVID]
			,source.[VehMixedIDType]
			,source.[VehMixedCount]
			,source.[VehMixedLastState]
			,source.[VehMixedLastTitle]
			,source.[VehMixedLastDate]
			,source.[VehMixedLastOdometer]
			,source.[VehMixedRollback]
			,source.[VehMixedSalvage]
			,source.[VehMixedFailedEmission]
			,source.[VehMixedDamage]
			,source.[VehMixedLemon]
			,source.[VehMixedOdometerProblem]
			,source.[VehMixedTheft]
			,source.[VehMixedTheftRecovered]
			,source.[VehMixedWaterDamage]
			,source.[VehMixedAbandoned]
			,source.[VehMixedJunk]
			,source.[VehMixedRecycled]
			,source.[VehMixedGreyMarket]
			,source.[VehMixedRebuilt]
			,source.[VehMixedCanadianRegistration]
			,source.[VehMixedTitleRegStorm]
			,source.[VehMixedRentalFleet]
			,source.[VehMixedHailDamage]
			,source.[VehMixedNHTSACrashTestVehicle]
			,source.[VehMixedFireDamage]
			,source.[VehMixedFrameDamage]
			,source.[VehMixedInsuranceLoss]
			,source.[VINDecodeVIN]
			,source.[VINDecodeYear]
			,source.[VINDecodeMFG]
			,source.[VINDecodeMFGCode]
			,source.[VINDecodeModel]
			,source.[VINDecodeSeriesCode]
			,source.[VINDecodeBody]
			,source.[VINDecodeEngine]
			,source.[VINDecodeCountry]
			,source.[VINDecodeResultCode]
			,source.[VINDecodeResultMessage]
			,source.[VINDecodeClass]
			,source.[ScoreOwnerCount]
			,source.[ScoreAge]
			,source.[ScoreScore]
			,source.[ScoreCompareScoreRangeHigh]
			,source.[ScoreCompareScoreRangeLow]
			,source.[ScorePosScoreFactor1]
			,source.[ScorePosScoreFactor2]
			,source.[ScoreNegScoreFactor1]
			,source.[ScoreNegScoreFactor2]
			,source.[ScoreNegScoreFactor3]
			,source.[HistoryCount]
			,source.[HistoryOdometer]
			,source.[HistoryRollback]
			,source.[HistoryMixedOdometer]
			,source.[HistoryAssured]
			,source.[HistoryBBP]
			,source.[HistoryLastOdometer]
			,source.[HistoryAccidentCount]
			,source.[HistoryRecallCount]
			,source.[HistoryConditionRPT]
			,source.[HistoryRecallDataAvailable]
			,source.[HistoryEstimatedAverageMiles]
        );



/*Begin the deletes from the history table*/

   DELETE acc
   FROM experian.tblAccuCheckHistory acc
	   JOIN @passedAccuCheckIds l ON acc.AccuCheckID = l.AccuCheckID;

/*Begin the inserts into the history table*/

/*Prevent parameter sniffing*/
DECLARE @AccuCheckHistory experian.typeAccuCheckHistory
INSERT @AccuCheckHistory
SELECT VIN,
       RowLoadedDateTime,
       RowUpdatedDateTime,
       AccuCheckID,
       AccidentSeqNum,
       ActCode,
       [Case],
       Type,
       Date,
       Category,
       CheckListGrp,
       Odometer,
       OriginalIncidentReportedDate,
       ORU,
       City,
       UOM,
       State,
       FileID,
       FileSource,
       FileType,
       Title,
       Lease,
       Lien,
       TitleRegStorm,
       Color,
       URL,
       URLLink,
       RecallCode,
       RecallTxt,
       RecallLinkTxt,
       RecallURL,
       OrgName,
       Phone
FROM @passedAccuCheckHistory

INSERT INTO experian.tblAccuCheckHistory
(
    RowLoadedDateTime,
    RowUpdatedDateTime,
    AccuCheckID,
    AccidentSeqNum,
    ActCode,
    [Case],
    Type,
    Date,
    Category,
    CheckListGrp,
    Odometer,
    OriginalIncidentReportedDate,
    ORU,
    City,
    UOM,
    State,
    FileID,
    FileSource,
    FileType,
    Title,
    Lease,
    Lien,
    TitleRegStorm,
    Color,
    URL,
    URLLink,
    RecallCode,
    RecallTxt,
    RecallLinkTxt,
    RecallURL,
    OrgName,
    Phone
)
SELECT 
       acch.RowLoadedDateTime,
       acch.RowUpdatedDateTime,
       acc.AccuCheckID,
       acch.AccidentSeqNum,
       acch.ActCode,
       acch.[Case],
       acch.Type,
       acch.Date,
       acch.Category,
       acch.CheckListGrp,
       acch.Odometer,
       acch.OriginalIncidentReportedDate,
       acch.ORU,
       acch.City,
       acch.UOM,
       acch.State,
       acch.FileID,
       acch.FileSource,
       acch.FileType,
       acch.Title,
       acch.Lease,
       acch.Lien,
       acch.TitleRegStorm,
       acch.Color,
       acch.URL,
       acch.URLLink,
       acch.RecallCode,
       acch.RecallTxt,
       acch.RecallLinkTxt,
       acch.RecallURL,
       acch.OrgName,
       acch.Phone
FROM @AccuCheckHistory acch
   JOIN experian.tblAccuCheck acc ON acch.VIN = acc.VINDecodeVIN;
	
-- @TranCount = 0 means no transaction was started before the procedure was called.
-- The procedure must commit the transaction it started.
IF @TranCount = 0
   COMMIT TRANSACTION;

END TRY

/*------------------------------------------------------
Special catch logic only good for CUD type procedures
Because it does contains rollback code.
------------------------------------------------------*/
BEGIN CATCH
    DECLARE 
        @ErrorNumber     INT,
        @ErrorSeverity   INT,
        @ErrorState      INT,
        @ErrorLine       INT,
        @ErrorProcedure  NVARCHAR(200),
        @ErrorMessage    VARCHAR(4000),
        @XactState       INT,
        @CurrTranCount   INT;

    -- Get the state of the existing transaction so we can tell what type of rollback needs to occur
    --    If 1, the transaction is committable.  
    --    If -1, the transaction is uncommittable and should   
    --        be rolled back.  
    --    XACT_STATE = 0 means that there is no transaction and  
    --        a commit or rollback operation would generate an error. 
    SET @XactState = XACT_STATE();

    -- Get the current transaction count 
    -- It is possible for the @TranCount value to be set, but a transaction to not be opened 
    --    when an error occurs. When this happens, we cannot call the rollback statement as there is no
    --    transaction to rollback. An example of this is when the executing account does not have
    --    permissions to the underlying objects, but does have authorization to execute the procedure.  
    SET @CurrTranCount = @@TRANCOUNT;

    -- @TranCount = 0 means no transaction was started before the procedure was called.
    -- The procedure must rollback the transaction it started.
    IF @TranCount = 0 AND @CurrTranCount > 0
       ROLLBACK TRANSACTION;
    ELSE
       -- If the state of the transaction is stable, then rollback just the current save point work
       IF @XactState <> -1 AND @CurrTranCount > 0
            ROLLBACK TRANSACTION stpIUAccuCheck;

    -- Assign variables to error-handling functions that capture information for RAISERROR.
    SELECT 
        @ErrorNumber = ERROR_NUMBER(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE(),
        @ErrorLine = ERROR_LINE(),
        @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');

    -- Building the message string that will contain original error information.
    SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, ' + 
                           N'Message: '+ ERROR_MESSAGE();
            
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

    RETURN -1;

END CATCH;
END;