#region Header
if (-not (Get-Module PSKoans)) {
    $moduleBase = Join-Path -Path $psscriptroot.Substring(0, $psscriptroot.IndexOf('\Tests')) -ChildPath 'PSKoans'
    Import-Module $moduleBase -Force
}
#. "C:\Git\PSKoans\PSKoans\Public\Register-Advice.ps1"
#endregion


InModuleScope 'PSKoans'{
Describe "Register-Advice" {
    
    Context "Checkin the Behaviour if ProfileFolder and ProfilePath Not exists" {
        
        Mock Test-Path {$false} -ParameterFilter {$Path -eq $ProfileFolder}
        Mock New-Item {}
        Mock Test-Path {$false} -ParameterFilter {$Path -eq $ProfilePath}
        Mock Set-Content {} -ParameterFilter {$Value -eq "Show-Advice"}

        It "First Step Test-Path Fails and Create a Item" {
            Register-Advice
            Assert-MockCalled -CommandName Test-Path 
        }
        It "Second Step Profile Path fails adding content in the file"{
            Register-Advice
            Assert-MockCalled -CommandName Set-Content -Times 1
        }



    }
    Context "Checkin the Function with other Possible values"{
        Mock Test-Path {$true} -ParameterFilter {$Path -eq $ProfilePath}
        Mock Select-String {$false}
        Mock Add-Content {}
        It "Third Step If file exists but not having the content (Get|Set)-Advice"{
            Register-Advice
            Assert-MockCalled -CommandName Add-Content
        }
    }
    Context "Checkin the behaviour of function with different parameter values"{
        Mock Test-Path {$false} -ParameterFilter {$Path -eq $ProfileFolder}
        Mock New-Item {}
        Mock Test-Path {$false} -ParameterFilter {$Path -eq $ProfilePath}
        Mock Set-Content {} -ParameterFilter {$Value -eq "Show-Advice"}
        It "Should throw if invalid parameter(Targetprofile) value is passed"{
            {Register-Advice -TargetProfile "Invalidvalue"} | Should -Throw
        }
        $testdata = @{1='AllUsersAllHosts'},@{1= 'AllUsersCurrentHost'},@{1='CurrentUserAllHosts'},@{1='CurrentUserCurrentHost'}
        It "Checking with the possible Parameter Values" -TestCases $testdata{
            param($1)
            Register-Advice $1 | should -BeNullOrEmpty 
            
        }

    }

}
}
