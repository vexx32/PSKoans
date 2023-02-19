#Requires -Modules PSKoans

Describe 'Show-Karma' {

    BeforeAll {
        $module = @{
            ModuleName = 'PSKoans'
        }
        Mock 'Get-PSKoanLocation' {
            "$TestDrive/Koans"
        } @module
        Mock 'Get-PSKoanLocation' {
            "$TestDrive/Koans"
        }

        $EditorSetting = Get-PSKoanSetting -Name Editor

        Reset-PSKoan -Confirm:$false
    }

    AfterAll {
        Set-PSKoanSetting -Name Editor -Value $EditorSetting
    }

    Context 'Default Behaviour' {

        BeforeAll {
            Mock 'Out-Host' @module
            Mock 'Get-Karma' {
                [PSCustomObject]@{
                    PSTypeName   = 'PSKoans.Result'
                    Meditation   = 'TestMeditation'
                    KoansPassed  = 0
                    TotalKoans   = 400
                    Describe     = 'TestDescribe'
                    Expectation  = 'ExpectedTest'
                    It           = 'TestIt'
                    CurrentTopic = [PSCustomObject]@{
                        Name        = 'TestTopic"'
                        Completed   = 0
                        Total       = 4
                        CurrentLine = 1
                    }
                }
            } @module
        }

        It 'should not produce output' {
            Show-Karma | Should -BeNullOrEmpty
        }

        It 'should write the formatted output to host' {
            Should -Invoke 'Out-Host' -Scope Context @module
        }

        It 'should call Get-Karma to examine the koans' {
            Should -Invoke 'Get-Karma' -Scope Context @module
        }
    }

    Context 'With All Koans Completed' {

        BeforeAll {
            Mock 'Out-Host' -Verifiable @module
            Mock 'Get-Karma' -Verifiable {
                [PSCustomObject]@{
                    PSTypeName     = 'PSKoans.CompleteResult'
                    KoansPassed    = 10
                    TotalKoans     = 10
                    RequestedTopci = $null
                    Complete       = $true
                }
            } @module
        }

        It 'should not throw errors' {
            { Show-Karma } | Should -Not -Throw
            Should -InvokeVerifiable
        }
    }

    Context 'With -ClearScreen Switch' {

        BeforeAll {
            Mock 'Clear-Host' @module
            Mock 'Out-Host' @module
            Mock 'Get-Karma' {
                [PSCustomObject]@{
                    PSTypeName   = 'PSKoans.Result'
                    Meditation   = 'TestMeditation'
                    KoansPassed  = 0
                    TotalKoans   = 400
                    Describe     = 'TestDescribe'
                    Expectation  = 'ExpectedTest'
                    It           = 'TestIt'
                    CurrentTopic = [PSCustomObject]@{
                        Name        = 'TestTopic"'
                        Completed   = 0
                        Total       = 4
                        CurrentLine = 1
                    }
                }
            } @module
        }

        It 'should not produce output' {
            Show-Karma -ClearScreen | Should -Be $null
        }

        It 'should clear the screen' {
            Should -Invoke 'Clear-Host' -Scope Context -Times 1 -Exactly @module
        }

        It 'should display the rendered output' {
            Should -Invoke 'Out-Host' -Scope Context @module
        }

        It 'should use Get-Karma to retrieve koan results' {
            Should -Invoke 'Get-Karma' -Scope Context -Times 1 -Exactly @module
        }
    }

    Context 'With Nonexistent Koans Folder / No Koans Found' {

        BeforeAll {
            Mock 'Write-Host' @module
            Mock 'Get-PSKoan' @module
            Mock 'Update-PSKoan' { throw 'Prevent recursion' } @module
            Mock 'Write-Warning' @module
            Mock 'Test-Path' { $false } @module
            Mock 'Invoke-Item' @module
            Mock 'Measure-Koan' @module
        }

        BeforeEach {
            InModuleScope 'PSKoans' { $script:CurrentTopic = $null }
        }

        It 'should attempt to populate koans and then recurse to reassess' {
            { Show-Karma } | Should -Throw -ExpectedMessage 'Prevent recursion'
        }

        It 'should display a warning before initiating a reset' {
            Should -Invoke 'Write-Warning' -Scope Context -Times 1 -Exactly @module
        }

        It 'throws an error if a Topic is specified that matches nothing' {
            { Show-Karma -Topic 'AboutAbsolutelyNothing' } | Should -Throw -ErrorId 'PSKoans.TopicNotFound,Show-Karma'
        }

        It 'should create PSKoans directory with -Library' {
            { Show-Karma -Library } | Should -Throw -ExpectedMessage 'Prevent recursion'

            Should -Invoke 'Test-Path' @module
            Should -Invoke 'Update-PSKoan' -Times 1 -Exactly @module
        }

        It 'should call Get-PSKoan to retrieve the correct file -Contemplate' {
            { Show-Karma -Contemplate } | Should -Throw -ExpectedMessage 'Prevent recursion'

            Should -Invoke 'Get-PSKoan' -Times 1 -Exactly @module
            Should -Invoke 'Update-PSKoan' -Times 1 -Exactly @module
        }
    }

    Context 'With -ListTopics Parameter' {

        BeforeAll {
            Mock 'Get-PSKoan' @module
        }

        It 'should list all the koan topics' {
            Show-Karma -ListTopics
            Should -Invoke 'Get-PSKoan' -Times 1 -Exactly @module
        }
    }

    Context 'With -Topic Parameter' {

        BeforeAll {
            Mock 'Out-Host' -Verifiable @module
            Mock 'Get-Karma' -ParameterFilter { $Topic -eq 'TestTopic' } -Verifiable -MockWith {
                [PSCustomObject]@{
                    PSTypeName     = 'PSKoans.Result'
                    Meditation     = 'TestMeditation'
                    KoansPassed    = 0
                    TotalKoans     = 400
                    Describe       = 'TestDescribe'
                    Expectation    = 'ExpectedTest'
                    It             = 'TestIt'
                    CurrentTopic   = [PSCustomObject]@{
                        Name        = 'TestTopic"'
                        Completed   = 0
                        Total       = 4
                        CurrentLine = 1
                    }
                    RequestedTopic = $Topic
                }
            } @module
        }

        It 'should call Get-Karma on the selected topic' {
            Show-Karma -Topic TestTopic
            Should -InvokeVerifiable
        }
    }

    Context 'With All Koans in a Single Topic Completed' {

        BeforeAll {
            Mock 'Format-Custom' -Verifiable { $null } @module
            Mock 'Out-Host' -Verifiable @module
            Mock 'Get-Karma' -Verifiable {
                [PSCustomObject]@{
                    PSTypeName     = 'PSKoans.CompleteResult'
                    KoansPassed    = 10
                    TotalKoans     = 10
                    RequestedTopic = 'TestTopic'
                    Complete       = $true
                }
            } @module
        }

        It 'should not throw errors' {
            { Show-Karma } | Should -Not -Throw
            Should -InvokeVerifiable
        }
    }

    Context 'With -Contemplate Switch' {

        BeforeAll {
            $TestFile = New-TemporaryFile

            Mock 'Invoke-Item' { $Path } @module
            Mock 'Get-Command' { $true } -ParameterFilter { $Name -ne "missing_editor" } @module
            Mock 'Get-Command' { $false } -ParameterFilter { $Name -eq "missing_editor" } @module
            Mock 'Start-Process' {
                @{ Editor = $FilePath; Arguments = $ArgumentList; NoNewWindow = $NoNewWindow }
            } @module

            Mock 'Get-Karma' {
                $currentTopic = @{
                    Name        = 'TestTopic'
                    Completed   = 0
                    Total       = 4
                    CurrentLine = 1
                }

                [PSCustomObject]@{
                    PSTypeName   = 'PSKoans.Result'
                    Meditation   = 'TestMeditation'
                    KoansPassed  = 0
                    TotalKoans   = 400
                    Describe     = 'TestDescribe'
                    Expectation  = 'ExpectedTest'
                    It           = 'TestIt'
                    CurrentTopic = [PSCustomObject]$currentTopic
                }

                InModuleScope 'PSKoans' -Parameters @{ Topic = $currentTopic } {
                    param($Topic)
                    $script:CurrentTopic = $Topic
                }
            } @module

            Mock 'Get-PSKoan' -ParameterFilter { $Scope -eq 'User' } {
                [PSCustomObject]@{ Path = $TestFile.FullName }
            } @module
        }

        AfterAll {
            $TestFile | Remove-Item
        }

        It 'invokes VS Code with "code" set as Editor with proper arguments' {
            Set-PSKoanSetting -Name Editor -Value 'code'
            $Result = Show-Karma -Contemplate

            $Result.Editor | Should -BeExactly 'code'
            $Result.Arguments[0] | Should -BeExactly '--goto'
            $Result.Arguments[1] | Should -MatchExactly '"[^"]+":\d+'
            $Result.Arguments[2] | Should -BeExactly '--reuse-window'
            $Result.NoNewWindow | Should -BeTrue

            # Resolve-Path doesn't like embedded quotes
            $Path = ($Result.Arguments[1] -split '(?<="):')[0] -replace '"'
            $Path | Should -BeExactly (Resolve-Path -Path $Path).Path

            Should -Invoke 'Get-Command' -Times 1 -Exactly @module
            Should -Invoke 'Start-Process' -Times 1 -Exactly @module

            InModuleScope 'PSKoans' { $script:CurrentTopic } | Should -BeNullOrEmpty
        }


        $moduleCases = @(
            @{ ModuleName = 'ActiveDirectory' }
            @{ ModuleName = 'dbatools' }
        )
        It 'opens the selected editor targeting koans for the <ModuleName> module' -TestCases $moduleCases {
            Set-PSKoanSetting -Name Editor -Value 'code'
            $Result = Show-Karma -Contemplate -Module $ModuleName

            $Result.Editor | Should -BeExactly 'code'
            $Result.Arguments[0] | Should -BeExactly '--goto'
            $Result.Arguments[1] | Should -MatchExactly '"[^"]+":\d+'
            $Result.Arguments[2] | Should -BeExactly '--reuse-window'
            $Result.NoNewWindow | Should -BeTrue

            # Resolve-Path doesn't like embedded quotes
            $Path = ($Result.Arguments[1] -split '(?<="):')[0] -replace '"'
            $Path | Should -BeExactly (Resolve-Path -Path $Path).Path

            Should -Invoke 'Get-Command' -Times 1 -Exactly @module
            Should -Invoke 'Start-Process' -Times 1 -Exactly @module
            Should -Invoke 'Get-Karma' -ParameterFilter { $Module -eq $ModuleName } @module
            Should -Invoke 'Get-PSKoan' -ParameterFilter { $IncludeModule -eq $ModuleName } @module

            InModuleScope 'PSKoans' { $script:CurrentTopic } | Should -BeNullOrEmpty
        }

        It 'opens the specified -Topic in the selected editor' {
            Set-PSKoanSetting -Name Editor -Value 'code'

            $Result = Show-Karma -Contemplate -Topic TestTopic
            $Result.Arguments[1] | Should -MatchExactly ([regex]::Escape($TestFile.FullName))

            Should -Invoke 'Get-Command' -Times 1 -Exactly @module
            Should -Invoke 'Start-Process' -Times 1 -Exactly @module

            InModuleScope 'PSKoans' { $script:CurrentTopic } | Should -BeNullOrEmpty
        }

        It 'invokes the set editor with unknown editor chosen' {
            Set-PSKoanSetting -Name Editor -Value 'vim'

            $Result = Show-Karma -Contemplate
            $Result.Editor | Should -BeExactly 'vim'
            $Result.Arguments | Should -MatchExactly '"[^"]+"'

            # Resolve-Path doesn't like embedded quotes
            $Path = $Result.Arguments -replace '"'
            $Path | Should -BeExactly (Resolve-Path -Path $Path).Path

            Should -Invoke 'Get-Command' -Times 1 -Exactly @module
            Should -Invoke 'Start-Process' -Times 1 -Exactly @module

            InModuleScope 'PSKoans' { $script:CurrentTopic } | Should -BeNullOrEmpty
        }

        It 'opens the file directly when selected editor is unavailable' {
            Set-PSKoanSetting -name Editor -Value "missing_editor"

            Show-Karma -Contemplate | Should -BeExactly $TestFile.FullName

            Should -Invoke 'Get-Command' -Times 1 -Exactly -ParameterFilter { $Name -eq "missing_editor" } @module
            Should -Invoke 'Invoke-Item' -Times 1 -Exactly @module

            InModuleScope 'PSKoans' { $script:CurrentTopic } | Should -BeNullOrEmpty
        }
    }

    Context 'With -Library Switch' {

        BeforeAll {
            Mock 'Get-Command' { $true } -ParameterFilter { $Name -ne "missing_editor" } @module
            Mock 'Get-Command' { $false } -ParameterFilter { $Name -eq "missing_editor" } @module
            Mock 'Start-Process' {
                @{ Editor = $FilePath; Arguments = $ArgumentList }
            } @module
            Mock 'Invoke-Item' { $Path } @module
        }

        It 'invokes VS Code with "code" set as Editor with proper arguments' {
            Set-PSKoanSetting -Name Editor -Value 'code'

            $Result = Show-Karma -Library
            $Result.Editor | Should -BeExactly 'code'

            # Resolve-Path doesn't like embedded quotes
            $Path = $Result.Arguments -replace '"'
            $Path | Should -BeExactly (Resolve-Path -Path $Path).Path

            Should -Invoke 'Get-Command' -Times 1 -Exactly @module
            Should -Invoke 'Start-Process' -Times 1 -Exactly @module
        }

        It 'invokes the set editor with unknown editor chosen' {
            Set-PSKoanSetting -Name Editor -Value 'vim'

            $Result = Show-Karma -Library
            $Result.Editor | Should -BeExactly 'vim'

            # Resolve-Path doesn't like embedded quotes
            $Path = $Result.Arguments -replace '"'
            $Path | Should -BeExactly (Resolve-Path -Path $Path).Path

            Should -Invoke 'Get-Command' -Times 1 -Exactly @module
            Should -Invoke 'Start-Process' -Times 1 -Exactly @module
        }

        It 'opens the file directly when selected editor is unavailable' {
            Set-PSKoanSetting -name Editor -Value "missing_editor"

            Show-Karma -Library | Should -BeExactly (Get-PSKoanLocation)

            Should -Invoke 'Get-Command' -Times 1 -Exactly -ParameterFilter { $Name -eq "missing_editor" } @module
            Should -Invoke 'Invoke-Item' -Times 1 -Exactly @module
        }
    }
}
