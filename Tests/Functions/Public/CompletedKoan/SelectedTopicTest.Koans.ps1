using module PSKoans
[Koan(Position = 1)]
param()

Describe 'Koans Test' {

    It 'is easy to solve' {
        $true | Should -BeTrue
    }

    It 'is positively trivial' {
        $false | Should -BeFalse
    }
}
