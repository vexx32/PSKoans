---
external help file: PSKoans-help.xml
Module Name: PSKoans
online version: https://github.com/vexx32/PSKoans/tree/master/docs/Measure-Karma.md
schema: 2.0.0
---

# Measure-Karma

## SYNOPSIS
Reflect on your progress and check your answers.

## SYNTAX

### Default (Default)
```
Measure-Karma [-Topic <String[]>] [-ClearScreen] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Reset
```
Measure-Karma [-Topic <String[]>] [-Reset] [-ClearScreen] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ListKoans
```
Measure-Karma [-ListTopics] [-ClearScreen] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### OpenFolder
```
Measure-Karma [-Contemplate] [-ClearScreen] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Measure-Karma executes Pester against the koans to evaluate if you have made the necessary
corrections for success.

## EXAMPLES

### EXAMPLE 1
```
Measure-Karma
```

Assesses the results of the Pester tests, and builds the meditation prompt.

### EXAMPLE 2
```
meditate -Contemplate
```

Opens the user's koans folder, housed in '$home\PSKoans'.
If VS Code is in $env:Path,
opens in VS Code.

### EXAMPLE 3
```
Measure-Karma -Reset
```

Prompts for confirmation, before wiping out the user's koans folder and restoring it back
to its initial state.

When used with -Topic, only the specified topics are reset.

## PARAMETERS

### -ClearScreen
{{ Fill ClearScreen Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Contemplate
Opens your local koan folder.
If you'd like PSKoans to use VS Code Insiders, set $env:PSKoans_EditorPreference
equal to "code-insiders".

```yaml
Type: SwitchParameter
Parameter Sets: OpenFolder
Aliases: Meditate

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ListTopics
Output a complete list of available koan topics.

```yaml
Type: SwitchParameter
Parameter Sets: ListKoans
Aliases: ListKoans

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Reset
Resets everything in your local koan folder to a blank slate.
Use with caution.

```yaml
Type: SwitchParameter
Parameter Sets: Reset
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Topic
Execute koans only from the selected Topic(s).
Regex patterns are permitted.

```yaml
Type: String[]
Parameter Sets: Default, Reset
Aliases: Koan, File

Required: False
Position: Named
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
Author: Joel Sallow
Module: PSKoans

## RELATED LINKS

[https://github.com/vexx32/PSKoans](https://github.com/vexx32/PSKoans)
