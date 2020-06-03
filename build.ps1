[CmdletBinding()]
Param (
    [string[]]
    $Task = 'Build',

    # skips the initialization of the environment, which can be slow, and jumps
    # straight to the build script
    [switch]
    $SkipInit
)

if ((Get-PSRepository).PublishLocation -notcontains $env:PUBLISH_URL) {
    $params = @{
        Name                      = $env:PUBLISH_NAME
        PublishLocation           = $env:PUBLISH_URL
        SourceLocation            = $env:PUBLISH_URL
        Credential                = ( New-Object System.Management.Automation.PSCredential $env:PUBLISH_USERNAME, (ConvertTo-SecureString $env:PUBLISH_PASSWORD -AsPlainText -Force) )
        PackageManagementProvider = 'NuGet'
        InstallationPolicy        = 'Trusted'
        Verbose                   = $VerbosePreference
        WarningVariable           = 'tempVar'
    }

    Register-PSRepository @params
}

function Test-Administrator {
    if ($PSVersionTable.Platform -ne 'Unix') {
        $user = [Security.Principal.WindowsIdentity]::GetCurrent();
        (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    }
    else {
        # TODO: We are running in Linux so assume (at this stage) we have root / Admin - this needs resolved
        $true
    }
}

if (-not $SkipInit.IsPresent) {

    $dependencies = @{
        InvokeBuild         = 'latest'
        Configuration       = 'latest'
        PowerShellBuild     = 'latest'
        Pester              = 'latest'
        PSScriptAnalyzer    = 'latest'
        PSPesterTestHelpers = 'latest'  # I don't trust this Warren guy...
    }

    # dependencies
    if (-not (Get-Command -Name 'Get-PackageProvider' -ErrorAction SilentlyContinue)) {
        $null = Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
        Write-Verbose 'Bootstrapping NuGet package provider.'
        Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
    }
    elseif ((Get-Packageprovider).Name -notcontains 'nuget') {
        Write-Verbose 'Bootstrapping NuGet package provider.'
        Get-PackageProvider -Name NuGet -ForceBootstrap
    }

    # Trust the PSGallery is needed
    if ((Get-PSRepository -Name PSGallery).InstallationPolicy -ne 'Trusted') {
        Write-Verbose "Trusting PowerShellGallery."
        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    }

    Install-Module -Name PSDepend

    if (Test-Administrator) {
        $dependencies | Invoke-PSDepend -Import -Install -Force
    }
    else {
        Write-Warning "Not running as Administrator - could not initialize build environment."
    }

    # Configure git
    if ($null -eq (Invoke-Expression -Command 'git config --get user.email')) {
        Write-Verbose 'Git is not configured so we need to configure it now.'
        git config --global user.email "pauby@users.noreply.github.com"
        git config --global user.name "pauby"
        git config --global core.safecrlf false
    }
}

Write-Host "Tag    : $($env:CI_COMMIT_TAG)`nBranch : $($env:CI_COMMIT_REF_NAME)"

Invoke-Build -File .\.NexusManagement.build.ps1 -Task $Task -Verbose:$VerbosePreference