try {
    Add-AssertionOperator -Name Fail -Test {
        param ($ActualValue, [switch] $Negate, [string] $Because)

        # look at  https://github.com/pester/Pester/blob/master/Functions/Assertions/BeTrueOrFalse.ps1
        # for inspiration, or here https://mathieubuisson.github.io/pester-custom-assertions/

        if ($Negate) {
            return [PSCustomObject]@{
                Succeeded      = $false
                FailureMessage = "Should -Not -Fail is not a valid assertion."
            }
        }

        if (-not $Because) {
            $Message = "The test failed, because the script reached the Should -Fail command call."
        }
        else {
            $Reason = ($Because.Trim().TrimEnd('.') -replace '^because\s', '')
            $Message = "The test failed, because $Reason."
        }

        [PSCustomObject]@{
            Succeeded      = $false
            FailureMessage = $Message
        }
    }
}
catch { }
