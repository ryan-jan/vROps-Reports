function Get-OMReport {
    <#
        .SYNOPSIS
        Get information pertaining to one or more generated reports.

        .DESCRIPTION
        This function will retrieve useful information for one or more reports which have already been generated.
        This information can then be used to retrieve the report data using Receive-OMReport.

        .PARAMETER Server
        An object containing a connection to a vROps instance obtained via the Connect-OMServer cmdlet.
        If this parameter is not specified it will default to using the first connected vROps server in the
        $global:DefaultOMServers array. If you have not connected to any vROps servers this will throw an error.

        .PARAMETER Id
        Specify the Id for a generated report. If not specified this will return all generated reports for
        the current connected user.

        .EXAMPLE
        Get-OMReport -Server vrops.example.com

        .EXAMPLE
        Get-OMReport -Id 188871a7-9dae-467d-abc4-2058f4a0828d
    #>

    
    [CmdletBinding()]
    param (
        $Server = $global:DefaultOMServers[0],
        [string[]] $Id
    )

    try {
        if ($Id) {
            foreach ($RepId in $Id) {
                $Server.ExtensionData.GetReport($RepId)
            }
        } else {
            $Server.ExtensionData.GetReports().Report
        }
    } catch {
        $Err = $_
        Write-Error $Err
    }
}
