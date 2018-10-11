


         CREATE PROCEDURE [dbo].TestPowerApps

         AS
         /**********************************************************************************************************************************************************************
         **
         **    Name:          presale.stpIUManheimFeed
         **
         **    Description:   This proc will take the records passed into the @passedManheimFeed variable from type table presale.typManheimFeed and update or insert records
                              into presale.tblManheimFeed. It will strip out the Images field and upsert those into presale.tblManheimFeedImage. It will also 
                              insert all records into presale.tblManheimFeedTrend.
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
         **    -------------------- -------------------------------------------------------------- -------------------------------------------------------------------------
         **
         **********************************************************************************************************************************************************************/
   
        
SELECT *
  FROM [Buy].[Access].[Vehicle]

