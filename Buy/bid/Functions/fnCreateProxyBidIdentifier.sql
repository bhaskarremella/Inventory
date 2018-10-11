
CREATE FUNCTION [bid].[fnCreateProxyBidIdentifier] (@ProxyBidID bigint)
RETURNS nvarchar(255)
AS 
BEGIN
	RETURN 'proxyBid:' + CAST(@ProxyBidID AS nvarchar(255));
END 

