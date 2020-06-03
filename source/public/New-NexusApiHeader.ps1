<#
.SYNOPSIS
Creates the web request header to access the Nexus Api.

.DESCRIPTION
Creates the web request header to access the Nexus Api.

.EXAMPLE
$creds = Get-Credential
New-Nexus-ApiHeader -Credential $creds

Creates a new header with the credential $creds to access the Nexus Api.

.NOTES
The basic code of this function was borrowed from the chocolatey-nexus-repo package
(https://chocolatey.org/packages/chocolatey-nexus-repo). Credit to Stephen Valdinger and Paul Broadwith.

.LINK
https://github.com/pauby/NexusManagement/blob/master/docs/en-US/New-NexusApiHeader.md
#>

function New-NexusApiHeader {
    [CmdletBinding()]
    Param (
        # Credentials used to access Nexus.
        [Parameter(Mandatory)]
        [PSCredential]
        $Credential
    )

    # Create the Api header
    $credPair = ("{0}:{1}" -f $Credential.Username, $Credential.GetNetworkCredential().Password)
    $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($credPair))
    return @{
        Authorization = "Basic $encodedCreds"
    }
}