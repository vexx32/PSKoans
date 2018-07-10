Describe "Strings" {
    It "Is a simple string" {
        "string" | Should -Be __
    }

    Describe "Strings can be literal" {
        It 'Is a literal string' {
            'Literally typed string' | Should -Be __
        }
        It 'Can contain special characters' {
            'American currency is denoted by: $' | Should be __
        }

    }

    It "Can expand variables" {
        $var = "apple"
        "My favorite fruit is $var" | Should -Be __
    }
}