CREATE TABLE [presale].[tblPurgePresaleManheimFeed] (
    [PurgePresaleManheimFeedID] INT      IDENTITY (1, 1) NOT NULL,
    [PartitionRID]              CHAR (1) NULL,
    [PartitionMLID]             CHAR (1) NULL,
    [PartitionMRID]             CHAR (1) NULL,
    [PartitionLID]              CHAR (1) NULL,
    [Count]                     INT      NULL,
    CONSTRAINT [PK_PurgePresaleManheimFeed] PRIMARY KEY CLUSTERED ([PurgePresaleManheimFeedID] ASC) WITH (FILLFACTOR = 90)
);

