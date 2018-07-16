<#
    Type Operators

    -is and -isnot are used to verify the type of an object, whereas -as is used to cast or convert
    an object to another type entirely.

    For more detailed information, refer to 'Get-Help about_Type_Operators'
#>

    Context 'Is and IsNot' {

        It 'examines the type of the left hand object' {
            45 -isnot [double] | Should -BeTrue
            'string' -is [__] | Should -BeTrue
        }

        It 'is useful for determining available methods' {
            $Value = __

            if ($Value -is [double]) {
                $Value | Should -BeOfType [__]
            }
        }
    }