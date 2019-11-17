---
external help file: nexusmanagement-help.xml
Module Name: nexusmanagement
online version:
schema: 2.0.0
---

# New-NexusApiHeader

## SYNOPSIS
Creates the web request header to access the Nexus Api.

## SYNTAX

```
New-NexusApiHeader [-Credential] <PSCredential> [<CommonParameters>]
```

## DESCRIPTION
Creates the web request header to access the Nexus Api.

## EXAMPLES

### EXAMPLE 1
```
$creds = Get-Credential
```

New-Nexus-ApiHeader -Credential $creds

Creates a new header with the credential $creds to access the Nexus Api.

## PARAMETERS

### -Credential
Credentials used to access Nexus.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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

## RELATED LINKS
