-- Inner AND outer join
SELECT DISTINCT v_R_System.Netbios_Name0 AS [Computer Name], 
    v_UpdateScanStatus.LastScanTime AS [Last Scan], 
    v_UpdateScanStatus.LastWUAVersion AS [WUA Version], 
    v_StateNames.StateName AS [Last Scan State] 
    FROM v_UpdateScanStatus INNER JOIN v_R_System ON 
    v_UpdateScanStatus.ResourceID = v_R_System.ResourceID LEFT OUTER JOIN 
    v_StateNames ON v_UpdateScanStatus.LastScanState = v_StateNames.StateID 
    WHERE (v_StateNames.TopicType = 501)

SELECT DISTINCT SYS.Netbios_Name0, SYSIP.IP_Addresses0 
    FROM v_R_System SYS 
	LEFT Outer JOIN v_RA_System_IPAddresses SYSIP ON SYS.ResourceID = SYSIP.ResourceID 
    ORDER BY SYSIP.IP_Addresses0 
