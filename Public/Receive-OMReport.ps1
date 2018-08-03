function Receive-OMReport {
    <#
        .SYNOPSIS
        Download a generated report from a vRealize Operations Management instance.

        .DESCRIPTION
        Once a report has been generated in vRealze Operations Management this function can be used to 
        receive the report data as a powershell object.

        .PARAMETER Server
        An object containing a connection to a vROps instance obtained via the Connect-OMServer cmdlet.
        If this parameter is not specified it will default to using the first connected vROps server in the
        $global:DefaultOMServers array. If you have not connected to any vROps servers this will throw an error.

        .PARAMETER Report
        This parameter accepts an instance of the VMware.VimAutomation.VROps.Views.Report object
        to be received. See New-OMReport for information on generating a report.

        .PARAMETER Id
        Specify the Id of the VMware.VimAutomation.VROps.Views.Report object to be downloaded.

        .PARAMETER CSV
        Receive the report as a CSV file.

        .PARAMETER PDF
        Receive the report as a PDF file.

        .PARAMETER Path
        Specify the path to save either CSV or PDF files.

        .EXAMPLE
        $Report = Get-OMReport -Id e04e721e-df03-4cca-9412-4d3f38e9a56a
        Receive-OMReport -Report $Report

        .EXAMPLE
        Receive-OMReport -Id e04e721e-df03-4cca-9412-4d3f38e9a56a

        .EXAMPLE
        Receive-OMReport -Id e04e721e-df03-4cca-9412-4d3f38e9a56a -CSV -Path "C:\report.csv"

        .EXAMPLE
        Receive-OMReport -Id e04e721e-df03-4cca-9412-4d3f38e9a56a -PDF -Path "C:\report.pdf"
    #>


    [CmdletBinding()]
    param (
        [Parameter(
            ParameterSetName = "Default"
        )]
        [Parameter(
            ParameterSetName = "By Id"
        )]
        [Parameter(
            ParameterSetName = "CSVDownload"
        )]
        [Parameter(
            ParameterSetName = "PDFDownload"
        )]
        $Server = $global:DefaultOMServers[0],

        [Parameter(
            ParameterSetName = "Default",
            ValueFromPipeline = $True
        )]
        [Parameter(
            ParameterSetName = "CSVDownload"
        )]
        [Parameter(
            ParameterSetName = "PDFDownload"
        )]
        [VMware.VimAutomation.VROps.Views.Report]$Report,

        [Parameter(
            ParameterSetName = "By Id",
            ValueFromPipeline = $True
        )]
        [Parameter(
            ParameterSetName = "CSVDownload"
        )]
        [Parameter(
            ParameterSetName = "PDFDownload"
        )]
        [String]$Id,
        
        [Parameter(
            ParameterSetName = "CSVDownload"
        )]
        [Switch]$CSV,

        [Parameter(
            ParameterSetName = "PDFDownload"
        )]
        [Switch]$PDF,

        [Parameter(
            ParameterSetName = "CSVDownload",
            Mandatory = $true
        )]
        [Parameter(
            ParameterSetName = "PDFDownload",
            Mandatory = $true
        )]
        [String]$Path

    )


    try {
        # Check how the user has supplied the report ID.
        if ($Report) {
            $Id = $Report.Id
        }

        if ($CSV) {
            Write-Output "Receiving report $Id, please wait..."
            if (!($Path.EndsWith(".csv", "CurrentCultureIgnoreCase"))) {
                $Path = "$Path.csv"
            }
            $FileStream = New-Object System.IO.FileStream $Path, "CreateNew", "Write", "Read"
            $Server.ExtensionData.GetReport($Id).DownloadReport($FileStream, "CSV")
            $FileStream.Close()
            $FileStream.Dispose()
            Write-Host "Report received successfully to $Path"
        } elseif ($PDF) {
            Write-Output "Receiving report $Id, please wait..."
            if (!($Path.EndsWith(".pdf", "CurrentCultureIgnoreCase"))) {
                $Path = "$Path.pdf"
            }
            $FileStream = New-Object System.IO.FileStream $Path, "CreateNew", "Write", "Read"
            $Server.ExtensionData.GetReport($Id).DownloadReport($FileStream, "PDF")
            $FileStream.Close()
            $FileStream.Dispose()
            Write-Host "Report received successfully to $Path"
        } else {
            $MemoryStream = New-Object System.IO.MemoryStream
            $Server.ExtensionData.GetReport($Id).DownloadReport($MemoryStream, "CSV")
            $MemoryStream.Seek(0, "Begin") | Out-Null
            $ReadStream = New-Object System.IO.StreamReader($MemoryStream)
            $HeaderRow = 0

            while ($ReadStream.Peek() -ne -1) {
                if ($HeaderRow -eq 0) {
                    # Fix duplicate header row names
                    $Headers = $ReadStream.ReadLine()
                    $Headers = $Headers.Split(",").Trim('"')
                    
                    for ($i=0; $i -lt $Headers.Count; $i++) {
                        #Skip first column.
                        if ($i -eq 0) { 
                            Continue 
                        }
                        # If in any other column is a dupe, give it a unique name
                        if ($Headers[0..($i-1)] -contains $Headers[$i]) {
                            $Headers[$i] = "$($Headers[$i])_$i"
                        }
                    }
                    $HeaderRow = 1
                }
                $Prog = [Math]::Round(($ReadStream.BaseStream.Position / $ReadStream.BaseStream.Length) * 100, 2)
                Write-Progress -Activity "Receiving Report" -Status "$Prog% Complete:" -PercentComplete $Prog
                $Output += $ReadStream.ReadLine()
                $Output += "`n"
            }

            $ReadStream.Close()
            $ReadStream.Dispose()
            $MemoryStream.Close()
            $MemoryStream.Dispose()
            $Output | ConvertFrom-Csv -Header $Headers
        }
    } catch {
        $Err = $_
        Write-Error $Err
    }
}
