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

        @('____', 'beta', '____') |
            Tee-Object -Variable 'Numbers' |
            Should -Be $Values

        '____' | Should -Be $Numbers[0]
        '____' | Should -Be $Numbers[1]
        'gamma' | Should -Be $Numbers[2]
    }

    It 'does not create the variable until the pipeline is completed' {
        $Values = 1..10

        $Values |
            Tee-Object -Variable Test |
            ForEach-Object { $Test | Should -BeNullOrEmpty }

        $Test | Should -Not -BeNullOrEmpty
        $____ | Should -Be $Values
    }

    It 'can also store the object(s) into a file' {
        <#
            $TestDrive, or TestDrive:, refers to a temporary location that is automatically
            cleaned out by Pester when the tests are concluded.
        #>
        $File = New-Item -Path "$TestDrive/TeeObjectTest.txt"

        1..5 |
            ForEach-Object { "{0:N2}" -f (1 / $_) } |
            Tee-Object -FilePath $File.FullName |
            Out-Null

        $Stored = Get-Content -Path $File

        # Text files can only store string data, so be careful storing arbitrary data to files like this.
        @('__', '__', '0.33', '__', '__') | Should -Be $Stored
    }
}
