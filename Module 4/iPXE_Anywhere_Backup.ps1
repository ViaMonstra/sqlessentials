# Script for iPXE Anywhere Backup

# Location Data path - please edit these to reflect the correct path to the installation/data folder
$ts = $(get-date -f MMddyyyy)+$(get-date -f HHmmss)
$MainBackupPath = "E:\2Pint_Backup\iPXE_Anywhere_Backup"
$BackupPath = "$MainBackupPath\iPXEAnywhereBackup.$ts.bak"
$2PXEConfigPath = "C:\Program Files\2Pint Software\2PXE\2Pint.2PXE.Service.exe.config"
$WSEConfigPath = "C:\Program Files\2Pint Software\iPXE AnywhereWS\iPXEAnywhere.Service.exe.config"

# Archive locations (local and remote)
$2PintBackupArchive = "E:\2Pint_Backup_Archive"
$RemoteDestination = "\\corp.viamonstra.com\fs1\Backup\2Pint"

$LogFile = "E:\2Pint_Maintenance\Logs\iPXEAnywhere_Backup.log"

Write-Log "Backing up iPXE Database and Configuration"

Function Write-Log{
	param (
    [Parameter(Mandatory = $true)]
    [string]$Message
   )

   $TimeGenerated = $(Get-Date -UFormat "%D %T")
   $Line = "$TimeGenerated : $Message"
   Add-Content -Value $Line -Path $LogFile -Encoding Ascii

}

#--------------------------------
###Take a backup
#--------------------------------

# First, create the backup folders
If (!(Test-Path $BackupPath\iPXEAnywhereSQLBackup)){New-Item -ItemType Directory -Force -Path $BackupPath\iPXEAnywhereSQLBackup}
If (!(Test-Path $2PintBackupArchive)){New-Item -ItemType Directory -Force -Path $2PintBackupArchive}

# iPXE Anywhere WS Database Backup
$BackupFile = "iPXEAnywhere.bak"
Backup-SqlDatabase -ServerInstance "DP01\SQLEXPRESS" -Database "iPXEAnywhere35" -BackupFile $BackupPath\iPXEAnywhereSQLBackup\$BackupFile

# Backup the 2PXE Server configuration XML
If (Test-Path $2PXEConfigPath) {copy-item $2PXEConfigPath $BackupPath -Force}

# Backup the WS configuration XML
If (Test-Path $WSEConfigPath) {copy-item $WSEConfigPath $BackupPath -Force}

# Remove backup folders older than three days
$maxDaystoKeep = -3
$itemsToDelete = Get-ChildItem $MainBackupPath -Directory *.bak | Where LastWriteTime -lt ((get-date).AddDays($maxDaystoKeep))

if ($itemsToDelete.Count -gt 0){
    ForEach ($item in $itemsToDelete){
        Write-Log "$($item.Name) is older than $((get-date).AddDays($maxDaystoKeep)) and will be deleted" 
        Remove-Item $item.FullName -Recurse -Force
        
    }
}
else{
    Write-Log "No items to be deleted today $($(Get-Date).DateTime)" 
    }

Write-Output "Cleanup of backups older than $((get-date).AddDays($maxDaystoKeep)) completed..."


# Zip the iPXE Anywhere  Backup to the I:\2Pint_Backup_Archive folder
$iPXEAnywhereBackupSource = (Get-ChildItem -Path $MainBackupPath -Filter "*.bak" | Sort-Object LastWriteTime | Select -Last 1).FullName
$iPXEAnywhereBackupName = "PXEAnywhere_Backup_$(get-date -f yyyy-MM-dd).zip"
$iPXEAnywhereBackupArchiveFile = Join-Path -Path $2PintBackupArchive -ChildPath $iPXEAnywhereBackupName
If(Test-path $iPXEAnywhereBackupArchiveFile) {Remove-item $iPXEAnywhereBackupArchiveFile}
Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::CreateFromDirectory($iPXEAnywhereBackupSource, $iPXEAnywhereBackupArchiveFile)

# Copy the PXE Anywhere Backup Archive to remote file server 
Copy-Item -Path $iPXEAnywhereBackupArchiveFile -Destination $RemoteDestination -Force

# Remove zip archives older than 7 days
$maxDaystoKeep = -7
$itemsToDelete = Get-ChildItem $2PintBackupArchive -Filter "*.zip" | Where LastWriteTime -lt ((get-date).AddDays($maxDaystoKeep))

if ($itemsToDelete.Count -gt 0){
    ForEach ($item in $itemsToDelete){
        Write-Log "$($item.Name) is older than $((get-date).AddDays($maxDaystoKeep)) and will be deleted" 
        Remove-Item $item.FullName -Recurse -Force
        
    }
}
else{
    Write-Log "No items to be deleted today $($(Get-Date).DateTime)"
    }

Write-Output "Cleanup of log files older than $((get-date).AddDays($maxDaystoKeep)) completed..."




