---
external help file: PSKoans-help.xml
Module Name: PSKoans
online version: https://github.com/vexx32/PSKoans/tree/main/docs/Show-Karma.md
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

### OpenFile
```
Show-Karma -Contemplate [-Topic <String[]>] [-ClearScreen] [<CommonParameters>]
```

### IncludeModule
```
Show-Karma -IncludeModule <String[]> [-Topic <String[]>] [-ClearScreen] [-Detailed] [<CommonParameters>]
```

### ModuleOnly
```
Show-Karma -Module <String[]> [-Topic <String[]>] [-ClearScreen] [-Detailed] [<CommonParameters>]
```

### ListKoans
```
Show-Karma -List [-Topic <String[]>] [-Module <String[]>] [-ClearScreen] [<CommonParameters>]
```

### OpenFolder
```
Show-Karma -Library [-ClearScreen] [<CommonParameters>]
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

Opens the current koan file in the editor specified by the `Editor` setting.
Use [`Set-PSKoanSetting`](./Set-PSKoanSetting.md) to change the editor used.

If a known editor (`code`, `code-insiders`, or `atom`) is used, PSKoans will pass along line information as well.

### EXAMPLE 3
```powershell
Show-Karma -Contemplate -Topic AboutComparison
```

Opens the specified `AboutComparison` topic file in the preferred editor.

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
Parameter Sets: OpenFile
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

### -Library
Opens the current `KoanLocation` folder in the preferred editor.
To set the preferred editor, use [`Set-PSKoanSetting`](./Set-PSKoanSetting.md).

If the preferred editor cannot be found or the setting is cleared, the folder will be opened in the default handler.
This should be Windows Explorer on Windows, Finder on Mac, etc.

```yaml
Type: SwitchParameter
Parameter Sets: OpenFolder
Aliases: OpenFolder

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
When provided along with `-Contemplate`, the targeted topic will be respected.

```yaml
Type: String[]
Parameter Sets: Default, OpenFile, IncludeModule, ModuleOnly, ListKoans
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

[https://github.com/vexx32/PSKoans/tree/main/docs/Show-Karma.md](https://github.com/vexx32/PSKoans/tree/main/docs/Measure-Karma.md)
