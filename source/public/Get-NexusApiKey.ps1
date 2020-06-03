<#
.SYNOPSIS
    Gets the Nexus Api Key for the user.

.DESCRIPTION
    Gets the Nexus Api Key for the user.

.EXAMPLE
    $creds = Get-Credential
    Remove-NexusRepository -Uri 'http://localhost:8081' -Credential $creds ` -Name 'myRepo'

    Removes a repository called 'myRepo' from the Nexus repository server 'http://localhost:8081# using the credentials
    $creds

.NOTES
    The basic code of this function was borrowed from Stephen Valdinger (@steviecoaster).

    For a list of the repository API calls see
    https://github.com/sonatype/nexus-public/blob/master/plugins/nexus-script-plugin/src/main/java/org/sonatype/nexus/script/plugin/RepositoryApi.java

    The code for the groovy script to delete the repository was borrowed from ansible-nexus3:
    https://github.com/savoirfairelinux/ansible-nexus3-oss/blob/master/files/groovy/delete_repo.groovy

    Nexus 3 REST and API reference https://help.sonatype.com/repomanager3/rest-and-integration-api

.LINK
    https://github.com/pauby/NexusManagement/blob/master/docs/en-US/Remove-NexusRepository.md
#>

function Get-NexusApiKey {
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

        # Name of the repository to remove.
        [Parameter(Mandatory)]
        [String]
        $Username
    )

    $params = @{
        Uri        = $Uri
        Credential = $Credential
        Script     = @"
import org.sonatype.nexus.security.authc.apikey.ApiKeyStore
import org.sonatype.nexus.security.realm.RealmManager
import org.apache.shiro.subject.SimplePrincipalCollection

def getOrCreateNuGetApiKey(String userName) {
    realmName = "NexusAuthenticatingRealm"
    apiKeyDomain = "NuGetApiKey"
    principal = new SimplePrincipalCollection(userName, realmName)
    keyStore = container.lookup(ApiKeyStore.class.getName())
    apiKey = keyStore.getApiKey(apiKeyDomain, principal)
    if (apiKey == null) {
        apiKey = keyStore.createApiKey(apiKeyDomain, principal)
    }
    return apiKey.toString()
}

getOrCreateNuGetApiKey("$Username")
"@
    }

    Invoke-NexusScript @params
}