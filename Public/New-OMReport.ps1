function New-OMReport {
    <#
        .SYNOPSIS
        Generate a new report.

        .DESCRIPTION
        Generate a new report in vROps by specifying the report definition, the target resource and the 
        required traversal spec.

        .PARAMETER Server
        An object containing a connection to a vROps instance obtained via the Connect-OMServer cmdlet.
        If this parameter is not specified it will default to using the first connected vROps server in the
        $global:DefaultOMServers array. If you have not connected to any vROps servers this will throw an error.

        .PARAMETER Resource
        Specify the resource to target the report against. See Get-OMResource.

        .PARAMETER ReportDefinition
        A VMware.VimAutomation.VROps.Views.ReportDefinition object relating to the Report Definition
        (Report Template when viewing the Web UI) that you wish to run.

        .PARAMETER TraversalSpec
        Specify the TraversalSpec to use. See Get-OMTraversalSpec.

        .EXAMPLE
        $Resource = Get-OMResource -Name 'vcenter.example.com'
        $ReportDefinition = Get-OMReportDefinition -Id 1f69952f-7ff4-4d2c-9446-81a811de19b0
        $TraversalSpec = Get-OMTraversalSpec -Name "vSphere Hosts and Clusters"
        New-OMReport -Resource $Resource -ReportDefinition $ReportDefinition -TraversalSpec $TraversalSpec
    #>


    [CmdletBinding()]
    param (
        $Server = $global:DefaultOMServers[0],

        [Parameter(
            Mandatory = $true
        )]
        [Object]$Resource,

        [Parameter(
            Mandatory = $true
        )]
        [Object]$ReportDefinition,

        [Parameter(
            Mandatory = $true
        )]
        [Object]$TraversalSpec
    )

    try {
        $Report = New-Object VMware.VimAutomation.VROps.Views.Report
        $Report.ResourceId = $Resource.Id
        $Report.ReportDefinitionId = $ReportDefinition.Id
        $Report.TraversalSpec = $TraversalSpec
        $Server.ExtensionData.CreateReport($Report)
    } catch {
        $Err = $_
        Write-Error $Err
    }
}
