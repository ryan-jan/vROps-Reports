function Get-OMTraversalSpec {
    <#
        .SYNOPSIS
        This function returns one or more traversal specifications from a vROps instance.

        .DESCRIPTION
        A traversal specification is necessary to target which objects in vROps you would like to report on.
        For example, vSphere Hosts and Clusters or, vSphere Networking etc.

        .PARAMETER Server
        An object containing a connection to a vROps instance obtained via the Connect-OMServer cmdlet.
        If this parameter is not specified it will default to using the first connected vROps server in the
        $global:DefaultOMServers array. If you have not connected to any vROps servers this will throw an error.

        .PARAMETER RootAdapterKeyKind
        Specify the RootAdapterKeyKind of a specific traversal spec.
        
        .PARAMETER RootResourceKeyKind
        Specify the RootResourceKeyKind of a specific traversal spec.

        .PARAMETER Name
        Filter the results by the name of a traversal spec.

        .EXAMPLE
        Get-OMTraversalSpec

        .EXAMPLE
        $Server = Connect-OMServer -Server vrops.example.com -User "Admin" -Password "Password123"
        Get-OMTraversalSpec -Server $Server -RootAdapterKeyKind "VMWARE" -RootResourceKeyKind "vSphere World"

        .EXAMPLE
        $Server = Connect-OMServer -Server vrops.example.com -User "Admin" -Password "Password123"
        Get-OMTraversalSpec -Server $Server -Name "vSphere Hosts and Clusters"
    #>


    [CmdletBinding()]
    param (
        $Server = $global:DefaultOMServers[0],
        [String]$RootAdapterKeyKind,
        [String]$RootResourceKeyKind,
        [String]$Name
    )

    try {
        $Server.ExtensionData.GetTraversalSpecs($AdapterKind, $ResourceKind, $Name).TraversalSpec
    } catch {
        $Err = $_
        Write-Error $Err
    }
}
