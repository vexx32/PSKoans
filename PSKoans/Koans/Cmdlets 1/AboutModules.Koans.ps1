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

Describe 'Save-Module'