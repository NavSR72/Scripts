#Disable-ADAccount -Identity VMNAME$
$serverListFilePath = "D:\input_servers.txt"
# File path for output CSV
$serverList = Get-Content $serverListFilePath

# Connect to each vCenter server
foreach ($server in $serverList) {
    # Connect to vCenter server
 
    # Stop all VMs
    Disable-ADAccount -Identity $server$ -Server Domain1
    Disable-ADAccount -Identity $server$ -Server Domain2
    Write-Host "Disabled AD Acc: $server"


}