---
external help file: PSKoans-help.xml
Module Name: PSKoans
online version: https://github.com/vexx32/PSKoans/tree/master/docs/Show-Karma.md
schema: 2.0.0
---

# Show-Karma

## SYNOPSIS
Reflect on your progress and check your answers.

## SYNTAX

### Default (Default)
```
Show-Karma [-Topic <String[]>] [-ClearScreen] [-Detailed] [<CommonParameters>]
```

### IncludeModule
```
Show-Karma [-Topic <String[]>] -IncludeModule <String[]> [-ClearScreen] [-Detailed] [<CommonParameters>]
```

### ModuleOnly
```
Show-Karma [-Topic <String[]>] -Module <String[]> [-ClearScreen] [-Detailed] [<CommonParameters>]
```

### ListKoans
```
Show-Karma [-Topic <String[]>] [-Module <String[]>] [-List] [-ClearScreen] [<CommonParameters>]
```

### OpenFolder
```
Show-Karma [-Contemplate] [-ClearScreen] [<CommonParameters>]
```

## DESCRIPTION
Show-Karma executes Pester against the koans to evaluate if you have made the necessary corrections for success.

## EXAMPLES

### EXAMPLE 1
```powershell
Show-Karma
```

Assesses the koan lessons, and displays the meditation prompt with the results.

### EXAMPLE 2
```powershell
Show-Karma -Contemplate
```

Opens the user's koans folder, housed in `$home\PSKoans`.
If VS Code is in `$env:PATH`, opens VS Code to the workspace location.
Otherwise, the folder is opened in a file explorer.

## PARAMETERS

### -ClearScreen
Clears the console host before displaying the meditation prompt.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
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
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Detailed
Adds a summarized view of the current topic file to the meditation prompt.
The summary will contain a full list of all koans in the file, and indicate their current status.

```yaml
Type: SwitchParameter
Parameter Sets: Default, IncludeModule, ModuleOnly
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeModule
Show Karma for the default PowerShell Koans as well as Koans for the specified module. Wildcards are supported.

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

### -List
Output a complete list of available koan topics.

```yaml
Type: SwitchParameter
Parameter Sets: ListKoans
Aliases: ListKoans, ListTopics

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Module
Show Karma for Koans in the specified module only. Wildcards are supported.

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

```yaml
Type: String[]
Parameter Sets: ListKoans
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Topic
Execute koans only from the selected Topic(s).
Wildcard patterns are permitted.

```yaml
Type: String[]
Parameter Sets: Default, IncludeModule, ModuleOnly, ListKoans
Aliases: Koan, File

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

[https://github.com/vexx32/PSKoans/tree/master/docs/Show-Karma.md](https://github.com/vexx32/PSKoans/tree/master/docs/Measure-Karma.md)
