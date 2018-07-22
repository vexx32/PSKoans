#Requires -Module PSKoans
[Koan(112)]
param()
<#
    Hashtables

    Hashtables are a more advanced type of collection than arrays, and use string keys as a kind of
    'index' rather than index numbers. A simple PowerShell hashtable can be created with a hash
    literal, which looks like this:

    @{
        Key  = 'Value'
        Age  = 12
        Name = "Robert '); DROP TABLE 'STUDENTS'"
    }

    Hashtables are more difficult to iterate over than arrays, but have the advantage of being able
    to more easily access exactly the item you want from the collection. In the above example, it's
    quite simple to access only the Age or Name value, as you please.

    Hashtables are also frequently used as input to many more customisable parameters for
    PowerShell cmdlets.
#>
Describe 'Hashtables' {

    Context 'Building Hashtables' {

        It 'can be built with a hash literal' {
            # A hash literal is similar to the array literal @(), just with curly braces
            $Hashtable = @{
                # Hashtables always consist of key/value pairs
                Name     = 'Hashtable'
                Color    = 'Blue'
                Spectrum = 'Ultraviolet'
            }

            $Hashtable | Should -BeOfType __
            # Values in the hashtable can be retrieved by specifying their corresponding key
            $Hashtable['Color'] | Should -Be '__'
            $Hashtable['Spectrum'] | Should -Be '__'
        }

        It 'can be built in pieces' {
            $Hashtable = @{}
            # By specifying a key, we can insert or overwrite values in the hashtable
            $Hashtable['Name'] = 'Hashtable'
            $Hashtable['Color'] = 'Red'
            $Hashtable['Spectrum'] = 'Infrared'
            $Hashtable['Spectrum'] = 'Microwave'

            $Hashtable['Color'] | Should -Be '__'
            $Hashtable['Spectrum'] | Should -Be '__'
        }

        It 'can be built using the Hashtable object methods' {
            $Hashtable = @{}
            $Hashtable.Add('Name', 'John')
            $Hashtable.Add('Age', 52)
            $Hashtable.Add('Radiation', 'Infrared')

            $Hashtable['Age'] | Should -Be __
        }
    }

    Context 'Working with Hashtables' {

    }
}