using module PSKoans
[Koan(Position = 110)]
param()
<#

    Numbers

    In PowerShell, we can use many different data types to represent numbers. All differ slightly in 
    what they can and can't do. The two most common ones are:

        Intergers
                Represent whole numbers. This is the default numeric data type that PowerShell uses

        Doubles
                Represents numbers with decimal places

   So 10 will be an integer and 10.0 will be a double. Why does this matter? Work through the examples
   below to find out.

#>

Describe 'Basic Number Types' {

    Context 'Double' {

        It 'can result from an operational involving multiple types of numbers' {

            $Int = 10
            $Double = 10.0

            'System.____' | Should -Be $Int.GetType().Fullname
            'System.____' | Should -Be $Double.GetType().Fullname

            $Result = $Int * $Double
            # What type results when you multiply integers and doubles?
            'System.____' | Should -Be $Result.GetType().Fullname
        }
    }

    Context 'Intergers' {

        It 'has to be a whole number' {

            $Pi = [Math]::PI
            function HelloWorld([Int32]$Int) {
                $Int
            }

            'System.____' | Should -be $Pi.GetType().Fullname
            # What number will return if you pass Pi into an int function?
            ___ -eq (HelloWorld -Int $Pi) | Should -BeTrue
        }
    }
}

Describe "Banker's Rounding" {

    It 'rounds to nearest even number on .5' {

        # Try and guess how PowerShell will round these numbers
        ____ | Should -Be ([Int32]2.5)
        ____ | Should -Be ([Int32]3.34)
        ____ | Should -Be ([Int32]10.61)
        ____ | Should -Be ([Int32]12.7)
            
        }
}
