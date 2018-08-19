#Requires -Module PSKoans
[Koan(Position = 302)]
param()
<#
    StringBuilder

    If you have worked with .NET at any point, you will probably be familiar
    with StringBuilder. It resides in the System.Text namespace, and is
    very good at efficiently building up strings.

    String objects are largely considered immutable in .NET operations,
    and as such actually modifying them or adding onto them directly generally
    causes the entire string to be rebuilt completely with the new value.
    This can be quite costly in terms of performance for large strings; for
    these, we have StringBuilder.
#>
Describe 'System.Text.StringBuilder' {

    Context 'Creating a StringBuilder' {

        It 'can be created with New-Object' {
            # All things, ultimately, are carved from a blank slate.
            $StringBuilder = New-Object System.Text.StringBuilder

            $StringBuilder | Should -BeOfType __
        }

        It 'can be created from a type accelerator' {
            # Control of the initial conditions is sometimes critical.
            $StringBuilder = [System.Text.StringBuilder]::new()
            $SBFromString = [System.Text.StringBuilder]::new('Initial String')
            $SBWithSetCapacity = [System.Text.StringBuilder]::new(10)
            <#
                You can call
                    [System.Text.StringBuilder]::new
                without parentheses in the console to see available overload
                definitions that can be used to construct the object.
            #>
            $StringBuilder, $SBFromString, $SBWithSetCapacity | Should -BeOfType __
            $SBFromString.Length | Should -Be __
        }

        It 'can be created by casting an existing string' {
            # Two sides of a coin.
            [System.Text.StringBuilder]$StringBuilder = 'Initial String'

            $StringBuilder | Should -BeOfType __
        }
    }

    Context 'Appending to a StringBuilder String' {

        It 'can append strings' {
            $StringBuilder = [System.Text.StringBuilder]::new()

            # Quantity comes first. Quality soon follows.
            $StringBuilder.Append('__')
            $StringBuilder.Length | Should -Be 10
        }

        It 'can append new lines' {

        }

        It 'can append format strings' {

        }
    }

    Context 'Constructing the Final String Object' {

        It 'simply returns a string' {

        }

        It 'is no longer a StringBuilder' {

        }

        It 'can be retained and reused' {

        }
    }

    Context 'Other StringBuilder Methods' {

        It 'can be cleared' {

        }

        It 'can copy to a char array' {

        }

        It 'can insert sequences' {

        }

        It 'can remove sequences' {

        }

        It 'can replace existing sequences' {

        }
    }

    Context 'StringBuilder Properties' {

        It 'has only a few properties' {

        }

        It 'indicates the current length of the string' {

        }

        It 'indicates the currently allocated capactity' {

        }

        It 'indicates the maximum capacity of the StringBuilder' {

        }
    }
}