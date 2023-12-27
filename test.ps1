Import-Module .\getItemName.psm1

$url = 'https://nationalstocknumber.info/nsn-and-fsc-catalog/fsc/$fsc/page/40'
$url
$response = Invoke-WebRequest -Uri "$url" 
$htmlContent = $response.Content    

$hrefs = [regex]::Matches($htmlContent, 'href="([^"]+)"') | ForEach-Object { $_.Groups[1].Value }
$filteredHrefs = $hrefs | Where-Object { $_ -match '/national-stock-number/|/part-number/$fsc' }

$nsnPattern = '/national-stock-number/(.*)'
$partNumberPattern = '/part-number/*)'

$nsns = $filteredHrefs | Where-Object { $_ -match $nsnPattern } | ForEach-Object { $_ -replace $nsnPattern, '$1' }
$partNumbers = $filteredHrefs | Where-Object { $_ -match $partNumberPattern } | ForEach-Object { $_ -replace $partNumberPattern, '$1' } 

$csvPath = 'output.csv'
$csvData = @()

foreach ($partNumber in $partNumbers) {
    $csvData += [PSCustomObject]@{
        'PartNumber' = $partNumber
    }
}
$csvData
