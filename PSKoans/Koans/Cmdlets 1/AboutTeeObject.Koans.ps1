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
        1..10 | Tee-Object -Variable __ | Should -Be $n
    }

    It 'can store the object(s) into a variable' {
        # Note the variable name is passed as a string, without the $!
        'alpha', 'beta', 'gamma' | Tee-Object -Variable 'Numbers' | Should -Be $Numbers
        '__' | Should -Be $Numbers[1]
    }

    It 'can also store the object(s) into a file' {
        $File = New-TemporaryFile

        $Output = 1..5 | ForEach-Object {"{0:N2}" -f (1 / $_)} | Tee-Object -FilePath $File.FullName
        $Stored = $File | Get-Content

        __ | Should -Be $Stored
    }
}
