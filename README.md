# vRealize Operations Reports via PowerCLI

This is a helper module which uses the vROps API and PowerCLI to generate and download vROps reports.
Reports can be downloaded to a file (`.csv` or `.pdf`) or as a PowerShell object for further manipulation.

[![appveyor](https://img.shields.io/appveyor/ci/ryan-jan/vrops-reports?style=flat-square&logo=appveyor)](https://ci.appveyor.com/project/ryan-jan/vrops-reports)
[![psgallery](https://img.shields.io/powershellgallery/v/vrops-reports?style=flat-square&logo=powershell)](https://www.powershellgallery.com/packages/vROps-Reports)

## Installation via PowerShell Gallery

```powershell
Install-Module "vROps-Reports" -Scope "CurrentUser"
Import-Module "vROps-Reports"
```

## Usage

For an in-depth overview of how best to use this module take a look at my 
[vROps Reports and PowerCLI](https://ryanjan.uk/2018/06/24/vrops-reports-and-powercli-part-three-a-helper-module/) mini-series.
