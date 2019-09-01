using module PSKoans
[Koan(Position = 209)]
param()
<#
    Tee-Object

    Tee-Object is a utility cmdlet that splits the path of pipeline
    objects. It directly passes through all objects that it receives,
    as well as storing a copy of the items either in a file or variable.
#>
Describe 'Tee-Object' {

    It 'passes the object on through the pipeline' {
        # The value passed to -Variable is created as a new variable
        $Value = 10
        __ | Tee-Object -Variable Tee | Should -Be $Value
    }

    It 'can store the object(s) into a variable' {
        # Note the variable name is given as a string, without the $ prefix.
        $Values = 'alpha', 'beta', 'gamma'
        @('____', '____', '____', '____') | Tee-Object -Variable 'Numbers' | Should -Be $Values
        '____' | Should -Be $Numbers[1]
    }

    It 'can also store the object(s) into a file' {
        $File = New-TemporaryFile

        $Output = 1..5 | ForEach-Object { "{0:N2}" -f (1 / $_) } | Tee-Object -FilePath $File.FullName
        $Stored = Get-Content -Path $File

        # Text files can only store string data, so be careful storing arbitrary data to files like this.
        @('__', '__', '3', '__', '__') | Should -Be $Stored
    }
}
