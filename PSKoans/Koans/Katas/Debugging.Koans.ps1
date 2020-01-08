using module PSKoans
[Koan(Position = 152)]
param()

<#
    Kata: Debugging

    The debugging challenges below are based on some real world examples. Debugging is a critical skill and not one
    which is confined break points.
#>
Describe 'Debugging' {
    Context 'The sticky one' {
        BeforeAll {
            function Debug-Me {
                [CmdletBinding()]
                param (
                    [Parameter()]
                    [string]
                    $ObjectData
                )

                $ObjectData = [PSCustomObject]@{
                    Name = $ObjectData
                }

                if ($ObjectData.Name -eq 'Value') {
                    $true
                } else {
                    $ObjectData
                }
            }
        }

        It 'should return true' {
            Debug-Me | Should -BeExactly $true
        }
    }

    Context 'What about the iterator' {
        BeforeAll {
            function Debug-Me {
                [CmdletBinding(DefaultParameterSetName = 'Default')]
                param (
                    [Parameter()]
                    [string]
                    $InputObject,

                    [Parameter(ParameterSetName = 'Switch')]
                    [switch]
                    $Switch
                )

                switch ($InputObject) {
                    default {
                        'A value'
                    }
                }
            }
        }

        It 'is supposed to return a value' {
             { Debug-Me -InputObject 'Hello world' } | Should -Not -Throw
        }
    }

    Context 'Pay attention to your surroudings' {
        BeforeAll {
            function Debug-Me {
                [CmdletBinding()]
                param (
                    [Parameter(ValueFromPipeline)]
                    [string]
                    $InputObject
                )

                Write-Verbose 'Starting Debug-Me'

                process
                {
                    Write-Verbose "Working on $InputObject"
                }
            }
        }

        It 'should not be returning anything' {
            Debug-Me -InputObject 'a value' | Should -BeNullOrEmpty
        }
    }

    Context 'But the blog said this would work' {
        BeforeAll {
            function Debug-Me {
                $process = Get—Process -Id $PID
                if ($process -and $process.Name -eq 'powershell') {
                    Write-Host 'you must be using PowerShell'
                }
            }
        }

        It 'should not be broken' {
            { Debug-Me } | Should -Not -Throw
        }
    }

    Context 'Something is leaking' {

    }
}
