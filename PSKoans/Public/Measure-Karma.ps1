using namespace System.Management.Automation

class KoanTopics : IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        $Values = Get-ChildItem -Path $env:PSKoans_Folder -Recurse -Filter '*.Koans.ps1' |
            Sort-Object -Property BaseName |
            ForEach-Object {
            $_.BaseName -replace '\.Koans$'
        }

        return $Values
    }
}

function Measure-Karma {
    <#
	.SYNOPSIS
        Reflect on your progress and check your answers.
    .DESCRIPTION
        Measure-Karma executes Pester against the koans to evaluate if you have made the necessary
        corrections for success.
    .PARAMETER Topic
        Execute koans only from the selected Topic(s).
    .PARAMETER ListTopics
        Output a complete list of available koan topics.
    .PARAMETER Contemplate
        Opens your local koan folder.
	.PARAMETER Reset
        Resets everything in your local koan folder to a blank slate. Use with caution.
    .EXAMPLE
        PS> Measure-Karma

        Assesses the results of the Pester tests, and builds the meditation prompt.
    .EXAMPLE
        PS> meditate -Contemplate

        Opens the user's koans folder, housed in '$home\PSKoans'. If VS Code is in $env:Path,
        opens in VS Code.
    .EXAMPLE
        PS> Measure-Karma -Reset

        Prompts for confirmation, before wiping out the user's koans folder and restoring it back
        to its initial state.
    .LINK
        https://github.com/vexx32/PSKoans
	.NOTES
        Author: Joel Sallow
        Module: PSKoans
	#>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = "Default")]
    [Alias('Invoke-PSKoans', 'Test-Koans', 'Get-Enlightenment', 'Meditate', 'Clear-Path')]
    param(
        [Parameter(ParameterSetName = 'Default')]
        [Alias('Koan', 'File')]
        [ValidateSet([KoanTopics])]
        [string[]]
        $Topic,

        [Parameter(Mandatory, ParameterSetName = 'ListKoans')]
        [Alias('ListKoans')]
        [switch]
        $ListTopics,

        [Parameter(Mandatory, ParameterSetName = "OpenFolder")]
        [Alias('Meditate')]
        [switch]
        $Contemplate,

        [Parameter(Mandatory, ParameterSetName = "Reset")]
        [switch]
        $Reset
    )
    switch ($PSCmdlet.ParameterSetName) {
        'ListKoans' {
            Get-ChildItem -Path $env:PSKoans_Folder -Recurse -File -Filter '*.Koans.ps1' |
                ForEach-Object {
                    $_.BaseName -replace '\.Koans$'
                }
        }
        'Reset' {
            Write-Verbose "Reinitializing koan directory"
            Initialize-KoanDirectory
        }
        'OpenFolder' {
            Write-Verbose "Opening koans folder"
            if (Get-Command -Name 'Code' -ErrorAction SilentlyContinue) {
                Start-Process -FilePath 'code' -ArgumentList $env:PSKoans_Folder -NoNewWindow
            }
            else {
                Invoke-Item $env:PSKoans_Folder
            }
        }
        "Default" {
            Clear-Host

            Write-MeditationPrompt -Greeting

            Write-Verbose 'Sorting koans...'
            $SortedKoanList = Get-ChildItem -Path $env:PSKoans_Folder -Recurse -Filter '*.Koans.ps1' |
                Where-Object {
                    -not $PSBoundParameters.ContainsKey('Topic') -or
                    $_.BaseName -replace '\.Koans$' -in $Topic
                } |
                Get-Command {$_.FullName} |
                Where-Object {$_.ScriptBlock.Attributes.TypeID -match 'KoanAttribute'} |
                Sort-Object {
                    $_.ScriptBlock.Attributes.Where( {$_.TypeID -match 'KoanAttribute'}).Position
                }

            Write-Verbose 'Counting koans...'
            $TotalKoans = $SortedKoanList | Measure-Koan

            if ($TotalKoans -eq 0) {
                # Something's wrong; possibly a koan folder from older versions, or a folder exists but has no files
                Write-Warning 'No koans found in your koan directory. Initiating full reset...'
                Initialize-KoanDirectory
                Measure-Karma @PSBoundParameters # Re-call ourselves with the same parameters

                return # skip the rest of the function
            }

            $KoansPassed = 0

            foreach ($KoanFile in $SortedKoanList.Path) {
                Write-Verbose "Testing karma with file [$KoanFile]"

                $PesterParams = @{
                    Script   = $KoanFile
                    PassThru = $true
                    Show     = 'None'
                }

                # Execute in a fresh scope to prevent internal secrets being leaked
                Invoke-Koan @PesterParams

                $KoansPassed += $PesterTests.PassedCount

                Write-Verbose "Karma: $KoansPassed"
                if ($PesterTests.FailedCount -gt 0) {
                    Write-Verbose 'Your karma has been damaged.'
                    break
                }
            }

            if ($PesterTests.FailedCount -gt 0) {
                $NextKoanFailed = $PesterTests.TestResult |
                    Where-Object Result -eq 'Failed' |
                    Select-Object -First 1

                $Meditation = @{
                    DescribeName = $NextKoanFailed.Describe
                    Expectation  = $NextKoanFailed.ErrorRecord
                    ItName       = $NextKoanFailed.Name
                    Meditation   = $NextKoanFailed.StackTrace
                    KoansPassed  = $KoansPassed
                    TotalKoans   = $TotalKoans
                }

                if ($PSBoundParameters.ContainsKey('Topic')) {
                    $Meditation.Add('Topic', $Topic)
                }

                Write-MeditationPrompt @Meditation
            }
            else {
                $Meditation = @{
                    Complete    = $true
                    KoansPassed = $KoansPassed
                    TotalKoans  = $PesterTestCount
                }

                if ($PSBoundParameters.ContainsKey('Topic')) {
                    $Meditation.Add('Topic', $Topic)
                }

                Write-MeditationPrompt @Meditation
            }
        }
    }
}