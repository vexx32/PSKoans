#Requires -Modules PSKoans

InModuleScope 'PSKoans' {
    Describe 'ConvertFrom-WildcardPattern' {

        It 'adds start and end of string anchors to an explicit value' {
            ConvertFrom-WildcardPattern 'AboutArrays' | Should -Be '^AboutArrays$'
        }

        It 'joins multiple expressions with or' {
            ConvertFrom-WildcardPattern 'AboutArrays', 'AboutComparison' | Should -Be '^AboutArrays$|^AboutComparison$'
        }


        It 'Replaces wildcard characters with regex equivalent' -TestCases @(
            @{ Pattern = 'About*son';    Expected = '^About.*son$' }
            @{ Pattern = 'AboutArrays*'; Expected = '^AboutArrays' }
            @{ Pattern = '*Arrays';      Expected = 'Arrays$' }
            @{ Pattern = '*Array*';      Expected = 'Array' }
        ) {
            param (
                $Pattern,
                $Expected
            )

            ConvertFrom-WildcardPattern $Pattern | Should -Be $Expected
        }
    }
}
