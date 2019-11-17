---
external help file: nexusmanagement-help.xml
Module Name: nexusmanagement
online version:
schema: 2.0.0
---

# New-NexusNugetHostedRepository

## SYNOPSIS
Creates a new Nexus Nuget Hosted repository.

## SYNTAX

```
New-NexusNugetHostedRepository [-Uri] <String> [-Credential] <PSCredential> [-Name] <String>
 [[-BlobStoreName] <String>] [-NoStrictContentTypeValidation] [[-DeploymentPolicy] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a new Nexus Nuget Hosted repository.

## EXAMPLES

### EXAMPLE 1
```
$creds = Get-Credential
```

Get-NexusNugetHostedRepository -Uri 'http://localhost:8081' -Credential $creds \` -Name 'myRepo'
    -NoStrictContentTypeValidation

Creates a new Nuget hosted Nexus repository called myRepo on the default blob store with no strict content type
validation and with a deployment policy of allow at the Nexus repository server 'http://localhost:8081# using the
credentials $creds

## PARAMETERS

### -Uri
Uri of the Nexus repository server (for example https://nexus.myorg.local).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
User credentials that have permission to request a list of repositories.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Name of the repository to create.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BlobStoreName
Blob store name to use to store the repository.
By default is 'default'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoStrictContentTypeValidation
Turns off strict content type validation (turned on by default)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeploymentPolicy
Specifies the Deployment Policy for the repository

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: Allow Redeploy
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
The basic code of this function was borrowed from the chocolatey-nexus-repo package
(https://chocolatey.org/packages/chocolatey-nexus-repo).
Credit to Stephen Valdinger and Paul Broadwith.

For a list of the repository API calls see
https://github.com/sonatype/nexus-public/blob/master/plugins/nexus-script-plugin/src/main/java/org/sonatype/nexus/script/plugin/RepositoryApi.java

For the valid WritePolicy see
https://github.com/sonatype/nexus-public/blob/master/components/nexus-repository/src/main/java/org/sonatype/nexus/repository/storage/WritePolicy.java

Nexus 3 REST and API reference https://help.sonatype.com/repomanager3/rest-and-integration-api

## RELATED LINKS
