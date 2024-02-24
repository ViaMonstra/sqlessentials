[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null
$srv = New-Object Microsoft.SQLServer.Management.Smo.Server($env:COMPUTERNAME)

if ($srv.status) {
    $srv.Configuration.MaxServerMemory.ConfigValue = 10kb
    $srv.Configuration.MinServerMemory.ConfigValue = 8kb   
    $srv.Configuration.Alter()
}

# Show databases
$srv.Databases | select name

$srv.Configuration
