---
external help file: PSKoans-help.xml
Module Name: PSKoans
online version: https://github.com/vexx32/PSKoans/tree/master/docs/Get-PSKoan.md
schema: 2.0.0
---

# Get-PSKoanFile

## SYNOPSIS
Get the paths for module and user koan topics.

## SYNTAX

```powershell
Get-PSKoan [-Topic <string[]>] [-IncludeModule <string[]>] [-Scope <string>] [-SkipAttributeParsing] [<CommonParameters>]
```

```powershell
Get-PSKoan [-Topic <string[]>] [-Module <string[]>] [-Scope <string>] [-SkipAttributeParsing] [<CommonParameters>]
```

## DESCRIPTION
Returns a sorted list of objects describing each Koan file. Metadata includes module, position, absolute and relative paths.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-PSKoan
```

Returns information for all Koans except module specific Koans.

### EXAMPLE 2
```powershell
Get-PSKoan -Topic AboutArrays
```

Returns information about the AboutArrays topic.

### EXAMPLE 3
```powershell
Get-PSKoan -IncludeModule *
```

Returns information for all Koans including module specific Koans.

### EXAMPLE 4
```powershell
Get-PSKoan -Module ActiveDirectory
```

Returns information about Koans for the ActiveDirectory module only.

## PARAMETERS

### -Topic
Specify one or more topic names or patterns to filter the list.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeModule

Specify one or more modules to include. By default module koans are not included in the list.

```yaml
Type: String[]
Parameter Sets: IncludeModule
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard
```

### -Module

Get koans for the specified modules. Wildcards are supported.

```yaml
Type: String[]
Parameter Sets: ModuleOnly
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: True
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSObject[]
## NOTES

## RELATED LINKS

[https://github.com/vexx32/PSKoans/tree/master/docs/Get-PSKoanFile.md](https://github.com/vexx32/PSKoans/tree/master/docs/Get-PSKoanFile.md)
