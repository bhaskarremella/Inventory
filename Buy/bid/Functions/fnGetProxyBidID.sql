CREATE FUNCTION [bid].[fnGetProxyBidID] (@ProxyBidIdentifier nvarchar(255))
RETURNS bigint
AS 
BEGIN
	DECLARE @findStr nvarchar(255) = 'proxyBid:';
	DECLARE @findIndex int = CHARINDEX(@ProxyBidIdentifier, @findStr);

	IF (@findIndex > 0) BEGIN
		DECLARE @retval bigint = (SELECT CAST(SUBSTRING(@ProxyBidIdentifier, LEN(@findStr), LEN(@ProxyBidIdentifier) - LEN(@findStr)) AS bigint));
		RETURN @retval
	END;

	RETURN NULL
END