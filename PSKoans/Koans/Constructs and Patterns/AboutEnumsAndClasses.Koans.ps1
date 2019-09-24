using module PSKoans
[Koan(Position = 310)]
param()
<#
    About Enumerations and Classes

    Classes in PowerShell
#>
Describe 'About Enumerations and Classes' {
    Context 'Enumerations' {
        <#
            An enumeration can be used to give names to a list of constants.

            .NET contains a great many enumerations, for example, the DayOfWeek enumeration
            which holds values describing the days of the week. For example, Monday:

                [DayOfWeek]::Monday


        #>

        It 'is created using the enum keyword' {
            <#
                An enumeration may be used to describe a set of words.
            #>

            enum ColoursOfTheRainbox {
                Red
                Yellow
                Pink
                Blue
                Orange
                Purple
                Green
            }
        }
    }

    Context 'Simple classes' {
        <#
            A
        #>

    }

    It 'can be built from a hashtable' {
    }
}