# Paths to the input files and output file
$firstListPath = "D:\FirstList.txt"
$secondListPath = "D:\SecondList.txt"
$outputCsvPath = "D:\Output.csv"
 
# Read the server lists
$firstList = Get-Content -Path $firstListPath
$secondList = Get-Content -Path $secondListPath
 
# Initialize an array to store the results
$results = @()
 
# Check each server in the second list
foreach ($server in $secondList) {
    $status = if ($firstList -contains $server) { "Avavilable in Sheet1" } else { "Not found " }
    $results += [PSCustomObject]@{
        Server = $server
        Status = $status
    }
}
 
# Export the results to a CSV file
$results | Export-Csv -Path $outputCsvPath -NoTypeInformation
 
# Output the location of the CSV file
Write-Host "Results saved to $outputCsvPath"