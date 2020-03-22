#Requires -Modules EZOut
# Install-Module EZOut
# or https://github.com/StartAutomating/EZOut

$VerbosePreference = 'Continue'

$ModuleName = $MyInvocation.MyCommand.Name -replace '\.ezformat\.ps1', ''
$ModuleFolder = Get-Item -Path "$PSScriptRoot/PSKoans" | Select-Object -ExpandProperty FullName

Write-Verbose "Building format file for '$ModuleName' in '$ModuleFolder'"

$formatting = @(
    foreach ($potentialDirectory in 'formatting', 'views') {
        $path = Join-Path $PSScriptRoot -ChildPath $potentialDirectory
        if (Test-Path $path) {
            Get-ChildItem -Path $path | ForEach-Object {
                Write-Verbose "Processing file '$($_.FullName)'"
                Import-FormatView -FilePath $_.FullName
            }
        }
    }
)

if ($formatting) {
    $formatFilePath = Join-Path $ModuleFolder -ChildPath "$ModuleName.format.ps1xml"
    Write-Verbose "Writing format file to '$formatFilePath'"
    $formatting | Out-FormatData -Module $ModuleName | Set-Content $formatFilePath -Encoding UTF8
}

$types = @(
    # Add your own Write-TypeView statements here
)

if ($types) {
    $TypesFile = Join-Path $PSScriptRoot "$ModuleName.types.ps1xml"
    Write-Verbose "Writing types file to '$TypesFile'"
    $types | Out-TypeData | Set-Content $TypesFile -Encoding UTF8
}
