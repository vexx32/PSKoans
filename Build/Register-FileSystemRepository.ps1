[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]
    $Path,

    [Parameter(Mandatory)]
    [string]
    $Name
)

$RepositoryFolder = if (-not (Test-Path $Path)) {
    New-Item -ItemType Directory -Path $Path -Force
}
else {
    Get-Item -Path $Path
}

$Params = @{
    Name                 = $Name
    SourceLocation       = $RepositoryFolder.FullName
    ScriptSourceLocation = $RepositoryFolder.FullName
    InstallationPolicy   = 'Trusted'
}
Register-PSRepository @Params
