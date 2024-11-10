#Enter vSphere vCenter server names/IP
$vcenterServers = @(
    "server.domain",
    "server.domain" 
     # Add more vCenter servers as needed
) 
$Username = "username@domain"

Connect-VIServer -Server $vcenterServers -User $Username -Password '<Password>'
# File path for output CSV
$outputFile = "D:\Selectsnapshots.csv"

$allSnapshots = @()

$vms = Get-Content -Path 'D:\input_servers.txt'


 
    # Get snapshots for each VM
    foreach ($vm in $vms) {
        $snapshots = Get-Snapshot -VM $vm
 
        # Add information to results
        foreach ($snapshot in $snapshots) {
            $allSnapshots += New-Object PSObject -Property @{
                "SnapshotName" = $snapshot.Name
                "Description" = $snapshot.Description
                "VMName" = $snapshot.VM
                "VcenterServer" = $server
            }
            Write-Host "Snap Name: $snapshot $vm $snapshot.Description"
        }
    }
 
    # Disconnect from vCenter server

 
# Export results to CSV
$allSnapshots | Export-Csv -Path $outputFile -NoTypeInformation
 
# Display message
Write-Host "Results written to: $outputFile"