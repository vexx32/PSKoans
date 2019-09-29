using module PSKoans
[Koan(Position = 101)]
param()
<#
    Getting Started

    The PowerShell Koans are a set of exercises designed to get you familiar
    with PowerShell. By the time you're done, you'll have a basic
    understanding of the syntax of PoSH and learn a little more
    about scripting in general.

    Answering Problems

    This is where the fun begins! Each koan contains an example designed
    to teach you a lesson about PowerShell. If you execute the program
    defined in this project, you will get a message that the koan below
    has failed. Your job is to fill in the blanks (the __, $__, FILL_ME_IN,
    or $FILL_ME_IN symbols) to make it pass. Once you make the change,
    re-run the program to make sure the koan passes, and continue on to the
    next failing koan. With each  passing koan, you'll learn more about
    PowerShell, and add another weapon to your PowerShell scripting arsenal.
#>
Describe 'Equality' {

    It 'is a simple comparison' {
        # Some truths are absolute.
        '__' | Should -Be 'True!'
    }

    It 'expects you to fill in values' {
        # Initiative will be rewarded.
        __ | Should -Be (1 + 2)
        __ + 5 -eq 10 | Should -BeTrue
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
        __ + 2 -eq 3 | Should -BeTrue
    }
}
