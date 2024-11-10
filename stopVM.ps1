#Enter vSphere vCenter server names/IP
$vcenterServers = @(
    "server.domain",
    "server.domain" 
     # Add more vCenter servers as needed
) 
$Username = "username@domain"

Connect-VIServer -Server $vcenterServers -User $Username -Password '<Password>'
$serverListFilePath = "D:\input_servers.txt"
# File path for output CSV
$serverList = Get-Content $serverListFilePath


# Connect to each vCenter server
foreach ($server in $serverList) {
    # Connect to vCenter server
 
    # Stop all VMs
    Stop-VM -VM $server -Confirm:$false
    Write-Host "Powered Off $server"
}

# Disconnect from vCenter server
Disconnect-VIServer -Server $vcenterServers -Confirm:$false

