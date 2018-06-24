# vRealize Operations Reporting via PowerCLI

This is a helper module which uses the vROps API and PowerCLI to generate and download vROps reports.
Reports can be downloaded to a file (`.csv` or `.pdf`) or as a PowerShell object for further manipulation.

For an overview of how I built this module and how it can be used check out my mini-series 
[vROps Reports and PowerCLI](https://ryanjan.uk/2018/06/24/vrops-reports-and-powercli-part-three-a-helper-module/)

## Installation

To use this module first clone this `git` repository into the current directory:

```powershell
git clone https://github.com/ryan-jan/vROps-Reports.git
```

Then import the `.psd1` file.

```powershell
Import-Module .\vROps-Reports\vROps-Reports.psd1
```

## Usage

For an in-depth overview of how best to use this module take a look at my 
[vROps Reports and PowerCLI](https://ryanjan.uk/2018/06/24/vrops-reports-and-powercli-part-three-a-helper-module/) mini-series.
