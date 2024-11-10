#Delete All Snaps of mentioned servers
#Enter vSphere vCenter server names/IP
$vcenterServers = @(
    "server.domain",
    "server.domain" 
     # Add more vCenter servers as needed
) 
$Username = "username@domain"

Connect-VIServer -Server $vcenterServers -User $Username -Password '<Password>'

# File path for output CSV
$outputFile = "D:\snapshotsdeletion.csv"

$serverListFilePath = "D:\input_servers.txt"
$serverList = Get-Content $serverListFilePath

$allSnapshots = @()




# Connect to each vCenter server
foreach ($server in $serverList) {


$VM = Get-VM -Name $server -ErrorAction SilentlyContinue
 
# Get all snapshots associated with the VM
$snapshots = Get-Snapshot -VM $VM
 
    Remove-Snapshot -Snapshot $snapshots -Confirm:$false
    Write-Host "All Snapshot of $server has been deleted."
        $allSnapshots += New-Object PSObject -Property @{
            "SnapshotName" = $snapshot.Name
            "Description" = $snapshot.Description
            "VMName" = $VM.Name
            "Status" = "Deleted"
        }
 
}
 
# Disconnect from vCenter server
Disconnect-VIServer -Server $vcenterServers -Confirm:$false

# Export results to CSV
$allSnapshots | Export-Csv -Path $outputFile -NoTypeInformation
 
# Display message
Write-Host "Results written to: $outputFile"