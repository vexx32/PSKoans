---
external help file: PSKoans-help.xml
Module Name: PSKoans
online version:
schema: 2.0.0
---

# Update-PSKoan

## SYNOPSIS
Update the user Koan directory with new topics and koans.

## SYNTAX

### TopicOnly (Default)
```
Update-PSKoan [-Topic <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ModuleOnly
```
Update-PSKoan [-Topic <String[]>] -Module <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### IncludeModule
```
Update-PSKoan [-Topic <String[]>] -IncludeModule <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Update the user Koan directory with new topics. Topics will be moved to new directories if appropriate. Old files will be removed.

Existing koan topics are updated with new koans. Answers are preserved.

## EXAMPLES

### Example 1
```powershell
PS C:\> Update-PSKoan -Topic AboutCompareObject
```

The topic AboutCompareObject will be added if it is not already present.

### Example 2
```powershell
PS C:\> Update-PSKoan
```

All missing topics will be copied from the module.

## PARAMETERS

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

### -IncludeModule
Update the default PowerShell Koans as well as Koans for the specified module. Wildcards are supported.

```yaml
Type: String[]
Parameter Sets: IncludeModule
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Module
Update Koans in the specified module only. Wildcards are supported.

```yaml
Type: String[]
Parameter Sets: ModuleOnly
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Topic
Updates the specified topic from the module.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Koan, File

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

### None

## OUTPUTS

### System.Void

## NOTES

## RELATED LINKS

[https://github.com/vexx32/PSKoans](https://github.com/vexx32/PSKoans)
