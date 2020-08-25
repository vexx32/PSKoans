#Requires -Modules PSKoans

Describe 'ConvertFrom-WildcardPattern' {

    It 'adds start and end of string anchors to an explicit value' {
        InModuleScope 'PSKoans' { ConvertFrom-WildcardPattern 'AboutArrays' } | Should -Be '^AboutArrays$'
    }

    It 'joins multiple expressions with |' {
        InModuleScope 'PSKoans' { ConvertFrom-WildcardPattern 'AboutArrays', 'AboutComparison' } |
            Should -Be '^AboutArrays$|^AboutComparison$'
    }

    It 'replaces wildcard characters with regex equivalent' -TestCases @(
        @{ Pattern = 'About*son'; Expected = '^About.*son$' }
        @{ Pattern = 'AboutArrays*'; Expected = '^AboutArrays' }
        @{ Pattern = '*Arrays'; Expected = 'Arrays$' }
        @{ Pattern = '*Array*'; Expected = 'Array' }
    ) {
        InModuleScope 'PSKoans' -Parameters @{ Pattern = $Pattern } {
            param($Pattern)

            ConvertFrom-WildcardPattern $Pattern
        } | Should -Be $Expected
    }
}
