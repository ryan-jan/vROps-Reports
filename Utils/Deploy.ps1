$CurModuleVersion = (Import-PowerShellDataFile ".\vROps-Reports\vROps-Reports.psd1").ModuleVersion
$PrevCommit = (git log --pretty=tformat:"%H")[1]
git checkout -b buildtemp $PrevCommit --quiet
$PrevModuleVersion = (Import-PowerShellDataFile ".\vROps-Reports\vROps-Reports.psd1").ModuleVersion
git checkout master --quiet
git branch -D buildtemp --quiet

if ($CurModuleVersion -gt $PrevModuleVersion) {
    Write-Output ("Module version increased from $PrevModuleVersion to $CurModuleVersion.`n" +
                  "Publishing new version on PSGallery.")
    Publish-Module -Path "$PSScriptRoot\..\vROps-Reports" -NuGetApiKey $env:PSGALLERY_KEY
}