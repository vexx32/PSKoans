Describe 'New-KoanRunspace' {

    BeforeAll {
        [runspace]$runspace = $null
    }

    AfterEach {
        $runspace.Dispose()
    }

    It 'creates a new runspace' {
        $runspace = InModuleScope 'PSKoans' { New-KoanRunspace }
        $runspace | Should -BeOfType [runspace]
    }

    It 'names the new runspace' {
        $runspace = InModuleScope 'PSKoans' { New-KoanRunspace }
        $runspace.Name | Should -Be 'PSKoans.KoanRunspace'
    }

    It 'preloads the runspace with PSKoans' {
        $runspace = InModuleScope 'PSKoans' { New-KoanRunspace }
        $ps = [powershell]::Create($runspace)

        try {
            $ps.AddCommand('Get-Module').AddParameter('Name', 'PSKoans') > $null
            $module = $ps.Invoke()
            $module.Name | Should -eq 'PSKoans'
        }
        finally {
            $ps.Dispose()
        }
    }
}
