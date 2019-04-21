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
Measure-Karma executes Pester against the koans to evaluate if you have made the necessary corrections for success.

## EXAMPLES

### EXAMPLE 1
```
Measure-Karma
```

Assesses the koan lessons, and displays the meditation prompt with the results.

### EXAMPLE 2
```
Measure-Karma -Contemplate
```

Opens the user's koans folder, housed in `home\PSKoans`.
If VS Code is in `$env:Path`, opens VS Code to the workspace location.
Otherwise, the folder is opened in a file explorer.

### EXAMPLE 3
```
Measure-Karma -Reset
```

Prompts for confirmation before wiping out the user's koans folder and restoring it back to its initial state.
This can be used to completely reset the koan files whenever needed, or to populate a new location with fresh koans after using `Set-PSKoanLocation`.

When used with -Topic, only the specified topics are reset.

## PARAMETERS

### -ClearScreen
Clears the console host before displaying the meditation prompt.

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
Opens your local koans library.
If VS Code is installed, it will start VS Code in the folder.
Otherwise, the folder is simply opened in a file explorer.

If you have VS Code Insiders installed, you can set `$env:PSKoans_EditorPreference = "code-insiders"` to indicate VS Code Insiders should be opened instead.

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
Resets everything in your local koan folder to the initial state.
Use with caution.
This can be used after using `Set-PSKoanLocation` to a new directory to get started.

If combined with `-Topic`, resets only the specified topics.

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

If combined with `-Reset`, the specified topics are reset to their initial states.

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
Prompts for confirmation before making any changes.
Use with -Reset to always be prompted before any changes are made.

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
When used with -Reset, displays what will be reset without actually resetting anything.

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

## RELATED LINKS

[https://github.com/vexx32/PSKoans](https://github.com/vexx32/PSKoans)
