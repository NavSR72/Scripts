#Get All Snaps in All Data Centers
#Enter vSphere vCenter server names/IP
$vcenterServers = @(
    "server.domain",
    "server.domain" 
     # Add more vCenter servers as needed
) 
$Username = "username@domain"

Connect-VIServer -Server $vcenterServers -User $Username -Password '<Password>'
# File path for output CSV
$outputFile = "D:\snapshots.csv"

$allSnapshots = @()

# Connect to each vCenter server
foreach ($server in $vcenterServers) {
    # Connect to vCenter server
 
    # Get all VMs
    $vms = Get-VM -Server $server
 
    # Get snapshots for each VM
    foreach ($vm in $vms) {
        $snapshots = Get-Snapshot -VM $vm
 
        # Add information to results
        foreach ($snapshot in $snapshots) {
            $allSnapshots += New-Object PSObject -Property @{
                "SnapshotName" = $snapshot.Name
                "Description" = $snapshot.Description
                "VMName" = $vm.Name
                "VcenterServer" = $server
            }
        }
    }
 
    # Disconnect from vCenter server
   # Disconnect-VIServer -Server $server -Confirm:$false
}
 
# Export results to CSV
$allSnapshots | Export-Csv -Path $outputFile -NoTypeInformation
 
# Display message
Write-Host "Results written to: $outputFile"