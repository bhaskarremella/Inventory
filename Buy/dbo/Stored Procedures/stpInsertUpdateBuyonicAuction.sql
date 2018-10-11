



CREATE PROCEDURE [dbo].[stpInsertUpdateBuyonicAuction]
    @in_InsertOrUpdate AS VARCHAR(10) ,
    @in_BuyAuctionHouseTypeID AS BIGINT ,
    @in_LastChangedByEmpID AS VARCHAR(100) ,
    @in_AuctionListKey AS VARCHAR(50) ,
    @in_AuctionListDescription AS VARCHAR(100) ,
    @in_Address AS VARCHAR(50) ,
    @in_City AS VARCHAR(50) ,
    @in_State AS VARCHAR(20) ,
    @in_ZipCode AS VARCHAR(20) ,
    @in_IsActive AS TINYINT ,
    @in_ExternalAuctionID AS VARCHAR(50)






/*----------------------------------------------------------------------------------------
Created By  : Travis Bleile
Created On  : 2018-03-27
Application : Buyonic/Buyonic Inspection
Description : Stored Proc for Updating Buyonic Auction Details



EXEC [dbo].[stpInsertUpdateBuyonicAuction]
------------------------------------------------------------------------------------------
*/
AS
    BEGIN;
        BEGIN TRY;


            DECLARE @InsertOrUpdate AS VARCHAR(10) = @in_InsertOrUpdate ,
                    @BuyAuctionHouseTypeID AS BIGINT = @in_BuyAuctionHouseTypeID ,
                    @LastChangedByEmpID AS VARCHAR(100) = @in_LastChangedByEmpID ,
                    @AuctionListKey AS VARCHAR(50) = @in_AuctionListKey ,
                    @AuctionListDescription AS VARCHAR(100) = @in_AuctionListDescription ,
                    @Address AS VARCHAR(50) = @in_Address ,
                    @City AS VARCHAR(50) = @in_City ,
                    @State AS VARCHAR(20) = @in_State ,
                    @Zipcode AS VARCHAR(20) = @in_ZipCode ,
                    @IsActive AS TINYINT = @in_IsActive ,
                    @ExternalAuctionID AS VARCHAR(50) = @in_ExternalAuctionID;






            /* Insert New Auction */
            IF @InsertOrUpdate = 'Insert'
               AND NOT EXISTS (   SELECT 1
                                  FROM   Buy.dbo.tblBuyAuctionListType
                                  WHERE  AuctionListKey = @AuctionListKey
                                         AND BuyAuctionHouseTypeID = @BuyAuctionHouseTypeID
                              )
                BEGIN

                    INSERT INTO Buy.dbo.tblBuyAuctionListType (   BuyAuctionHouseTypeID ,
                                                                  RowLoadedDateTime ,
                                                                  RowUpdatedDateTime ,
                                                                  LastChangedByEmpID ,
                                                                  AuctionListKey ,
                                                                  AuctionListDescription ,
                                                                  Address ,
                                                                  City ,
                                                                  State ,
                                                                  ZipCode ,
                                                                  IsActive ,
                                                                  ExternalAuctionID
                                                              )
                    VALUES (   @BuyAuctionHouseTypeID ,  -- BuyAuctionHouseTypeID - bigint
                               SYSDATETIME() ,           -- RowLoadedDateTime - datetime2(7)
                               SYSDATETIME() ,           -- RowUpdatedDateTime - datetime2(7)
                               @LastChangedByEmpID ,     -- LastChangedByEmpID - varchar(128)
                               @AuctionListKey ,         -- AuctionListKey - varchar(50)
                               @AuctionListDescription , -- AuctionListDescription - varchar(200)
                               @Address ,                -- Address - varchar(50)
                               @City ,                   -- City - varchar(50)
                               @State ,                  -- State - varchar(20)
                               @Zipcode ,                -- ZipCode - varchar(20)
                               @IsActive ,               -- IsActive - tinyint
                               @ExternalAuctionID        -- ExternalAuctionID - varchar(50)
                           );
                END;

            /* UPDATE Existing Auction */
            IF @InsertOrUpdate = 'Update'
               AND EXISTS (   SELECT 1
                              FROM   Buy.dbo.tblBuyAuctionListType
                              WHERE  AuctionListKey = @AuctionListKey
                                     AND BuyAuctionHouseTypeID = @BuyAuctionHouseTypeID
                          )
                BEGIN

                    UPDATE balt
                    SET    balt.BuyAuctionHouseTypeID = COALESCE(@BuyAuctionHouseTypeID, balt.BuyAuctionHouseTypeID) ,
                           balt.RowUpdatedDateTime = SYSDATETIME() ,
                           balt.LastChangedByEmpID = COALESCE(@LastChangedByEmpID, balt.LastChangedByEmpID) ,
                           balt.AuctionListKey = COALESCE(@AuctionListKey, balt.AuctionListKey) ,
                           balt.AuctionListDescription = COALESCE(@AuctionListDescription, balt.AuctionListDescription) ,
                           balt.Address = COALESCE(@Address, balt.Address) ,
                           balt.City = COALESCE(@City, balt.City) ,
                           balt.State = COALESCE(@State, balt.State) ,
                           balt.ZipCode = COALESCE(@Zipcode, balt.ZipCode) ,
                           balt.IsActive = COALESCE(@IsActive, balt.IsActive) ,
                           balt.ExternalAuctionID = COALESCE(@ExternalAuctionID, balt.ExternalAuctionID)
                    FROM   Buy.dbo.tblBuyAuctionListType balt
                    WHERE  balt.BuyAuctionHouseTypeID = @BuyAuctionHouseTypeID
                           AND balt.AuctionListDescription = @AuctionListDescription;
                END;




        END TRY

        /*------------------------------------------------------
Special catch logic only good for SELECT type procedures
Because it does not contain rollback code.
------------------------------------------------------*/
        BEGIN CATCH
            DECLARE @ErrorNumber INT ,
                    @ErrorSeverity INT ,
                    @ErrorState INT ,
                    @ErrorLine INT ,
                    @ErrorProcedure NVARCHAR(200) ,
                    @ErrorMessage VARCHAR(4000);

            -- Assign variables to error-handling functions that capture information for RAISERROR.
            SELECT @ErrorNumber = ERROR_NUMBER() ,
                   @ErrorSeverity = ERROR_SEVERITY() ,
                   @ErrorState = ERROR_STATE() ,
                   @ErrorLine = ERROR_LINE() ,
                   @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');

            -- Building the message string that will contain original error information.
            SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, '
                                   + 'Message: ' + ERROR_MESSAGE();

            -- Use RAISERROR inside the CATCH block to return error
            -- information about the original error that caused
            -- execution to jump to the CATCH block.
            RAISERROR(   @ErrorMessage ,  -- Message text.
                         16 ,             -- must be 16 for Informatica to pick it up
                         1,
                         @ErrorNumber ,
                         @ErrorSeverity , -- Severity.
                         @ErrorState ,    -- State.
                         @ErrorProcedure,
                         @ErrorLine
                     );

            -- Return a negative number so that if the calling code is using a LINK server, it will
            -- be able to test that the procedure failed.  Without this, there are some lower type of 
            -- errors that do not show up across the LINK as an error.  This causes ProcessControl 
            -- in particular to not see that the procedure failed which is bad.
            RETURN -1;

        END CATCH;
    END;



