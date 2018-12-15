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

        It 'creates output with properties matching the parameters supplied' {
            $Output.Exception                  | Should -BeOfType $Parameters.Exception.GetType().FullName
            $Output.Exception.Message          | Should -BeExactly $Parameters.Exception.Message
            $Output.ErrorId                    | Should -BeExactly $Parameters.ErrorId
            $Output.ErrorCategory -as [string] | Should -Be $Parameters.ErrorCategory
            $Output.TargetObject	           | Should -BeNullOrEmpty
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
            $Output.GetType() | Should -BeOfType System.Management.Automation.ErrorRecord
        }

        It 'creates output with properties matching the parameters supplied' {
            $Output.Exception                  | Should -BeOfType $Parameters.ExceptionType
            $Output.Exception.Message          | Should -BeExactly $Parameters.ExceptionMessage
            $Output.ErrorId                    | Should -BeExactly $Parameters.ErrorId
            $Output.ErrorCategory -as [string] | Should -Be $Parameters.ErrorCategory
            $Output.TargetObject	           | Should -BeNullOrEmpty
        }
    }
}