function Get-fscInfo {
    param (
        [Parameter(Mandatory = $true)]
        [string]$fsc
    )

    $url = "https://nationalstocknumber.info/nsn-and-fsc-catalog/fsc/$fsc"
Write-Host $url
    $response = Invoke-WebRequest -Uri $url

    # Check if the request was successful
    if ($response.StatusCode -eq 200) {
        $htmlContent = $response.Content

        # Use regex to extract fsc name and description
        $fscName = [regex]::Match($htmlContent, '<h1 class="font16em nomargin-bottom">NSN (.*?) Catalog</h1>').Groups[1].Value
        $fscDescription = [regex]::Match($htmlContent, '<p>(FSC \d+ Includes .*?)</p>').Groups[1].Value

        # Return a hashtable with the fsc name and description
        Write-Host $fscName
        return @{
            Name = $fscName
            Description = $fscDescription
        }
    }
    else {
        Write-Host "Failed to fetch the webpage. Status code: $($response.StatusCode)"
    }
}

# Export the function
Export-ModuleMember -Function Get-fscInfo