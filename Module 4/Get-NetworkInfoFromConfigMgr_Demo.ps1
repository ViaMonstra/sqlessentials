$SiteServer= "CM01"
$DatabaseServer= "CM01"
$Database = "CM_PS1"

$Query= $("Select BGB.IPAddress, BGB.IPSubnet, R.Name0  from BGB_ResStatus as BGB Inner Join v_R_System as R ON BGB.ResourceID = R.ResourceID")
$ExportPath = "E:\temp\AllNetworkInfo.csv"

# Run SQL Query
$Datatable = New-Object System.Data.DataTable
$Connection = New-Object System.Data.SQLClient.SQLConnection
$Connection.ConnectionString = "server='$DatabaseServer';database='$Database';trusted_connection=true;"
$Connection.Open()
$Command = New-Object System.Data.SQLClient.SQLCommand
$Command.Connection = $Connection
$Command.CommandText = $Query
$Reader = $Command.ExecuteReader()
$Datatable.Load($Reader)
$Connection.Close()

# Get the data and build a new arraylist
[System.Collections.ArrayList]$NetworkInfo = @()
Foreach ($Row in $Datatable){

    # Get only IPv4 info 
    $IPAddress = ($row.IPAddress | Select-String -Pattern "\d{1,3}(\.\d{1,3}){3}").Matches.Value
    $IPSubnet = ($row.IPSubnet | Select-String -Pattern "\d{1,3}(\.\d{1,3}){3}").Matches.Value

    # Calculate the network ID
    $Network = ([IPAddress] (([IPAddress] $IPAddress).Address -band ([IPAddress] $IPSubnet).Address)).IPAddressToString

    # Get computer name
    $ComputerName = $row.Name0


    $obj = [PSCustomObject]@{

        # Add values to arraylist
        IPAddress  =  $IPAddress
        Network = $Network 
        IPSubnet = $IPSubnet
        ComputerName = $ComputerName
    }

    # Add all the values
    $NetworkInfo.Add($obj)|Out-Null
       
}

$NetworkInfo | Export-Csv -Path $ExportPath -NoTypeInformation





