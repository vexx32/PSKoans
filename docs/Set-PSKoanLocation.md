---
external help file: PSKoans-help.xml
Module Name: PSKoans
online version: https://github.com/vexx32/PSKoans/tree/master/docs/Set-PSKoanLocation.md
schema: 2.0.0
---

# Set-PSKoanLocation

## SYNOPSIS
Sets the PSKoans folder location where koans files will be stored and retrieved.

## SYNTAX

```
Set-PSKoanLocation [-Path] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Sets the module-scoped PSKoanLocation variable in order to modify where the module looks for and
stores its koans lesson files.

## EXAMPLES

### EXAMPLE 1
```
Set-PSKoanLocation -Path C:\PSKoans
```

Measure-Karma

Sets the koan folder location to 'C:\PSKoans' and then invokes Measure-Karma to examine that location
for koans files.

## PARAMETERS

### -Path
Specify the path to set the koan location to

```yaml
Type: String
Parameter Sets: (All)
Aliases: PSPath, Folder

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Void
## NOTES
The PSKoans folder specified will become the location to look for koans files.
If this location
is empty or nonexistent, it will be created and populated with a pristine copy of the koans library
when Measure-Karma is run next.

## RELATED LINKS
