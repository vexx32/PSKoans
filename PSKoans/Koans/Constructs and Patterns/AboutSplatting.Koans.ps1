using module PSKoans
[Koan(Position = 305)]
param()
<#
    Splatting

    'Splatting' is a term of indistinct origin in programming, but the general idea is that rather
    than passing parameters to a function or method individually, you collect the values together
    in some form of collection, and then 'splat' the various parameters all at once into the
    command. This can help minimise code duplication and significantly improve readability in
    PowerShell

    PowerShell supports two kinds of splatting; one utilising arrays, and the other, hashtables.
    In both cases, the parameter object is first defined and stored in a $Variable. This is then
    'splatted' into the command by specifying the variable name with an @ symbol: @Variable
#>
Describe 'Splatting' {

    Context 'Hashtable Splatting' {
        <#
            Splatting truly shines when it comes to hashtables. All cmdlet parameters, including
            switches, can be folded into a hashtable.
        #>
        It 'helps keep code tidy' {
            # Here are a few common ways a detailed command to find files in a folder might be written:

            # 1. Super long lines; hard to follow along with.
            $LongLines = Get-ChildItem -Path $env:PSKoans:KoanFolder -Include '*.ps1' -Recurse -Depth 2

            # 2. Escaping linebreaks; more readable, but very fragile and prone to errors
            $Escaping = Get-ChildItem `
                -Path $env:PSKoans:KoanFolder `
                -Include '*.ps1' `
                -Recurse `
                -Depth 2

            # 3. Splatting using a hashtable. Note the similarity to #2 and fill in missing values.
            $Parameters = @{
                Path    = ${env:PSKoans:KoanFolder}
                Include = '__'
                Recurse = $true # Switches can be assigned a boolean value.
                Depth   = __
            }
            $Splatted = Get-ChildItem @Parameters
            <#
                All above approaches are equal in effect, but splatting is a much tidier and more
                maintainable approach.
            #>
            $Splatted | Should -Be $Escaping
            $Escaping | Should -Be $LongLines

            $LongLines | Should -Be $Splatted
        }

    }

    Context 'Advanced Splatting Techniques' {

        It 'can be built up in parts' {
            $Parameters = @{Path = $env:PSKoans:KoanFolder }

            $Value = __
            if ($Value -eq 7) {
                $Parameters.Add('File', $true)
            }
            else {
                $Parameters.Add('Directory', $true)
            }

            Get-ChildItem @Parameters | Select-Object -First 1 | Should -BeOfType System.IO.FileInfo
        }

        It 'can be built from automatic hashtables' {
            $String = "Folders:__"
            $Parameters = if ($String -match 'Folders:(?<Filter>[a-z ])$') {
                $Matches.Remove(0) # Remove the 'whole' match and keep only the portions we asked for
                $Matches.Clone()
            }
            $Parameters.Add('Path', $env:PSKoans:KoanFolder)
            $Parameters.Add('Directory', $true)
            (Get-ChildItem @Parameters).Count | Should -Be 2
        }
    }
}