<#
.SYNOPSIS
Invokes a Nexus script.

.DESCRIPTION
Invokes a Nexus script.

.EXAMPLE
$creds = Get-Credential
$script = @"
import org.sonatype.nexus.repository.Repository;
repository.createNugetHosted("myRepo","default");
"@
Invoke-NexusScript -Uri 'http://localhost:8081' -Credential $creds -Script $script

Invokes the contents of $script on the Nexus repository server 'http://localhost:8081' using the credential $creds.
.NOTES
The basic code of this function was borrowed from the chocolatey-nexus-repo package
(https://chocolatey.org/packages/chocolatey-nexus-repo). Credit to Stephen Valdinger and Paul Broadwith.

For a list of the repository API calls see
https://github.com/sonatype/nexus-public/blob/master/plugins/nexus-script-plugin/src/main/java/org/sonatype/nexus/script/plugin/RepositoryApi.java

Nexus 3 REST and API reference https://help.sonatype.com/repomanager3/rest-and-integration-api

.LINK
https://github.com/pauby/NexusManagement/blob/master/docs/en-US/Invoke-NexusScript.md
#>

function Invoke-NexusScript {
    [CmdletBinding()]
    Param (
        # Uri of the Nexus repository server (for example https://nexus.myorg.local).
        [Parameter(Mandatory)]
        [String]
        $Uri,

        # User credentials that have permission to execute the script.
        [Parameter(Mandatory)]
        [PSCredential]
        $Credential,

        # The Groovy script to execute.
        [Parameter(Mandatory)]
        [String]
        $Script
    )

    $header = New-NexusApiHeader -Credential $Credential

    # create a random name for the script so that it does not conflict with any other script stored in Nexus
    $scriptName = [GUID]::NewGuid().ToString()
    $body = @{
        name    = $scriptName
        type    = 'groovy'
        content = $Script
    }

    # TODO Check for trailing slash in $Uri
    $baseApiUri = "$Uri/service/rest/v1/script"

    # Store the Script
    $params = @{
        Uri         = $baseApiUri
        ContentType = 'application/json'
        Body        = $($body | ConvertTo-Json)
        Header      = $header
        Method      = 'Post'
    }
    Invoke-RestMethod @params

    # Run the script
    $params = @{
        Uri         = "{0}/{1}/run" -f $baseApiUri, $scriptName
        ContentType = 'text/plain'
        Header      = $header
        Method      = 'Post'
    }
    $result = Invoke-RestMethod @params

    # Delete the Script
    $params = @{
        Uri         = "{0}/{1}" -f $baseApiUri, $scriptName
        Header      = $header
        Method      = 'Delete'
    }
    Invoke-RestMethod @params

    $result
}