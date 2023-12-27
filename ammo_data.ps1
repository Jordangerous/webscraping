Import-Module .\getItemName.psm1

$header = "item_name", "national_stock_number", "navy_ammunition_logistics_code"
$csvPath = "output.csv"

for ($i = 0; $i -le 37; $i++) {

    $url = 'https://nationalstocknumber.info/nsn-and-fsc-catalog/fsc/$fsc/page/' + "$i"
    $url
    $response = Invoke-WebRequest -Uri "$url" 
    $htmlContent = $response.Content    

    $hrefs = [regex]::Matches($htmlContent, 'href="([^"]+)"') | ForEach-Object { $_.Groups[1].Value }
    $filteredHrefs = $hrefs | Where-Object { $_ -match '/national-stock-number/|/part-number/$fsc' }

    $nsnPattern = '/national-stock-number/(.*)'
    $partNumberPattern = '/part-number/1305-(.*?)(?=_\d+)'

    $nsns = $filteredHrefs | Where-Object { $_ -match $nsnPattern } | ForEach-Object { $_ -replace $nsnPattern, '$1' }
    $partNumbers = $filteredHrefs | Where-Object { $_ -match $partNumberPattern } | ForEach-Object { $_ -replace $partNumberPattern, '$1' } 

    $matchedValues = foreach ($index in 0..($nsns.Count - 1)) {
        $nsn = $nsns[$index]
        $partNumber = $partNumbers[$index]
        $itemName = Get-ItemName $nsn
        if ($partNumber -eq $null) {
            "$itemName, $nsn, null"
        }
        else {
            $partNumber = $partNumber.Substring(0, 4)   
            "$itemName, $nsn, $partNumber"
        }
    }
    $matchedValues
    if (-not (Test-Path $csvPath)) {
        $header | Out-File -FilePath $csvPath -Encoding UTF8
    }

    $matchedValues | Out-File -FilePath $csvPath -Encoding UTF8 -Append
}


