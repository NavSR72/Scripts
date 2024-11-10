#Get VM Details
#Enter vSphere vCenter server names/IP
$vcenterServers = @(
    "server.domain",
    "server.domain" 
     # Add more vCenter servers as needed
) 
$Username = "username@domain"

Connect-VIServer -Server $vcenterServers -User $Username -Password '<Password>'

# File path for output CSV
$serversFile = "D:\input_servers.txt"
$servers = Get-Content $serversFile

foreach ($server in $servers){
    Get-VM -Name $server
    }

foreach ($vCenterServer in $vCenterServers) {
# Connect to the vCenter server
Disconnect-VIServer -Server $vCenterServer -Confirm:$false
}
 
