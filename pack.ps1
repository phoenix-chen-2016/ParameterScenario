param(
    $Configuration = 'Debug',
    $OutputDir = '..\Publish\AutoAddlSGameApiList\'
)

$MsDeployPath = Get-ChildItem 'Registry::HKLM\SOFTWARE\Microsoft\IIS Extensions\MSDeploy' `
    | sort -Property Name -Descending `
    | select -First 1 `
    | Get-ItemProperty -Name InstallPath `
    | %{ $_.InstallPath }

$MsDeployExe = "$($MsDeployPath)msdeploy.exe"

if(!(Test-Path $OutputDir)){
    mkdir $OutputDir
}

$PackagePath = Get-Item $OutputDir
$PackageName = $PackagePath.DirectoryName

& "$MsDeployExe" `
    -verb:sync `
    -source:"contentPath=`"$(pwd)\bin\$Configuration`"" `
    -dest:"package=`"$(Join-Path -Path $PackagePath.FullName -ChildPath "$($PackageName).zip")`"" `
    -declareParamFile="parameters.xml"