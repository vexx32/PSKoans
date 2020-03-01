#Requires -Modules PSKoans

Describe 'New-PSKoanErrorRecord' {

    Context 'With Exception Object' {

        BeforeAll {
            $Output, $Parameters = InModuleScope 'PSKoans' {
                $Params = @{
                    Exception     = [Exception]::new('Test message')
                    ErrorId       = 'Test.ErrorId'
                    ErrorCategory = 'NotSpecified'
                    TargetObject  = $null
                }
                New-PSKoanErrorRecord @Params
                $Params
            }
        }

        It 'creates an ErrorRecord object' {
            $Output | Should -BeOfType System.Management.Automation.ErrorRecord
        }

        It 'emits the same type of exception' {
            $Output.Exception | Should -BeOfType $Parameters.Exception.GetType().FullName
        }

        It 'includes the input exception message' {
            $Output.Exception.Message | Should -BeExactly $Parameters.Exception.Message
        }

        It 'emits the correct error ID with "PSKoans" prefix' {
            $Output.FullyQualifiedErrorId | Should -BeExactly "PSKoans.$($Parameters.ErrorId)"
        }

        It 'assigns the requested error category' {
            $Output.CategoryInfo.Category | Should -Be $Parameters.ErrorCategory
        }

        It 'assigns the target object' {
            $Output.TargetObject | Should -Be $Params.TargetObject
        }
    }

    Context 'With TypeName and Message' {

        BeforeAll {
            $Output, $Parameters = InModuleScope 'PSKoans' {
                $Params = @{
                    ExceptionType    = 'Exception'
                    ExceptionMessage = 'Test message'
                    ErrorId          = 'Test.OtherErrorId'
                    ErrorCategory    = 'NotSpecified'
                    TargetObject     = $null
                }
                New-PSKoanErrorRecord @Params
                $Params
            }
        }

        It 'creates an ErrorRecord object' {
            $Output | Should -BeOfType System.Management.Automation.ErrorRecord
        }

        It 'creates the correct type of exception' {
            $Output.Exception | Should -BeOfType $Parameters.ExceptionType
        }

        It 'applies the requested exception message' {
            $Output.Exception.Message | Should -BeExactly $Parameters.ExceptionMessage
        }

        It 'emits the correct error ID with "PSKoans" prefix' {
            $Output.FullyQualifiedErrorId | Should -BeExactly "PSKoans.$($Parameters.ErrorId)"
        }

        It 'assigns the requested error category' {
            $Output.CategoryInfo.Category | Should -Be $Parameters.ErrorCategory
        }

        It 'assigns the target object' {
            $Output.TargetObject | Should -Be $Params.TargetObject
        }
    }
}
