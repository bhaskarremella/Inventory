﻿CREATE TABLE [dbo].[tblVehicleAnalyticData] (
    [VehicleAnalyticDataID]          BIGINT        IDENTITY (1, 1) NOT NULL,
    [WarningCount]                   BIGINT        NULL,
    [ErrorCount]                     BIGINT        NULL,
    [MessageList]                    VARCHAR (MAX) NULL,
    [TokenExpirationMinutes]         BIGINT        NULL,
    [RecordCount]                    BIGINT        NULL,
    [PageCount]                      BIGINT        NULL,
    [InputUvc]                       BIGINT        NULL,
    [InputZipcode]                   BIGINT        NULL,
    [InputMinimumMileage]            BIGINT        NULL,
    [InputMaximumMileage]            BIGINT        NULL,
    [InputRadiusMiles]               BIGINT        NULL,
    [InputInState]                   INT           NULL,
    [InputListingType]               VARCHAR (MAX) NULL,
    [InputAllTrims]                  INT           NULL,
    [InputDuplicateVins]             INT           NULL,
    [InputDayRange]                  BIGINT        NULL,
    [InputPriceAnalysis]             INT           NULL,
    [InputListingsPerPage]           BIGINT        NULL,
    [InputPageNumber]                BIGINT        NULL,
    [EffectiveUvc]                   BIGINT        NULL,
    [EffectiveZipcode]               BIGINT        NULL,
    [EffectiveMinimumMileage]        BIGINT        NULL,
    [EffectiveMaximumMileage]        BIGINT        NULL,
    [EffectiveRadiusMiles]           BIGINT        NULL,
    [EffectiveInState]               INT           NULL,
    [EffectiveListingType]           VARCHAR (MAX) NULL,
    [EffectiveAllTrims]              INT           NULL,
    [EffectiveDuplicateVins]         INT           NULL,
    [EffectiveDayRange]              BIGINT        NULL,
    [EffectivePriceAnalysis]         INT           NULL,
    [EffectiveListingsPerPage]       BIGINT        NULL,
    [EffectivePageNumber]            BIGINT        NULL,
    [ParametersUvc]                  BIGINT        NULL,
    [ParametersZipcode]              BIGINT        NULL,
    [ParametersMinimumMileage]       BIGINT        NULL,
    [ParametersMaximumMileage]       BIGINT        NULL,
    [ParametersRadiusMiles]          BIGINT        NULL,
    [ParametersInState]              INT           NULL,
    [ParametersListingType]          VARCHAR (MAX) NULL,
    [ParametersAllTrims]             INT           NULL,
    [ParametersDuplicateVins]        INT           NULL,
    [ParametersDayRange]             BIGINT        NULL,
    [ParametersPriceAnalysis]        INT           NULL,
    [ParametersListingsPerPage]      BIGINT        NULL,
    [ParametersPageNumber]           BIGINT        NULL,
    [VehicleCount]                   BIGINT        NULL,
    [ActiveStatisticsVehicleCount]   BIGINT        NULL,
    [ActiveStatisticsMinimumPrice]   BIGINT        NULL,
    [ActiveStatisticsMaximumPrice]   BIGINT        NULL,
    [ActiveStatisticsMeanPrice]      BIGINT        NULL,
    [ActiveStatisticsMedianPrice]    BIGINT        NULL,
    [ActiveStatisticsMinimumMileage] BIGINT        NULL,
    [ActiveStatisticsMaximumMileage] BIGINT        NULL,
    [ActiveStatisticsMeanMileage]    BIGINT        NULL,
    [SoldStatisticsVehicleCount]     BIGINT        NULL,
    [SoldStatisticsMinimumPrice]     BIGINT        NULL,
    [SoldStatisticsMaximumPrice]     BIGINT        NULL,
    [SoldStatisticsMeanPrice]        BIGINT        NULL,
    [SoldStatisticsMedianPrice]      BIGINT        NULL,
    [SoldStatisticsMinimumMileage]   BIGINT        NULL,
    [SoldStatisticsMaximumMileage]   BIGINT        NULL,
    [SoldStatisticsMeanMileage]      BIGINT        NULL,
    CONSTRAINT [PK_tblVehicleAnalyticData_VehicleAnalyticDataID] PRIMARY KEY CLUSTERED ([VehicleAnalyticDataID] ASC) WITH (FILLFACTOR = 90)
);

