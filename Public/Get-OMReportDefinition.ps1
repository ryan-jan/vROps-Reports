function Get-OMReportDefinition {
    <#
        .SYNOPSIS
        This function returns one or more report defininitions from a vROps instance.

        .DESCRIPTION
        This function returns one or more report defininitions from a vROps instance.

        .PARAMETER Server
        An object containing a connection to a vROps instance obtained via the Connect-OMServer cmdlet.
        If this parameter is not specified it will default to using the first connected vROps server in the
        $global:DefaultOMServers array. If you have not connected to any vROps servers this will throw an error.

        .PARAMETER Name
        Filter the list of report definitions by name.

        .PARAMETER Id
        Return a single report definition identified by its Id.

        .EXAMPLE
        Get-OMReportDefinition

        .EXAMPLE
        $Server = Connect-OMServer -Server vrops.example.com -User "Admin" -Password "Password123"
        Get-OMReportDefinition -Server $Server -Name "Utilization Report"

        .EXAMPLE
        $Server = Connect-OMServer -Server vrops.example.com -User "Admin" -Password "Password123"
        Get-OMReportDefinition -Server $Server -Id "8dc625e7-805b-420e-9fb2-917f0be1cd8c"
    #>

    
    [CmdletBinding(
        DefaultParameterSetName = "Default"
    )]
    param (
        [Parameter(
            ParameterSetName = "Default"
        )]
        [Parameter(
            ParameterSetName = "SearchByName"
        )]
        [Parameter(
            ParameterSetName = "SearchById"
        )]
        $Server = $global:DefaultOMServers[0],

        [Parameter(
            ParameterSetName = "SearchByName"
        )]
        [String]$Name,

        [Parameter(
            ParameterSetName = "SearchById"
        )]
        [String]$Id
    )

    try {
        if ($Id) {
            $Server.ExtensionData.GetReportDefinition($Id)
        } else {
            $Server.ExtensionData.GetReportDefinitions($null, $null, $Name).ReportDefinition
        }
    } catch {
        $Err = $_
        Write-Error $Err
    }
}
