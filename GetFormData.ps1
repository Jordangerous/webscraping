Import-Module "./FilteredLinks.psm1"

$url = "https://www.esd.whs.mil"  
$resource = "/Directives/forms/"
$links = Get-FilteredLinks

$files = @()  # Create an empty array to store file objects

foreach ($uri in $links) {
    $req = $url + $resource + $uri
    $response = Invoke-WebRequest -Uri $req -AllowInsecureRedirect
    # Extract all links 
    $links = $response.Links.Href

    # Filter links that end in .pdf or contain dd0001_0499
    $filteredLinks = $links | Where-Object { $_ -like "*.pdf" -or $_ -like "*$uri*" -or $_ -like "*/Directives/forms/$uri*" }

    # Invoke WebRequest for links that do not end in .pdf
    $filteredLinks | ForEach-Object {
        if ($_ -notlike "*.pdf") {

            $nestedLink = Invoke-WebRequest -Uri "$url$_" -AllowInsecureRedirect -ErrorAction SilentlyContinue
            $nestedLinks = $nestedLink.Links.Href

            $nestedLinks  | ForEach-Object {
                if ($_ -like "*.pdf") {
              
                    # Extract text between tags
                    $fileName = $_ -split '/' | Select-Object -Last 1
                   
                    if ($fileName -like "dd*") {
                        Write-Host "$url$_"
                        $fileObject = @{
                            FileName = $fileName
                            FileUrl  = "$url$_"
                            
                        }
                        $files += $fileObject  # Add file object to the array

                        $filenames += $fileName  # Add filename to the array
                    }
                }
            }
        }
    }
}

$files | ConvertTo-Json | Out-File -FilePath "FileMetadata.json"  # Convert array to JSON and write to a file

                    






