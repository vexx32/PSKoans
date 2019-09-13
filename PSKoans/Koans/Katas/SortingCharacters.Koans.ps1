using module PSKoans
[Koan(Position = 151)]
param()

<#
    Kata: Sorting Characters

    Sorting is a fairly common task in programming. In PowerShell, the Sort-Object cmdlet will typically
    be used to sort items.

    For the purposes of this kata, cmdlets will be removed from your toolkit.

    Using only native PowerShell expressions (values, operators, and keywords), implement a function that
    sorts all characters in a string alphabetically. Punctuation and spaces should be ignored entirely.
#>
Describe 'Kata - Sorting Characters' {
    BeforeAll {
        $Verification = {
            [string[]]$AllowedCommands = @()
            [string[]]$AllowedVariables = @("*")
            $Function = Get-Item -Path 'Function:Get-SortedString'
            $Function.ScriptBlock.CheckRestrictedLanguage($AllowedCommands, $AllowedVariables, $false)
        }

        function Get-SortedString {
            param($String)

            # Add your solution code here!

        }
    }

    <#
        Feel free to add extra It/Should tests here to write additional tests for yourself and
        experiment along the way!
    #>

    It 'should not use any cmdlets or external commands' {
        $Verification | Should -Not -Throw -Because 'You must rely on your own knowledge here.'
    }

    It 'should give the right result when inputting: <String>' {
        param( $String, $Result )

        Get-SortedString $String | Should -BeExactly $Result
    } -TestCases @(
        @{
            String = 'Mountains are merely mountains.'
            Result = 'aaaeeeiilMmmnnnnoorrssttuuy'
        }
        @{
            String = 'What do you call the world?'
            Result = 'aacddehhlllooorttuwWy'
        }
        @{
            String = 'Out of nowhere, the mind comes forth.'
            Result = 'cdeeeeffhhhimmnnooOoorrstttuw'
        }
        @{
            String = 'Because it is so very clear, it takes longer to come to the realization.'
            Result = 'aaaaaBccceeeeeeeeeghiiiiiklllmnnoooooorrrrsssstttttttuvyz'
        }
        @{
            String = 'The hands of the world are open.'
            Result = 'aaddeeeefhhhlnnoooprrstTw'
        }
        @{
            String = 'You are those huge waves sweeping everything before them, swallowing all in their path.'
            Result = 'aaaaabeeeeeeeeeeeefgggghhhhhhiiiiillllmnnnnoooopprrrrsssstttttuuvvwwwwyY'
        }
    )
}
