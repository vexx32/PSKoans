---
external help file: PSKoans-help.xml
Module Name: PSKoans
online version: https://github.com/vexx32/PSKoans/tree/main/docs/Get-PSKoanSetting.md
schema: 2.0.0
---

# Get-PSKoanSetting

## SYNOPSIS
Retrieves the configuration settings for PSKoans.

## SYNTAX

```powershell
Get-PSKoanSetting [[-Name] <String>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves configuration data via the PoshCode Configuration module.
Module settings for PSKoans are stored in the user location / scope.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-PSKoanSetting
```

Retrieves all module settings.

### EXAMPLE 2
```powershell
Get-PSKoanSetting -Name LibraryFolder
```

Retrieves the library folder location (also retrievable with `Get-PSKoanLocation`).

## PARAMETERS

### -Name
Specifies which setting value to retrieve.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object
### System.Management.Automation.PSObject
## NOTES

## RELATED LINKS
