using module PSKoans
[Koan(Position = 310)]
param()
<#
    About Enumerations

    Enumerations are used to give names to lists of constant values. Enumerations are very widely used in the .NET
    framework and frequently encountered in PowerShell.

    Examples in this topic use Start-Job to avoid problems when continually loading a type in the current
    PowerShell session. Enumeration values demonstrated in this section are cast to String within the jobs,
    otherwise PowerShell will return only the numeric value from the job.
#>
Describe 'About Enumerations' {
        <#
            The DayOfWeek enumeration which holds values describing the days of the week is a simple example
            of an existing .NET enumeration.
        #>

        Context 'Using enumerations' {
            It 'exposes the values of an enumeration in a number of different ways' {
                # Using the static property operator.

                [DayOfWeek]::____ | Should -BeOfType [DayOfWeek]

                # Casting a string to the enumeration type.

                [DayOfWeek]'____' | Should -BeOfType [DayOfWeek]

                # Using the -as operator to convert a string to the enumeration type.

                '____' -as [DayOfWeek] | Should -BeOfType [DayOfWeek]
            }

            It 'can retrieve all names in an enumeration with the GetEnumNames method' {
                $daysOfWeek = @('____', '____', '____', '____', '____', '____', '____')

                $daysOfWeek | Should -Be ([DayOfWeek].GetEnumNames())

                # The [Enum] type provides an alternative method of getting the same information.

                [Enum]::GetNames([DayOfWeek]) | Should -Be $daysOfWeek
            }

            It 'each name has an associated numeric value' {
                <#
                    In the DayOfWeek enumeration, Sunday has the value 0, and Monday has
                    the value 1, and so on.
                #>

                [DayOfWeek]::____ | Should -Be 2
            }

            It 'the list of possible values can be retrieved using the GetEnumValues method' {
                <#
                    The values of an enumeration are displayed in much the same way as the name,
                    with one important difference.

                    GetEnumNames returns an array of strings, the names of the values only.

                    GetEnumValues returns an array of values, which will be presented as the names.
                #>

                [DayOfWeek].GetEnumValues() | Select-Object -First 1 | Should -BeOfType [DayOfWeek]

            It 'the numeric type behind an enumeration depends on the enumeration' {
                <#
                    Enumerations in the .NET framework, and those created in languages such as C#
                    can be of any numeric type.

                    The type can be found using the GetEnumUnderlyingType method.
                #>

                '____' | Should -Be ([DayOfWeek].GetEnumUnderlyingType().Name)

                # Many enums use Int32 as the underlying type. A few use other numeric types.

                '____' | Should -Be ([System.Security.AccessControl.AceFlags].GetEnumUnderlyingType().Name)
            }

            It 'is created using the enum keyword' {
                <#
                    In PowerShell enumerations are created using the enum keyword.

                    All names in an enumeration have a value behind them. In some cases the value
                    may not be important, only the word. The simplest of enumerations is a list of
                    words.

                    The following restrictions apply to the names used in an enumeration:

                        * Must start with A-Z, a-z, or _.
                        * May contain A-Z, a-z, _, and 0-9.
                        * Cannot use other special characters.
                #>

                $enumNames = Start-Job -ScriptBlock {
                    enum ColourOfTheRainbow {
                        Red
                        Yellow
                        Pink
                        Green
                        Purple
                        Orange
                        Blue
                    }

                    [ColourOfTheRainbow].GetEnumNames()
                } | Receive-Job -Wait

                $colours = @('____', '____', '____', '____', '____', '____', '____')

                $enumNames | Should -Be $colours
            }

            It 'values can be important too' {
                <#
                    Each value in an enumeration can be assigned an explicit value.

                    By default values are automatically assigned starting from 0. PowerShell
                    only allows the use of Int32 values in an enumeration. Any decimal values will
                    be rounded to an integer.
                #>

                $script = {
                    enum Number {
                        One = 1
                        Two = 2
                    }

                    # Numeric values can be cast or converted to an enumeration value.

                    $using:Value -as [Number] -as [String]
                }

                $Value = 2
                $Name = Start-Job -ScriptBlock $script | Receive-Job -Wait

                '____' | Should -Be $Name

                <#
                    Automatic numbering may still be used. Automatic numbering continues incrementing
                    from the last value assigned.
                #>

                $Value = 'Six'
                $NumericValue = Start-Job -ScriptBlock $script | Receive-Job -Wait

                __ | Should -Be $NumericValue
            }

            It 'does not require explicit casting to compare values' {
                <#
                    In PowerShell the value on the right hand side of an operator is coerced into the type
                    of the value on the left hand side of an operator.
                #>

                $script = {
                    enum Number {
                        One = 1
                        Two = 2
                    }

                    [Number]1 -eq $using:Name
                }

                $Name = '____'
                Start-Job -ScriptBlock $script | Receive-Job -Wait | Should -BeTrue
            }
        }

        Context 'About Flags' {
            <#
                The flags attribute can be used to indicate that an enumeration represents a series of
                flags.

                This allows more than one value in the enumeration to be used at once.

                .NET makes extensive use of flags based enumerations, from Internet security protocols,
                to file system rights.
            #>

            It 'Each flag is reprsented by a single bit' {
                <#
                    A name in the enumeration normally represents a single bit in a numeric value.

                    PowerShell enumerations use Int32, 32 unique flags can be expressed in an enumeration.
                    Each value will be double that of the last. Therefore expected values are 1, 2, 4, 8, 16, and so on.
                    These are the values of individual bits.

                    The [Flags()] attribute is placed above the enum keyword.

                    The example below is based on 4 different flags.
                #>

                $script = {
                    [Flags()]
                    enum Bit {
                        None = 0
                        Bit1 = 1
                        Bit2 = 2
                        Bit3 = 4
                        Bit4 = 8
                    }

                    $using:Value -as [Bit] -as [String]
                }

                $Value = 2
                $Name = Start-Job -ScriptBlock $script | Receive-Job -Wait

                '____' | Should -Be $Name

                # When more than one flag is described, the value returned is a comma separated list.

                $Value = 2 -bor 8 # 10
                $Name = Start-Job -ScriptBlock $script | Receive-Job -Wait

                '____' | Should -Be $Name
            }

            It 'a comma separated list can be cast to the enum value' {
                # A list of names can be converted to a single flag value.

                $script = {
                    [Flags()]
                    enum Bit {
                        None = 0
                        Bit1 = 1
                        Bit2 = 2
                        Bit3 = 4
                        Bit4 = 8
                    }

                    $using:Names -as [Bit] -as [Int32]
                }

                # The names are a single string, not an array. Spaces are discarded when converting the value.

                $Names = '____, ____'
                $Value = Start-Job -ScriptBlock $script | Receive-Job -Wait

                $Names | Should -Be $Value
            }

            It 'allows you to test for flags' {
                <#
                    A value which has multiple flags set is provided as a single value.

                    The presence of individual bits can be tested in either of two ways.

                    The HasFlag may be called on an enumeration value:
               #>

                $script = {
                    [Flags()]
                    enum Bit {
                        None = 0
                        Bit1 = 1
                        Bit2 = 2
                        Bit3 = 4
                        Bit4 = 8
                    }

                    $BitValue = [Bit]$using:Value

                    $BitValue.HasFlag([Bit]$using:FlagName)
                }

                $Value = 10
                $FlagName = '____'

                Start-Job -ScriptBlock $script | Receive-Job -Wait | Should -BeTrue

                # The bitwise operator, -band, can also be used to test for the presence of specific flags.

                $script = {
                    [Flags()]
                    enum Bit {
                        None = 0
                        Bit1 = 1
                        Bit2 = 2
                        Bit3 = 4
                        Bit4 = 8
                    }

                    $BitValue = [Bit]$using:Value

                    # -band will return the result of the bitwise AND. 0, or the same value as FlagName.
                    $BitValue -band $FlagName
                }

                $Value = 10
                $FlagName = '____'

                Start-Job -ScriptBlock $script | Receive-Job -Wait | Should -BeGreaterThan 0
            }

            It 'can use values representing a combination of flags' {
                <#
                    The .NET enumeration System.Security.AccessControl.FileSystemRights is a Flags-based
                    enumeration used to represent NTFS access rights.

                    The enumeration contains several values which are composites of several different flags.
                    This technique is used to simplify the set of flags, making it easier to understand and use.

                    The enumeration below contains two different composite values.
                #>

                $script = {
                    [Flags()]
                    enum ObjectType {
                        User         = 1
                        Group        = 2
                        UserAndGroup = 3
                        Computer     = 4
                    }

                    $individualValues = $using:Names -as [ObjectType]
                    $compositeValue = $using:CompositeName -as [ObjectType]

                    $individualValues -eq $compositeValue
                }

                $CompositeName = '____'
                $Names = 'User, Group'

                Start-Job -ScriptBlock $script | Receive-Job -Wait | Should -BeTrue

                # Individual values that match a composite are automatically replaced with the name of the composite value.

                $script = {
                    [Flags()]
                    enum ObjectType {
                        User         = 1
                        Group        = 2
                        UserAndGroup = 3
                        Computer     = 4
                    }

                    $using:Names -as [ObjectType] -as [String]
                }

                $CompositeName = '____, ____'
                $Names = 'User, Group, Computer'

                Start-Job -ScriptBlock $script | Receive-Job -Wait | Should -Be $CompositeName
            }
        }

        Context 'Enumerations and parameters' {
            <#
                An enumeration can be used to define the type for a parameter. This can be used as an
                alternative to ValidateSet in some cases.
            #>

            It 'can be used instead of ValidateSet for a parameter' {
                <#
                    Using the enumeration as the parameter type will offer tab-completion
                    to anyone using the function.
                #>

                $TypeName = Start-Job -ScriptBlock {
                    enum ObjectType {
                        User
                        Group
                    }

                    function Get-Object {
                        [CmdletBinding()]
                        param (
                            [ObjectType]
                            $Type
                        )

                        $Type -as [String]
                    }

                    Get-Object -Type User
                } | Receive-Job -Wait

                '____' | Should -Be $TypeName
            }

            It 'will raise an error if the parameter value is incorrect' {
                # If an invalid value is supplied, an error will be raised stating the permitted values.

                $script = {
                    enum ObjectType {
                        User
                        Group
                    }

                    function Get-Object {
                        [CmdletBinding()]
                        param (
                            [ObjectType]$Type
                        )

                        $Type -as [String]
                    }

                    Get-Object -Type Computer
                }

                # The error message is long, a partial match is enough.
                $errorMessage = '____'

                { Start-Job -ScriptBlock $script | Receive-Job -Wait -ErrorAction Stop } |
                    Should -Throw -ExpectedMessage $errorMessage
            }
        }

        Context 'PowerShell Enumeration Scope' {
            It 'creates PowerShell enumerations in the local scope' {
                <#
                    Classes and enumerations are resolvable in the scope they are created and child scopes. They
                    are not available in parent scopes by default.
                #>

                $Values = Start-Job -ScriptBlock {
                    enum ObjectType {
                        User
                        Group
                    }

                    # The enumeration can be used in the current scope

                    'User' -as [ObjectType] -as [String]

                    function Get-Object {
                        # The enumeration can be used in child scopes

                        'Group' -as [ObjectType] -as [String]
                    }

                    Get-Object
                } | Receive-Job -Wait

                @('____', '____') | Should -Be $Values
            }

            It 'can import enumerations with using module' {
                <#
                    The using module statement can be used at the top of a script to make enumerations
                    and classes within a module available in a parent scope.
                #>

                $Value = Start-Job -ScriptBlock {
                    $modulePath = Join-Path -Path $using:TestDrive -ChildPath 'EnumModule.psm1'

                    Set-Content -Path $modulePath -Value @'
                        enum ObjectType {
                            User
                            Group
                        }
'@

                    <#
                        Creating a script block avoids a complaint about how using statements must appear
                        first in a script for this example.

                        Ordinarily the path to, or name of, the module would be a fixed value.
                    #>

                    & ([ScriptBlock]::Create("
                        using module $modulePath

                        'User' -as [ObjectType] -as [String]
                    "))
                } | Receive-Job -Wait

                '____' | Should -Be $Value
            }
        }
    }
}
