#Requires -Module PSKoans
[Koan(Position = 212)]
param()
<#
    Modules

    PowerShell is built from various types of modules, which come in three flavours:
        - Script modules
        - Manifest modules
        - Binary modules

    Manifest modules are the least common, consisting only of a single .psd1 file;
    their primary code is often stored in a core library of PowerShell and is not
    considered part of 'the module' itself, merely exposed by it.

    Binary modules are compiled from C# using the PowerShell libraries and tend to
    be in .dll formats with other files providing metadata.

    Script modules commonly consist of .psm1, .psd1, .ps1 and other files, and are
    one of the more common module types.
#>
Describe 'Get-Module' {

    It 'returns a list of modules in the current session' {
        # To list all installed modules, use the -ListAvailable switch.

        $Modules = Get-Module
        $FirstThreeModules = @('__', '__', '__')
        $VersionOfThirdModule = '__'
        $TypeOf6thModule = '__'

        $FirstThreeModules | Should -Be $Modules[0..2].Name
        $VersionOfThirdModule | Should -Be $Module[2].Version
        $TypeOf6thModule | Should -Be $Modules[5].ModuleType
    }

    It 'can filter by module name' {
        $Pester = Get-Module -Name 'Pester'

        $ThreeExportedCommands = @('__', '__', '__')

        $ThreeExportedCommands | Should -BeIn $Pester.ExportedCommands.Values.Name
    }

    It 'can list nested modules' {
        $AllModules = Get-Module -All

        $Axioms = $AllModules | Where-Object Name -eq 'Axiom'

        $Commands = @('__', '__', '__')
        $Commands | Should -BeIn $Axioms.ExportedCommands.Values.Name
        <#
            Despite us being able to 'see' this module, we cannot use its commands as it
            is only available in Pester's module scope.
        #>
        {if ($Commands[1] -in $Axioms.ExportedCommands.Values.Name) {
            & $Commands[1]
        }} | Should -Throw
    }
}

Describe 'Find-Module' {
    BeforeAll {
        <#
            This will effectively produce similar output to the Find-Module cmdlet
            while only searching the local modules instead of online ones. 'Mock'
            is a Pester command that will be covered later.
        #>
        Mock Find-Module {
            Get-Module -ListAvailable -Name $Name |
                Select-Object -Property Version, Name, @{
                Name       = 'Repository'
                Expression = {'PSGallery'}
            }, Description
        }
    }
}

Describe 'Save-Module' {

}