function Get-PSKoan {
    [CmdletBinding(DefaultParameterSetName = 'IncludeModule',
        HelpUri = 'https://github.com/vexx32/PSKoans/tree/master/docs/Get-PSKoan.md')]
    [OutputType('PSKoans.KoanInfo')]
    param(
        [Parameter()]
        [SupportsWildcards()]
        [string[]]
        $Topic,

        [Parameter(ParameterSetName = 'ModuleOnly')]
        [SupportsWildcards()]
        [string[]]
        $Module,

        [Parameter(ParameterSetName = 'IncludeModule')]
        [SupportsWildcards()]
        [string[]]
        $IncludeModule,

        [ValidateSet('User', 'Module')]
        [string]
        $Scope = 'Module',

        [Parameter()]
        [switch]
        $SkipAttributeParsing,

        [Parameter(Mandatory, ParameterSetName = 'ListModules')]
        [switch]
        $ListModules
    )

    $ParentPath = switch ($Scope) {
        'User'   { Get-PSKoanLocation }
        'Module' { Join-Path -Path $script:ModuleRoot -ChildPath 'Koans' }
    }

    if ($pscmdlet.ParameterSetName -eq 'ListModules') {
        $moduleList = Join-Path -Path $ParentPath -ChildPath 'Modules' |
            Get-ChildItem -Directory |
            Select-Object -ExpandProperty Name

        return $moduleList
    }

    $KoanDirectories = switch ($pscmdlet.ParameterSetName) {
        'IncludeModule' {
            $Module = $IncludeModule
            Get-ChildItem $ParentPath -Exclude Modules -Directory
        }
        { $Module } {
            $ModuleRegex = ConvertFrom-WildcardPattern -Pattern $Module

            Join-Path -Path $ParentPath -ChildPath 'Modules' |
                Get-ChildItem -Directory |
                Where-Object { $_.Name -match $ModuleRegex }
        }
    }

    $TopicRegex = ConvertFrom-WildcardPattern -Pattern $Topic
    $ParentPathPattern = [regex]::Escape($parentPath)
    # Declared to avoid scope problems when attribute parsing is not required.
    $KoanAttribute = $null
    try {
        $KoanDirectories |
            Get-ChildItem -Recurse -Filter *.Koans.ps1 |
            Where-Object { -not $Topic -or $_.BaseName -replace '\.Koans$' -match $TopicRegex } |
            Assert-UnblockedFile -PassThru |
            ForEach-Object {
                if (-not $SkipAttributeParsing) {
                    $KoanAttribute = Get-KoanAttribute -Path $_.FullName

                    if (-not $KoanAttribute) {
                        return
                    }
                }

                [PSCustomObject]@{
                    Topic        = $_.BaseName -replace '\.koans$'
                    Module       = $KoanAttribute.Module
                    Position     = $koanAttribute.Position
                    Path         = $_.FullName
                    RelativePath = $_.Fullname -replace $ParentPathPattern -replace '^\\'
                    PSTypeName   = 'PSKoans.KoanInfo'
                }
            } |
            Sort-Object { $_.Module -ne '_powershell' }, Module, Position, Topic
    }
    catch {
        $pscmdlet.ThrowTerminatingError($_)
    }
}
