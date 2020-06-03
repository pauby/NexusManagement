<#
.SYNOPSIS
Gets a list of the available Nexus repositories.

.DESCRIPTION
Gets a list of the available Nexus repositories.

.EXAMPLE
$creds = Get-Credential
Get-NexusRepository -Uri 'http://localhost:8081' -Credential $creds

Returns a list of the repositories available ont he Nexus repository server at http://localhost:8081 using the
credentials $creds.

.NOTES
The basic code of this function was borrowed from the chocolatey-nexus-repo package
(https://chocolatey.org/packages/chocolatey-nexus-repo). Credit to Stephen Valdinger and Paul Broadwith.

For a list of the repository API calls see
https://github.com/sonatype/nexus-public/blob/master/plugins/nexus-script-plugin/src/main/java/org/sonatype/nexus/script/plugin/RepositoryApi.java

Nexus 3 REST and API reference https://help.sonatype.com/repomanager3/rest-and-integration-api

.LINK
https://github.com/pauby/NexusManagement/blob/master/docs/en-US/Get-NexusRepository.md
#>

function Get-NexusRepository {
    [CmdletBinding()]
    Param (
        # Uri of the Nexus repository server (for example https://nexus.myorg.local).
        [Parameter(Mandatory)]
        [String]
        $Uri,

        # User credentials that have permission to request a list of repositories.
        [Parameter(Mandatory)]
        [PSCredential]
        $Credential
    )

    $params = @{
        Uri     = "{0}/service/rest/v1/repositories" -f $Uri.Trim('\/')
        Method  = 'Get'
        Headers = New-NexusApiHeader -Credential $Credential
    }
    Invoke-RestMethod @params
}