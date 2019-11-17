---
external help file: nexusmanagement-help.xml
Module Name: nexusmanagement
online version:
schema: 2.0.0
---

# Invoke-NexusScript

## SYNOPSIS
Invokes a Nexus script.

## SYNTAX

```
Invoke-NexusScript [-Uri] <String> [-Credential] <PSCredential> [-Script] <String> [<CommonParameters>]
```

## DESCRIPTION
Invokes a Nexus script.

## EXAMPLES

### EXAMPLE 1
```
$creds = Get-Credential
```

$script = @"
import org.sonatype.nexus.repository.Repository;
repository.createNugetHosted("myRepo","default");
"@
Invoke-NexusScript -Uri 'http://localhost:8081' -Credential $creds -Script $script

Invokes the contents of $script on the Nexus repository server 'http://localhost:8081' using the credential $creds.

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
User credentials that have permission to execute the script.

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

### -Script
The Groovy script to execute.

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
