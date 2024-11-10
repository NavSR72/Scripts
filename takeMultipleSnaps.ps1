#Enter vSphere vCenter server names/IP
$vcenterServers = @(
    "server.domain",
    "server.domain" 
     # Add more vCenter servers as needed
) 
$Username = "username@domain"

Connect-VIServer -Server $vcenterServers -User $Username -Password '<Password>'
# Define the path to the text file containing server names
$serversFile = "D:\input_servers.txt"
 
# Read the server names from the text file
$servers = Get-Content $serversFile
 
    # Iterate over each server listed in the text file
    foreach ($serverName in $servers) {
        # Retrieve the VM object
        $VM = Get-VM -Name $serverName -ErrorAction SilentlyContinue
        # Check if the VM object exists and if it's powered on
        if ($VM -ne $null -and $VM.PowerState -eq "PoweredOn") {
            # Take a snapshot for the VM
            $SnapshotName = "Snapshot_" + $VM.Name + "_" + (Get-Date -Format "yyyyMMdd_HHmmss")
            New-Snapshot -VM $VM -Name $SnapshotName -Description "<AppName> <Ticket No.>"
            Write-Host "Great"
        }
    }

    foreach ($vCenterServer in $vCenterServers) {
    # Connect to the vCenter server
    Disconnect-VIServer -Server $vCenterServer -Confirm:$false
    }
    # Disconnect from the current vCenter server



