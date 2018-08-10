function Measure-Koans {
    <#
    .SYNOPSIS
    Counts the number of koans in the provided ExternalScriptInfo objects.

    .DESCRIPTION
    Traverses the AST of the script blocks taken from the Get-Command output of the koan
    files to find all of the 'It' blocks in order to count the total number of Pester
    tests present in the file.

    When provided with a piped list of ExternalScriptInfo objects, sums the entire
    collection's 'It' blocks and returns a single integer sum.

    .PARAMETER KoanInfo
    Takes an array of ExternalScriptInfo objects (as provided from Get-Command when
    passed the path to an external .ps1 script file).

    .EXAMPLE
    PS> Get-Command .\KoanDirectory\*\*.ps1 | Measure-Koans
    422

    .NOTES
    Author: Joel Sallow
    Module: PSKoans
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
        [ValidateNotNull()]
        [System.Management.Automation.ExternalScriptInfo[]]
        $KoanInfo
    )
    begin {
        $KoanCount = 0
    }
    process {
        $KoanCount += $KoanInfo.ScriptBlock.Ast.FindAll(
            {
                param($Item)
                $Item -is [System.Management.Automation.Language.CommandAst] -and
                $Item.GetCommandName() -eq 'It'
            }, $true
        ).Count
    }
    end {
        $KoanCount
    }
}