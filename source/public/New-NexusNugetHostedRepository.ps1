<#
.SYNOPSIS
Creates a new Nexus Nuget Hosted repository.

.DESCRIPTION
Creates a new Nexus Nuget Hosted repository.

.EXAMPLE
$creds = Get-Credential
Get-NexusNugetHostedRepository -Uri 'http://localhost:8081' -Credential $creds ` -Name 'myRepo'
    -NoStrictContentTypeValidation

Creates a new Nuget hosted Nexus repository called myRepo on the default blob store with no strict content type
validation and with a deployment policy of allow at the Nexus repository server 'http://localhost:8081# using the
credentials $creds

.NOTES
The basic code of this function was borrowed from the chocolatey-nexus-repo package
(https://chocolatey.org/packages/chocolatey-nexus-repo). Credit to Stephen Valdinger and Paul Broadwith.

For a list of the repository API calls see
https://github.com/sonatype/nexus-public/blob/master/plugins/nexus-script-plugin/src/main/java/org/sonatype/nexus/script/plugin/RepositoryApi.java

For the valid WritePolicy see
https://github.com/sonatype/nexus-public/blob/master/components/nexus-repository/src/main/java/org/sonatype/nexus/repository/storage/WritePolicy.java

Nexus 3 REST and API reference https://help.sonatype.com/repomanager3/rest-and-integration-api

.LINK
https://github.com/pauby/NexusManagement/blob/master/docs/en-US/New-NexusNugetHostedRepository.md
#>

function New-NexusNugetHostedRepository {
    [CmdletBinding()]
    Param (
        # Uri of the Nexus repository server (for example https://nexus.myorg.local).
        [Parameter(Mandatory)]
        [String]
        $Uri,

        # User credentials that have permission to request a list of repositories.
        [Parameter(Mandatory)]
        [PSCredential]
        $Credential,

        # Name of the repository to create.
        [Parameter(Mandatory)]
        [String]
        $Name,

        # Blob store name to use to store the repository. By default is 'default'.
        [String]
        $BlobStoreName = 'default',

        # Turns off strict content type validation (turned on by default)
        [Switch]
        $NoStrictContentTypeValidation,

        # Specifies the Deployment Policy for the repository
        [ValidateSet('Allow Redeploy', 'Disable Redeploy', 'Read-only')]
        [String]
        $DeploymentPolicy = 'Allow Redeploy'
    )

    # translate our nice deployment policy types into Nexus WritePolicy (see
    # https://github.com/sonatype/nexus-public/blob/master/components/nexus-repository/src/main/java/org/sonatype/nexus/repository/storage/WritePolicy.java)
    # Make sure the script has 'import org.sonatype.nexus.repository.storage.WritePolicy;' otherwise you will need to
    # specify the full 'org.sonatype.nexus.repository.storage.WritePolicy' namespace
    switch ($DeploymentPolicy) {
        'Allow Redeploy' {
            $writePolicy = 'WritePolicy.ALLOW'
            break
        }
        'Read-only' {
            $writePolicy = 'WritePolicy.DENY'
            break
        }
        'Disable Redeploy' {
            $writePolicy = 'WritePolicy.ALLOW_ONCE'
            break
        }
        default {
            # we should never get here
            throw "Something has gone wrong. We hit the default switch statement for Deployment Policy whose value is '$DeploymentPolicy'"
        }
    } # /switch

    # by default strict content type validation is $true - set it to false if the switch NoStrictContentTypeValidation
    # is passed
    # The Nexus API needs a boolean to be lower case
    $strictContentTypeValidation = (-not $NoStrictContentTypeValidation.IsPresent).ToString().ToLower()

    $params = @{
        Uri        = $Uri
        Credential = $Credential
        Script     = @"
import org.sonatype.nexus.repository.Repository;
import org.sonatype.nexus.repository.storage.WritePolicy;
repository.createNugetHosted("$Name","$BlobStoreName", $strictContentTypeValidation, $writePolicy);
"@
    }

    Invoke-NexusScript @params
}