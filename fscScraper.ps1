$response = iwr -uri https://nationalstocknumber.info/nsn-and-fsc-catalog/
Import-Module ./CheckLocator.psm1
#return all links in the page

$hrefs = [regex]::Matches($response.Content, 'href="([^"]+)"') | ForEach-Object { $_.Groups[1].Value }
#filter hrefs that don't contain /nsn-and-fsc-catalog/fsc/
$filteredHrefs = $hrefs | Where-Object { $_ -match '/nsn-and-fsc-catalog/fsc/' }
#display the last 4 digits of each href
$filteredHrefs | ForEach-Object { 
    $fsc = $_ -replace '/nsn-and-fsc-catalog/fsc/(\d{4})', '$1' 

    # Set the initial page number
    $pageNumber = 0

    # Start the while loop
    while ($true) {
        # Construct the URL with the current page number
        $url = "https://nationalstocknumber.info/nsn-and-fsc-catalog/fsc/$fsc/page/$pageNumber"
        # Call the function
        $result = CheckLocator -url $url

        # Print the result
        #Write-Host $result

        # Exit the loop if $result is false
        if (-not $result) {
            break
        }

        # Increment the page number
        $pageNumber++
        Write-Host "page number: $pageNumber"
    }


}


