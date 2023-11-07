Select * from v_ADD_REMOVE_PROGRAMS

Select ARP.ResourceID
From v_ADD_REMOVE_PROGRAMS ARP
Where ARP.DisplayName0= 'PuTTY'

Select R.Name0, ARP.ResourceID
From v_ADD_REMOVE_PROGRAMS ARP
Inner Join v_R_System R on ARP.ResourceID = R.ResourceID
Where ARP.DisplayName0= 'PuTTY'

Select R.Name0
From dbo.v_R_System R
Where R.ResourceID not in
	(
	Select ARP.ResourceID
	From v_ADD_REMOVE_PROGRAMS ARP
	Where ARP.DisplayName0= 'PuTTY'
	)
