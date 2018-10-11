CREATE REMOTE SERVICE BINDING [DMBuyTargetBinding]
    AUTHORIZATION [dbo]
    TO SERVICE N'//DM/InventoryDM/TargetService'
    WITH USER = [BuyInvDMUser], ANONYMOUS = OFF;

