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
    }
    else {
        Write-Host "Failed to fetch the webpage. Status code: $($response.StatusCode)"
    }
}

# Export the function
Export-ModuleMember -Function Get-ItemName
