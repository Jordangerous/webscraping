# Filename: MyModule.psm1

function Get-FilteredLinks {
    $url = "https://www.esd.whs.mil/Directives/forms/"

    $response = Invoke-WebRequest -Uri $url

    # Extract hyperlinks from HTML content
    $links = $response.Links | ForEach-Object { $_.Href }

    # Define a regex pattern to match specific links
    $pattern = '/Directives/forms/dd\d{4}_\d{4}/'

    # Filter links based on the pattern
    $filteredLinks = $links -match $pattern

    # Output the last section of the filtered links
    $filteredLinks | ForEach-Object {
        $lastSection = $_.Split('/')[-2]
        $lastSection
    }
}

Export-ModuleMember -Function Get-FilteredLinks
