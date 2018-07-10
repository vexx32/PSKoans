Describe "Strings" {
    It "Is a simple string" {
        "string" | Should -Be __
    }

    Describe "Strings can be literal" {
        $var = 'Some things you must take literally'
        $complexVar = 'They have $ or : or ; or _'
        It 'Is a literal string' {
            $var | Should -Be __
        }
        It 'Can contain special characters' {
            $complexVar | Should be __
        }

    }

    It "Can expand variables" {
        $var = "apple"
        "My favorite fruit is $var" | Should -Be __
    }
}