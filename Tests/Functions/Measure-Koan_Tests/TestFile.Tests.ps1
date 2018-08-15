Describe 'This is a test file only' {
    It 'should check each individual <TestCase>' {
        param($TestCase)
        $TestCaste | Should -Throw
    } -TestCases @{
        TestCase = 1
    },
    @{
        TestCase = 2
    },
    @{
        TestCase = 3
    }
}