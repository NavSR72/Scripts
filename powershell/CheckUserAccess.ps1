#Find a certain user has access to systems by checking if the system has a home directory with their name.

$userName = "malliga"
 
# Get the user object
$user = Get-ADUser -Filter {Name -eq $userName}
 
if ($user) {
    # Get all servers excluding those belonging to "muruges.com" domain
    $servers = Get-ADComputer -Filter * -Property DNSHostName | Where-Object { ($_.DNSHostName -notlike "*.muruges.co") -and ($_.DNSHostName -notlike "PC*") -and ($_.DNSHostName -notlike "mac*") }

 
    # Create an array to store results
    $results = @()
     foreach ($server in $servers) {
     Write-Host $server
     }
    # Loop through each server
    foreach ($server in $servers) {
        # Extract the hostname from the DNS hostname
        $hostname = $server.DNSHostName -replace "\..*"
 
        # Construct UNC path to the Users folder
        $usersFolderPath = "\\$hostname\C$\Users"
 
        # Check if the "malliga" folder exists in the Users directory
        $malligaFolderExists = Test-Path "$usersFolderPath\malliga"
 
        # If the "malliga" folder exists, assume the user has access to the server
        if ($malligaFolderExists) {
            $results += [PSCustomObject]@{
                UserName = $userName
                ServerName = $hostname
                HasAccess = "Yes"
            }
            Write-Host "$userName has access to server $hostname"
        }
    }
 
    # Export results to CSV
    $results | Export-Csv -Path "UserAccessReport.csv" -NoTypeInformation
} else {
    Write-Host "User $userName not found."
}

