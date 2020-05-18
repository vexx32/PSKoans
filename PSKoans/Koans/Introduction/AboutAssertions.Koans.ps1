using module PSKoans
[Koan(Position = 101)]
param()
<#
    Getting Started

    The PowerShell Koans are a set of exercises designed to get you familiar
    with PowerShell. By the time you're done, you'll have a basic understanding
    of the syntax of PowerShell and learn a little more about scripting. This is
    where the fun begins! Each koan contains an example designed to teach you
    something about PowerShell.

    Solving Problems

    If you execute the `Show-Karma` command in your PowerShell console, you will
    get a message that one of the assertions below has failed. Your job is to
    fill in the blanks (the __ / ____ / $____ / '____' tokens) to make it pass.

    Once you make the change(s) necessary and save the file, call `Show-Karma`
    to make sure the koan passes, and continue on to the next failing koan. With
    each passing koan, you'll learn more about PowerShell, and add another tool
    to your PowerShell scripting belt.
#>
Describe 'Equality' {

    It 'is a simple comparison' {
        # Some truths are absolute.
        $____ | Should -Be $true
    }

    It 'expects you to fill in values' {
        # Initiative will be rewarded.
        __ | Should -Be (1 + 2)
        __ + 5 | Should -Be 10
    }

    It 'sets the expectations' {
        # Many roads converge, yet some paths are less clear.
        $ExpectedValue = 1 + 1
        $ActualValue = __

        $ExpectedValue -eq $ActualValue | Should -BeTrue
    }

    # Easy, right? Try one more!

    It 'demands balance' {
        # Both sides of the scale must be of equal measure.
        __ + 2 | Should -Be 3
    }
}
