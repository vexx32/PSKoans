---
external help file: PSKoans-help.xml
Module Name: PSKoans
online version:
schema: 2.0.0
---

# Reset-PSKoan

## SYNOPSIS
Reset a Koan to the default.

## SYNTAX

```
Reset-PSKoan [-Topic] <String> [-Name] <String> [<CommonParameters>]
```

## DESCRIPTION
Replaces the koan in the user file set with the koan from the module.

## EXAMPLES

### Example 1
```powershell
PS C:\> Reset-PSKoan -Topic AboutArrays -Name 'allows the collection to be split into multiple parts'
```

Resets the "allows the collection to be split into multiple parts" koan in AboutArrays.

## PARAMETERS

### -Name
The name of the koan to update. Wildcards are supported.

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

### -Topic
Updates the specified topic from the module.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
