CREATE SERVICE [//INV/Buy/TargetService]
    AUTHORIZATION [BuyINVUser]
    ON QUEUE [dbo].[INVBuyQueue];

