$servers = Get-Content -Path 'D:\input_servers.txt'

#Enter vSphere vCenter server names/IP
$vcenterServers = @(
    "server.domain",
    "server.domain" 
     # Add more vCenter servers as needed
) 
$Username = "username@domain"

Connect-VIServer -Server $vcenterServers -User $Username -Password '<Password>'


foreach ($vmName in $servers) {
    # Get the VM object
    $vm = Get-VM -Name $vmName -ErrorAction SilentlyContinue

    if ($vm) {
        # Check if the VM is powered off
        if ($vm.PowerState -eq "PoweredOff") {
            Write-Host "Deleting VM: $vmName"
            Remove-VM -VM $vm -DeletePermanently -Confirm:$false
        } else {
            Write-Host "VM $vmName is not powered off. Skipping deletion."
        }
    } else {
        Write-Host "VM $vmName not found. Skipping."
    }
}

# Disconnect from the vCenter server
Disconnect-VIServer * -Confirm:$false