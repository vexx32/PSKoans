---
external help file: PSKoans-help.xml
Module Name: PSKoans
online version:
schema: 2.0.0
---

# Reset-PSKoan

## SYNOPSIS
Reset a Koan or a number of koans to the default.

## SYNTAX

```
Reset-PSKoan [[-Topic] <string[]>] [[-Name] <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

```
Reset-PSKoan [[-Topic] <string[]>] [[-Name] <string>] [-Context] <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Replaces the koan in the user file set with the original copy of the koan from the module.

## EXAMPLES

### Example 1
```powershell
PS C:\> Reset-PSKoan
```

Reset all koans.

### Example 1
```powershell
PS C:\> Reset-PSKoan -Topic AboutArrays
```

Resets all koans in the AboutArrays topic.

### Example 2
```powershell
PS C:\> Reset-PSKoan -Topic AboutArrays, AboutComparison
```

Reset all koans in the AboutArrays and AboutComparison topics.

### Example 3
```powershell
PS C:\> Reset-PSKoan -Topic AboutArrays -Name 'allows the collection to be split into multiple parts'
```

Resets the "allows the collection to be split into multiple parts" koan in the AboutArrays topic.

### Example 4
```powershell
PS C:\> Reset-PSKoan -Topic AboutComparison -Name 'may coerce values to boolean' -Context '-and'
```

Resets the "may coerce values to boolean" koan in the "-and" context of the AboutComparison topic.

### Example 5
```powershell
PS C:\> Reset-PSKoan -Topic AboutComparison -Context '-and'
```

Resets all koans in the "-and" context of the AboutComparison topic.

### Example 6
```powershell
PS C:\> Reset-PSKoan -Topic AboutC* -Name returns*
```

Reset koans with names starting "returns" in topics matching the wildcard pattern "AboutC*".

## PARAMETERS

### -Confirm
Prompts for confirmation before making any changes. Use to always be prompted before any changes are made.

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

### -Context
Reset koans in the specified context.

```yaml
Type: String
Parameter Sets: NameAndContext
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: True
```

### -Name
The name of the koan to reset. Wildcards are supported.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: True
```

### -Topic
Reset the specified topic or topics. Wildcards are supported.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Koan, File

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: True
```

### -WhatIf
Displays what will be reset without actually resetting anything.

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

### None

## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS

[https://github.com/vexx32/PSKoans](https://github.com/vexx32/PSKoans)