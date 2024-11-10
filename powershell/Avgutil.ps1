#To find the Average Memeory Utilization of Servers over last 7 days
#Enter vSphere vCenter server names/IP
$vcenterServers = @(
    "server.domain",
    "server.domain" 
     # Add more vCenter servers as needed
) 


# File path for output CSV
$outputFile = "D:\avgutil.csv"

$Username = "username@domain"

Connect-VIServer -Server $vcenterServers -User $Username -Password '<Password>'

# Define Time Range (Modify for different timeframe)
$startDate = (Get-Date).AddDays(-7)
$endDate = Get-Date
 
# Get VMs from desired scope (Datacenter, Cluster, Resource Pool)
#$vms = Get-VM -Datacenter datacenter_name

$vms = Get-VM -Name Server_Name -ErrorAction SilentlyContinue
# Alternatively, use:
# $vms = Get-VM -Cluster cluster_name
# $vms = Get-VM -ResourcePool resource_pool_name
 
# Function to collect average memory utilization for a VM
function Get-AvgMemUtilization {
  param(
    [Parameter(Mandatory=$true)]
    [VMware.Vim.VirtualMachine] $vm
  )
 
  $stats = Get-Stat -VM $vm -Statistic memory.average -Start $startDate -End $endDate
  return [Math]::Round($stats.Average, 2)
}
 
# Collect and store VM stats
$vmStats = @()
foreach ($vm in $vms) {
  $avgMem = Get-AvgMemUtilization -vm $vm
  $vmStats += New-Object PSObject -Property @{
    "VM Name" = $vm.Name
    "Average Memory (%)" = $avgMem
  }
}
 
# Display or Export Results
$vmStats | Format-Table -AutoSize
 
# Export to CSV (optional)
$vmStats | Export-Csv -Path $outputFile -NoTypeInformation

 
# Disconnect from vCenter
Disconnect-VIServer