---
external help file: nexusmanagement-help.xml
Module Name: nexusmanagement
online version:
schema: 2.0.0
---

# Get-NexusRepository

## SYNOPSIS
Gets a list of the available Nexus repositories.

## SYNTAX

```
Get-NexusRepository [-Uri] <String> [-Credential] <PSCredential> [<CommonParameters>]
```

## DESCRIPTION
Gets a list of the available Nexus repositories.

## EXAMPLES

### EXAMPLE 1
```
$creds = Get-Credential
```

Get-NexusRepository -Uri 'http://localhost:8081' -Credential $creds

Returns a list of the repositories available ont he Nexus repository server at http://localhost:8081 using the
credentials $creds.

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

Nexus 3 REST and API reference https://help.sonatype.com/repomanager3/rest-and-integration-api

## RELATED LINKS
