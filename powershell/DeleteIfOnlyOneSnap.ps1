#Delete If Server has only one snapshot
#Enter vSphere vCenter server names/IP
$vcenterServers = @(
    "server.domain",
    "server.domain" 
     # Add more vCenter servers as needed
) 
$Username = "username@domain"

Connect-VIServer -Server $vcenterServers -User $Username -Password '<Password>'
# File path for output CSV
$outputFile = "F:\snapshotsdeletion.csv"

$serverListFilePath = "F:\input_servers.txt"
$serverList = Get-Content $serverListFilePath

$allSnapshots = @()


# Connect to each vCenter server
foreach ($server in $serverList) {


$VM = Get-VM -Name $server -ErrorAction SilentlyContinue
 
# Get all snapshots associated with the VM
$snapshots = Get-Snapshot -VM $VM
 
# Check if there is only one snapshot
if ($snapshots.Count -eq 1) {
    Remove-Snapshot -Snapshot $snapshots[0] -Confirm:$false
    Write-Host "Snapshot of " + $server + " $($snapshots[0].Name) has been deleted."
        $allSnapshots += New-Object PSObject -Property @{
            "SnapshotName" = $snapshot.Name
            "Description" = $snapshot.Description
            "VMName" = $VM.Name
            "Status" = "Deleted"
        }
}
elseif ($snapshots.Count -gt 1) {
    Write-Host "Server" + $server + "has More than one Snap."
        $allSnapshots += New-Object PSObject -Property @{
            "SnapshotName" = ""
            "Description" = ""
            "VMName" = $vm.Name
            "Status" = "Multiple Snaps"
        }
}
else {
    Write-Host "No snapshots found for VM $($vm.Name)."
            $allSnapshots += New-Object PSObject -Property @{
            "SnapshotName" = ""
            "Description" = ""
            "VMName" = $vm.Name
            "Status" = "No Snaps found"
        }
}
 
}
 
# Disconnect from vCenter server
Disconnect-VIServer -Server $vcenterServers -Confirm:$false

# Export results to CSV
$allSnapshots | Export-Csv -Path $outputFile -NoTypeInformation
 
# Display message
Write-Host "Results written to: $outputFile"