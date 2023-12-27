function CheckLocator {
    param (
        [Parameter(Mandatory = $true)]
        [string]$url
    )

    try {
        # Make the web request
        $response = Invoke-WebRequest -Uri $url

        # HTML content of the webpage
        $htmlContent = $response.Content

        # Check if "404 - Not Found" is contained in the webpage
        if ($htmlContent.Contains("404 - Not Found")) {
            return $false
        }
        else {
            return $true
        }
    }
    catch {
        return $false
    }
}