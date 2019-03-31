using module PSKoans
[Koan(Position = 601)]
param()
<#
    Redirection
    The PowerShell streams are numbered in order from 1-6.
    Stream #	Description	        Introduced in
    --------	-----------	        -------------
    1	        Success Stream	    PowerShell 2.0
    2	        Error Stream	    PowerShell 2.0
    3	        Warning Stream	    PowerShell 3.0
    4	        Verbose Stream	    PowerShell 3.0
    5	        Debug Stream	    PowerShell 3.0
    6	        Information Stream	PowerShell 5.0
    *	        All Streams	        PowerShell 3.0
    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_redirection?view=powershell-6
#>
Describe 'Redirection Operators' {
    BeforeAll {
        $OriginalDebugPreference = $DebugPreference
        $OriginalVerbosePreference = $VerbosePreference
        $FilePath = 'TestDrive:\TestFile.txt'

        $DebugPreference = $VerbosePreference = 'Continue'
    }

    It 'can be used to redirect output to files' {
        # Providing a path will send output to that location, creating the file if necessary.
        'I see mountains once again as mountains,' > $FilePath
        $FileContent = Get-Content -Path $FilePath

        '__' | Should -Be $FileContent
    }

    It 'can append to files' {
        # Appending to existing files adds a new line.
        'And waters once again as waters.' >> $FilePath
        $FileContent = Get-Content -Path $FilePath

        @( 'I see mountains once again as mountains,', '__' ) | Should -Be $FileContent
    }

    It 'can use numbered streams' {
        Write-Output 'The stream flows forth with successes!' 1> $FilePath
        $FileContent = Get-Content -Path $FilePath
        '__' | Should -Be $FileContent

        & { Write-Error 'The gasoline is in the water.' } 2> $FilePath
        $FileContent = Get-Content -Path $FilePath

        "__ : __" | Should -Be $FileContent[0]
        "+ CategoryInfo          : NotSpecified: (:) [Write-Error], WriteErrorException" | Should -Be $FileContent[1]
        "+ FullyQualifiedErrorId : Microsoft.PowerShell.Commands.WriteErrorException" | Should -Be $FileContent[2]

        Write-Warning 'The cat swatted at the dog.' 3> $FilePath
        $FileContent = Get-Content -Path $FilePath
        '__' | Should -Be $FileContent

        Write-Verbose 'The sun is round.' 4> $FilePath
        $FileContent = Get-Content -Path $FilePath
        '__' | Should -Be $FileContent

        Write-Debug 'Debug' 5> $FilePath
        $FileContent = Get-Content -Path $FilePath
        '__' | Should -Be $FileContent

        Write-Information 'Hark a fly!' 6> $FilePath
        $FileContent = Get-Content -Path $FilePath
        '__' | Should -Be $FileContent
    }

    It 'can be used to merge streams' {
        function Test-MergeStream {
            Write-Warning 'The waters are upon the mountains.'
            Write-Output 'The hills are alive with the sound of tulips.'
        }

        Test-MergeStream 3>&1 > $FilePath
        $FileContent = Get-Content -Path $FilePath

        @( 'The waters are upon the mountains.', '__' ) | Should -Be $FileContent

    }

    It 'can merge multiple streams at once' {
        function Test-AllMerge {
            [CmdletBinding()]
            param()

            Write-Output 'And within every dewdrop'
            Write-Warning 'A world of dew,'
            Write-Verbose 'A world of struggle.'
            Write-Information 'A world within the world.'
        }

        # *> will merge all streams with any content into the same output pat
        Test-AllMerge *> $FilePath
        $FileContent = Get-Content -Path $FilePath

        @(
            '__'
            '__'
            '__'
            '__'
        ) | Should -Be $FileContent
    }

    It 'can be used to redirect streams to files' {
        # Outputting to a file without appending will overwrite it completely
        Write-Information 'Truth can be expressed without speaking, nor remaining silent.' 6> $FilePath
        $FileContent = Get-Content -Path $FilePath

        '__' | Should -Be $FileContent
    }

    It 'can be used to suppress output' {
        'All things return to the void' > $null | Should -BeNullOrEmpty
        $Data = __

        $Data | Should -Not -BeNullOrEmpty
        $Data > $null | Should -BeNullOrEmpty
    }

    AfterAll {
        $DebugPreference = $OriginalDebugPreference
        $VerbosePreference = $OriginalVerbosePreference
    }
}