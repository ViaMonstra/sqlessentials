SELECT DISTINCT SYS.Netbios_Name0, SYSIP.IP_Addresses0 
    FROM v_R_System SYS INNER JOIN v_RA_System_IPAddresses SYSIP 
    ON SYS.ResourceID = SYSIP.ResourceID 
    ORDER BY SYS.Netbios_Name0

SELECT DISTINCT SYS.Netbios_Name0, LD.FreeSpace0 
    FROM v_R_System SYS INNER JOIN v_GS_LOGICAL_DISK LD 
    ON SYS.ResourceID = LD.ResourceID 
    WHERE LD.Description0 LIKE 'Local fixed disk' 
    ORDER BY LD.FreeSpace0

SELECT DISTINCT SYS.Netbios_Name0, FCM.Domain, SYSIP.IP_Addresses0 
    FROM v_R_System SYS INNER JOIN v_FullCollectionMembership FCM 
    ON SYS.ResourceID = FCM.ResourceID 
    INNER JOIN v_RA_System_IPAddresses SYSIP 
    ON SYS.ResourceID = SYSIP.ResourceID 
    WHERE FCM.CollectionID = 'SMS00001' 
    ORDER BY SYS.Netbios_Name0

SELECT
vrs.Name0 as 'ComputerName',
vrs.Client0 as 'Client',
vrs.Operating_System_Name_and0 as 'Operating System',
Vad.AgentTime as 'LastHeartBeatTime'
FROM v_R_System as Vrs
inner join v_AgentDiscoveries as Vad on Vrs.ResourceID=Vad.ResourceId
WHERE vad.AgentName like '%Heartbeat Discovery'
