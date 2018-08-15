Describe 'This is a test file only' {
    It 'should check each individual <TestCase>' {
        param($TestCase)
        $TestCaste | Should -BeOfType int
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