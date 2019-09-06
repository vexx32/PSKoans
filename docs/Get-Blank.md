---
external help file: PSKoans-help.xml
Module Name: PSKoans
online version: https://github.com/vexx32/PSKoans/tree/master/docs/Get-Blank.md
schema: 2.0.0
---

# Get-Blank

## SYNOPSIS
Gets a blank item that does not equal anything.

## SYNTAX

```
Get-Blank [[-|PipeInput] <Object>] [[-|ParameterInput] <Object[]>] [<CommonParameters>]
```

## DESCRIPTION
Gets a blank object that is never equal to anything, including itself.
This function exists to permit blank spaces such as `__` to be used without quotation marks where it is situationally appropriate.

## EXAMPLES

### EXAMPLE 1
```
Get-Blank
```

Returns a blank object.

### EXAMPLE 2
```
__
```

Returns a blank object.

## PARAMETERS

### -|PipeInput
Used to capture the input in a pipeline context, to avoid erroring out in those contexts.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -|ParameterInput
Used to capture parameter names and arguments when used as a substitute for any other cmdlet.

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Blank
## NOTES

## RELATED LINKS

[https://github.com/vexx32/PSKoans](https://github.com/vexx32/PSKoans)
