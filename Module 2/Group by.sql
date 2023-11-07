SELECT Manufacturer0, Model0
FROM v_GS_COMPUTER_SYSTEM

SELECT Manufacturer0, Model0, Count(Model0) AS 'Count'
FROM dbo.v_GS_COMPUTER_SYSTEM
GROUP BY Manufacturer0,Model0
