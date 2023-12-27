Import-Module .\GetItemName.psm1
Import-Module .\getFSCDataTest.psm1
$nsn = '5350-01-660-3729'
#$itemName = Get-ItemName $nsn
$fsc = '5350'
$fscInfo = Get-fscInfo $fsc
Write-Host $fscInfo.Name