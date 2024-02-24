# Sample script to get milestones from batch deployments
# The script will limit the output to only deployments that started after the first client in the batch
#
# Note: Change line 8-18 to match your environment. For example "Report Finish Time" was just a dummy action I added to the end of my TS.
#

# Export File
$ExportPath = "E:\Setup\BatchDeploymentMilestones.csv"

# Database Info
$DatabaseServer= "CM01"
$Database = "CM_PS1"

# Batch Info
$TaskSequenceName = "Windows 10 Enterprise x64 22H2 - MDM - 2Pint"
$FirstClientInBatch = "C007-001"
$FirstActionToLookFor = "MEASURE POINT 1"
$LastActionToLookFor = "Report Finish Time" # Used for duration calucation later

# SQL Query for Batch Start Time (borrowed from first client in batch)
$BatchStartTimeQuery = $("
SELECT
       TOP 1 vTS.ExecutionTime
FROM
       v_TaskExecutionStatus AS vTS
       LEFT JOIN v_R_System VRS ON vTS.ResourceID = VRS.ResourceID
       LEFT JOIN v_Advertisement vADV ON vTS.AdvertisementID = vADV.AdvertisementID
       LEFT JOIN v_TaskSequencePackage vTSP ON vADV.Priority = vTSP.Priority
WHERE
       vTSP.Name = '$TaskSequenceName'
       AND ActionName = '$FirstActionToLookFor'
	   AND vRS.Name0 =  '$FirstClientInBatch'
ORDER BY vTS.ExecutionTime DESC
")

# Run Batch Start Time SQL Query, will be used as filter later
$Datatable = New-Object System.Data.DataTable
$Connection = New-Object System.Data.SQLClient.SQLConnection
$Connection.ConnectionString = "server='$DatabaseServer';database='$Database';trusted_connection=true;"
$Connection.Open()
$Command = New-Object System.Data.SQLClient.SQLCommand
$Command.Connection = $Connection
$Command.CommandText = $BatchStartTimeQuery
$Reader = $Command.ExecuteReader()
$Datatable.Load($Reader)
$Connection.Close()

# Since Batch Start Time SQL Query only returns one entry, I'm cheating...:)
$BatchStartTime = $Datatable.Rows.ExecutionTime

# Reduce Batch Start Time with 5 minutes in case the first client started, wasn't the one that started the task sequence first.
$BatchStartTime =  $BatchStartTime.AddMinutes(-5)

# SQl Query to get Batch Deployment Milestones
$BatchDeploymentQuery = $("
Select
       vTS.ActionName,
       vTS.ExecutionTime,
       vRS.Name0
From
       v_TaskExecutionStatus as vTS
       LEFT JOIN v_R_System VRS ON vTS.ResourceID = VRS.ResourceID
       LEFT JOIN v_Advertisement vADV on vTS.AdvertisementID = vADV.AdvertisementID
       LEFT JOIN v_TaskSequencePackage vTSP on vADV.Priority = vTSP.Priority
WHERE
       vTSP.Name = '$TaskSequenceName'
	   AND vTS.ExecutionTime >= '$BatchStartTime'
ORDER BY vRS.Name0
")


# Run Batch Deployment Milestone Query
$Datatable = New-Object System.Data.DataTable
$Connection = New-Object System.Data.SQLClient.SQLConnection
$Connection.ConnectionString = "server='$DatabaseServer';database='$Database';trusted_connection=true;"
$Connection.Open()
$Command = New-Object System.Data.SQLClient.SQLCommand
$Command.Connection = $Connection
$Command.CommandText = $BatchDeploymentQuery
$Reader = $Command.ExecuteReader()
$Datatable.Load($Reader)
$Connection.Close()

# Get Batch Deployment Info
[System.Collections.ArrayList]$BatchDeploymentMilestones = @()
Foreach ($Row in $Datatable){

    $obj = [PSCustomObject]@{

        # Add values to arraylist
        ActionName = ($row.ActionName)
        ExecutionTime = ($row.ExecutionTime) 
        ComputerName = ($row.Name0)
        Duration = ""
    }

    # Add all the values
    $BatchDeploymentMilestones.Add($obj)|Out-Null
       
}

# Calculate deployment duration per machine (only if machine reached last milestone)

# Get unique computernames from array
$Computers = $BatchDeploymentMilestones | Select-Object ComputerName | Get-Unique -AsString 

foreach ($Computer in $Computers){
    
    $FirstAction = $BatchDeploymentMilestones | Where {($_.ComputerName -eq $Computer.ComputerName) -And ($_.ActionName -eq $FirstActionToLookFor)}
    $LastAction = $BatchDeploymentMilestones | Where {($_.ComputerName -eq $Computer.ComputerName) -And ($_.ActionName -eq $LastActionToLookFor)}

    # Check for entries with both first and last action, and calculate the duration
    If ($FirstAction -And $LastAction){
        
        # Calculate duration
        $Duration = New-TimeSpan –Start $FirstAction.ExecutionTime –End $LastAction.ExecutionTime

        # Update array with duration value in hour, and minutes
        $LastAction.Duration = "$($Duration.Hours) hours, $($Duration.Minutes) minutes"

    }

}

# Export to CSV File
$BatchDeploymentMilestones | Export-Csv -Path $ExportPath -NoTypeInformation

# Display total batch runtime, from first time entry to last
$FirstEntry = $BatchDeploymentMilestones | Sort-Object ExecutionTime | Select -First 1
$LastEntry = $BatchDeploymentMilestones | Sort-Object ExecutionTime | Select -Last 1
$Duration = New-TimeSpan –Start $FirstEntry.ExecutionTime –End $LastEntry.ExecutionTime

Write-host "First time stamp, in UTC: $($FirstEntry.ExecutionTime)"
Write-host "Last time stamp, in UTC: $($LastEntry.ExecutionTime)"
Write-host ""
Write-host "Total batch task sequence runtime is: $($Duration.Hours) hours, $($Duration.Minutes) minutes"
