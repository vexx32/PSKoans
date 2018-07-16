<#
    Type Operators

    -is and -isnot are used to verify the type of an object, whereas -as is used to cast or convert
    an object to another type entirely.

    For more detailed information, refer to 'Get-Help about_Type_Operators'
#>
Describe 'Type Operators' {

    Context 'Is and IsNot Operators' {

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

    Context 'As Operator' {

        It 'is used to convert objects to other types' {
            $Value = '__'
            $Value | Should -BeOfType [string]

            $NewValue = $Value -as [int]
            $NewValue | Should -BeOfType [int]
        }
    }
}