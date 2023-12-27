# URL of the webpage

function Get-ItemName {
    param (
        [Parameter(Mandatory = $true)]
        [string]$nsn
    )

    $url = "https://nationalstocknumber.info/national-stock-number/$nsn"

    $response = Invoke-WebRequest -Uri $url

    # Check if the request was successful
    if ($response.StatusCode -eq 200) {
        $htmlContent = $response.Content

        # Use regex to extract h1 elements
        $h1Elements = [regex]::Matches($htmlContent, '<h1.*?>(.*?)</h1>') | ForEach-Object { $_.Groups[1].Value.Trim() }

        $h1Elements

        # Use regex to extract li elements after the specific h5
        $crossRefContent = [regex]::Match($htmlContent, '<h5 class="bold font12em">Cross Reference:</h5>\s*<ul>\s*((?:<li>.*?</li>\s*)*)</ul>').Groups[1].Value
        $liElements = [regex]::Matches($crossRefContent, '<li>(.*?)</li>') | ForEach-Object { $_.Groups[1].Value.Trim() }
        Write-Host 'getting item name'
        # Convert the list items into CSV
        $csv = $liElements -join ','
        $csv = $csv -join $h1Elements -join ','
        Write-Host $h1Elements
        Write-Host $csv
    }
    else {
        Write-Host "Failed to fetch the webpage. Status code: $($response.StatusCode)"
    }
}

# Export the function
Export-ModuleMember -Function Get-ItemName
