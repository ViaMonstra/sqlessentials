DECLARE @TempIpv4 TABLE
(
	IPv4IpAddress varchar(20)
)

INSERT INTO @TempIPv4
SELECT CASE WHEN CHARINDEX(N',',BGB.IPAddress) = 0 THEN BGB.IPAddress
             ELSE SUBSTRING(BGB.IPAddress,1,CHARINDEX(N',',BGB.IPAddress)-1)
        END AS IPv4IpAddress
FROM Bgb_ResStatus as BGB

SELECT * FROM @TempIPv4
