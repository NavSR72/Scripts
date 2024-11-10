#Enter vSphere vCenter server names/IP
$vcenterServers = @(
    "server.domain",
    "server.domain" 
     # Add more vCenter servers as needed
) 
$Username = "username@domain"

 
# Loop through each vCenter server
foreach ($vCenterServer in $vCenterServers) {
    # Connect to the vCenter server
    Connect-VIServer -Server $vcenterServers -User $Username -Password '<Password>'

    # Retrieve the VM object
    $VM = Get-VM -Name "Server_Name" -ErrorAction SilentlyContinue
 
# Get all snapshots associated with the VM
$snapshots = Get-Snapshot -VM $VM
 
# Check if there is only one snapshot
if ($snapshots.Count -eq 1) {
    # Automatically delete the snapshot
    #Remove-Snapshot -Snapshot $snapshots[0] -Confirm:$false
    Write-Host "Snapshot $($snapshots[0].Name) has been deleted."
    break
}
elseif ($snapshots.Count -gt 1) {
$snapshots | Select-Object Name, Description

    # Prompt the user to select the snapshot(s) to delete
    $selectedSnapshot = Read-Host "Enter the name of the snapshot(s) you want to delete (separate multiple names with commas)"
    # Convert the user input to an array of snapshot names
    $selectedSnapshotNames = $selectedSnapshot -split ','
    # Iterate through the selected snapshot names and delete them
    foreach ($snapshotName in $selectedSnapshotNames) {
        $snapshotToDelete = $snapshots | Where-Object { $_.Name -eq $snapshotName.Trim() }
        if ($snapshotToDelete -ne $null) {
            #Remove-Snapshot -Snapshot $snapshotToDelete -Confirm:$false
            Write-Host "Snapshot '$snapshotName' has been deleted."
            break
        }
        else {
            Write-Host "Snapshot '$snapshotName' not found."
        }
    }
    break
}
else {
    Write-Host "No snapshots found for VM $($vm.Name)."
}

    # Disconnect from the current vCenter server
    Disconnect-VIServer -Server $vCenterServer -Confirm:$false
}