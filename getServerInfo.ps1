#All Servers exported in Excel Sheet and you want details of only few servers
# Load the ImportExcel module
Import-Module ImportExcel
 
# Specify the input Excel file path and the output Excel file path
$inputFilePath = "D:\cmdb.csv"
$outputFilePath = "D:\outputfile.csv"
 
 
# Read the list of servers from the text file
$serversToExtract = Get-Content -Path 'D:\input_servers.txt'
 
# Read the entire Excel file into a PowerShell object
$excelData = Import-Csv -Path $inputFilePath
 
# Filter the rows based on the server names or IDs
$filteredData = $excelData | Where-Object { $_.serverName -in $serversToExtract }
 
# Export the filtered data into a new Excel file
$filteredData | Export-Csv -Path $outputFilePath -NoTypeInformation