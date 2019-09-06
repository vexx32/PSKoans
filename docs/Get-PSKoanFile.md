---
external help file: PSKoans-help.xml
Module Name: PSKoans
online version: https://github.com/vexx32/PSKoans/tree/master/docs/Get-PSKoanFile.md
schema: 2.0.0
---

# Get-PSKoanFile

## SYNOPSIS
Get the paths for module and user koan topics.

## SYNTAX

```
Get-PSKoanFile [[-Topic] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Returns objects describing the file paths for each topic.

## EXAMPLES

### EXAMPLE 1
```
Get-PSKoanFile
```

Returns all paths for all topics available in the module's Koan directory.

### EXAMPLE 2
```
Get-PSKoanFile -Topic AboutArrays
```

Returns path information for the AboutArrays topic.

## PARAMETERS

### -Topic
Specify one or more topic names or patterns to filter the list.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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
