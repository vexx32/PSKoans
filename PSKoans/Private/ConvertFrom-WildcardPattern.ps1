using namespace System.Text
using namespace System.Management.Automation

function ConvertFrom-WildcardPattern {
    <#
    .SYNOPSIS
        Returns a regular expression from an array of wildcard patterns.

    .DESCRIPTION
        Returns a regular expression from an array of wildcard patterns using PowerShell's WildcardPatternToRegexParser class.

    .PARAMETER Pattern
        Zero or more wildcard patterns to convert.

    .EXAMPLE
        ConvertFrom-WildcardPattern -Pattern AboutComp*,

        Returns the regular expression "^AboutComp".
    #>

    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter()]
        [SupportsWildcards()]
        [string[]]
        $Pattern
    )

    $Parser = [PowerShell].Assembly.GetType('System.Management.Automation.WildcardPatternToRegexParser')

    $PatternBuilder = [StringBuilder]::new()
    foreach ($wildcardPattern in $Pattern) {
        $RegexPattern = $Parser::Parse(
            [WildcardPattern]::Get(
                $wildcardPattern,
                [WildcardOptions]::IgnoreCase
            )
        )

        if ($PatternBuilder.Length -gt 0) {
            $PatternBuilder.AppendFormat('|{0}', $RegexPattern.ToString()) > $null
        }
        else {
            $PatternBuilder.Append($RegexPattern) > $null
        }
    }

    $PatternBuilder.ToString()
}
