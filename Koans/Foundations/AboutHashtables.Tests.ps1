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

        It 'can be built all in one line' {
            $Hashtable = @{Name = 'Bob'; Species = 'Tardigrade'; Weakness = 'Phys'}

            $Hashtable['Species'] | Should -Be '__'
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

        It 'is a reference type' {
            $HashtableOne = @{
                Name = "Jim"
                Age  = 12
            }

            $HashtableTwo = $HashtableOne
            $HashtableTwo['Age'] = 21

            $HashtableOne['Age'] | Should -Be 12 # Right?
            $HashtableTwo['Age'] | Should -Be __
        }

        It 'can be cloned' {
            # Instead of passing a reference to the original, we can copy it!
            $HashtableOne = @{
                'Meal Type' = 'Dinner'
                Calories    = 1287
                Contents    = 'Carrots', 'Fish', 'Gherkin', 'Rice', 'Celery'
            }
            $HashtableTwo = $HashtableOne.Clone()
            $HashtableTwo['Meal Type'] = 'Snack'
            $HashtableTwo['Calories'] = 250
            $HashtableTwo['Contents'] = 'Chips'

            $HashtableOne['Meal Type'] | Should -Be '__'
            $HashtableOne['Calories'] | Should -Be __

            $HashtableTwo['Contents'] | Should -Be '__'
        }

        It 'allows you to retrieve a list of keys or values' {
            $Hashtable = @{One = 1; Two = 2; Three = 3; Four = 4}

            $Hashtable.Keys | Should -Be @('__', '__', '__', '__')
            $Hashtable.Values | Should -Be @( , , , 4)
        }

        It 'allows you to remove keys' {
            $Hashtable = @{
                One   = 1
                Two   = 2
                Three = 3
                Four  = 4
            }

            $Hashtable.Remove('One')

            $Hashtable.Count | Should -Be __
            $Hashtable.Keys | Should -Be @('__', '__', 'Four')
            $Hashtable.Values | Should -Be @( , , 4)
        }

        It 'can check if keys or values are present in the hashtable' {
            $Hashtable = @{
                # Enter keys and values in this table to make the below tests pass
            }

            $Hashtable.ContainsKey('Apples') | Should -BeTrue
            $Hashtable.ContainsValue('Fruit') | Should -BeTrue

            $Hashtable['Oranges'] | Should -Be 'Fruit'
            $Hashtable['Apples'] | Should -Not -Be $Hashtable['Oranges']
        }

        It 'will implicitly convert keys and lookup values' {
            $Hashtable = @{0 = 'Zero'}

            $Hashtable[0] | Should -Be '__'
            $Hashtable['0'] | Should -Be '__'
        }
    }
}