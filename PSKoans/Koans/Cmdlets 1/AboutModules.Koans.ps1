using module PSKoans
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
    <#
        Get-Module is used to find out which modules are presently loaded into
        the session, or to search available modules on the computer.
    #>
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
    <#
        Find-Module is very similar to Get-Module, except that it searches all
        registered PSRepositories in order to find a module available for
        install.
    #>
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

        $Module = Find-Module -Name 'Pester' | Select-Object -First 1
    }

    It 'finds modules that can be installed' {
        '__' | Should -Be $Module.Name
    }

    It 'lists the latest version of the module' {
        '__' | Should -Be $Module.Version
    }

    It 'indicates which repository stores the module' {
        <#
            Unless an additional repository has been configured, all modules
            from Find-Module will come from the PowerShell Gallery.
        #>
        '__' | Should -Be $Module.Repository
    }
    It 'gives a brief description of the module' {
        '__' | Should -Match  $Module.Description
    }
}

Describe 'New-Module' {
    <#
        New-Module is rarely used in practice, but is capable of dynamically generating
        a module in-memory without needing a file on disk.
    #>

    It 'creates a dynamic module object' {
        $Module = New-Module -Name 'PSKoans_TestModule' -ScriptBlock {}
        $Module | Should -Not -BeNullOrEmpty
    }

    It 'has many properties with $null defaults' {
        # For most modules, ModuleBase lists their primary storage location
        __ | Should -Be $Module.ModuleBase
    }

    It 'supplies the module with a GUID based random path' {
        '__' | Should -Be $Module.Path
    }

    AfterAll {
        Remove-Module -Name 'PSKoans_TestModule'
    }
}

Describe 'Import-Module' {
    <#
        Import-Module is an auxiliary cmdlet that imports the requested module
        into the current session. It is capable of both importing
    #>
    Context 'Importing Installed Modules' {
        BeforeAll {
            $Module = New-Module -Name 'PSKoans_ImportModuleTest' {}
        }

        It 'does not produce output' {
            Import-Module $Module | Should -BeNull
        }

        It 'imports the module into the current session' {
            $ImportedModule = Get-Module -Name 'PSKoans_ImportModuleTest'

            $ImportedModule.ExportedCommands.Keys | Should -BeNull
            '__' | Should -Be $ImportedModule.Name
        }
    }

    Context 'Importing Module From File' {
        BeforeAll {
            $ModuleScript = {
                function Test-ModuleFunction {
                    __ # Fill in the correct value here
                }
                Export-ModuleMember 'Test-ModuleFunction'
            }
            $ModuleScript.ToString() | Set-Content -Path 'TestDrive:\TestModule.psm1'
        }

        It 'does not produce output' {
            Import-Module 'TestDrive:\TestModule.psm1' | Should -Be NullOrEmpty
        }

        It 'imports the module into the current session' {
            $ImportedModule = Get-Module -Name '__'
            $ImportedModule | Should -Not -BeNullOrEmpty
        }

        It 'makes the module''s exported commands available for use' {
            @('__') | Should -Be $ImportedModule.ExportedCommands.Keys
        }
    }

    AfterAll {
        Remove-Module -Name 'TestModule', 'PSKoans_ImportModuleTest'
    }
}
<#
    Other *-Module Cmdlets

    Check out the other module cmdlets with:

        Get-Help *-Module
        Get-Command -Noun Module

    You'll need Install-Module to install new ones, at least!
#>
