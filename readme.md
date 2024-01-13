## PowerShell Script: FilteredLinks.psm1

This PowerShell script, named `FilteredLinks.psm1`, defines a module called `MyModule` that contains a function called `Get-FilteredLinks`. The purpose of this function is to scrape a webpage and extract specific hyperlinks based on a defined pattern.

### Function: Get-FilteredLinks

The `Get-FilteredLinks` function performs the following steps:

1. Sets the URL of the webpage to scrape as `https://www.esd.whs.mil/Directives/forms/`.
2. Uses the `Invoke-WebRequest` cmdlet to send a request to the specified URL and stores the response in the `$response` variable.
3. Extracts the hyperlinks from the HTML content of the response using the `$response.Links` property and stores them in the `$links` variable.
4. Defines a regular expression pattern (`/Directives/forms/dd\d{4}_\d{4}/`) to match specific links.
5. Filters the `$links` array based on the defined pattern using the `-match` operator and stores the filtered links in the `$filteredLinks` variable.
6. Iterates over each filtered link and extracts the last section of the URL by splitting it using the `/` delimiter. The extracted last section is stored in the `$lastSection` variable.
7. Outputs the last section of each filtered link using the `Write-Output` cmdlet.
8. The `Export-ModuleMember` cmdlet is used to export the `Get-FilteredLinks` function from the module.

## PowerShell Script: GetFormData.ps1

This PowerShell script, named `GetFormData.ps1`, imports a module named `FilteredLinks.psm1` and uses it to scrape a webpage for specific hyperlinks. It then processes these links to extract and store information about certain PDF files.

### Script Overview

The script performs the following steps:

1. Imports the `FilteredLinks.psm1` module, which contains the `Get-FilteredLinks` function.
2. Sets the base URL and resource path for the webpage to scrape.
3. Calls the `Get-FilteredLinks` function to get an array of specific hyperlinks from the webpage.
4. Initializes an empty array to store information about the PDF files.
5. Iterates over each link:
   * Sends a request to the link URL and stores the response.
   * Extracts all hyperlinks from the response.
   * Filters the hyperlinks to only include those that end in `.pdf` or contain the current link.
   * For each filtered link that does not end in `.pdf`, sends another request to the link URL and extracts all hyperlinks from the response.
   * For each nested link that ends in `.pdf`, extracts the filename from the link and checks if it starts with `dd`. If it does, prints the link URL and adds a file object with the filename and URL to the `files` array.
6. Converts the `files` array to JSON format and writes it to a file named `FileMetadata.json`.
