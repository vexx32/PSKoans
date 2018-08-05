function Get-Enlightenment {
    <#
	.NOTES
		Name: Get-Enlightenment
		Author: vexx32
	.SYNOPSIS
		Reflect on your progress and check your answers.
	.DESCRIPTION
        Get-Enlightenment executes Pester against the koans to evaluate if you have made the necessary
        corrections for success.
	.PARAMETER Meditate
		Opens your local koan folder.
	.PARAMETER Reset
        Resets everything in your local koan folder to a blank slate. Use with caution.
    .EXAMPLE
        PS> Get-Enlightenment

        Assesses the results of the Pester tests, and builds the meditation prompt.
    .EXAMPLE
        PS> rake

        Assesses the results of the Pester tests, and builds the meditation prompt.
    .EXAMPLE
        PS> rake -Meditate

        Opens the user's koans folder, housed in $home\PSKoans. If VS Code is in $env:Path, opens in
        VS Code.
    .EXAMPLE
        PS> rake -Reset

        Prompts for confirmation, before wiping out the user's koans folder and restoring it back
        to its initial state.
    .LINK
        https://github.com/vexx32/PSKoans
	#>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = "Default")]
    [Alias('Rake', 'Invoke-PSKoans', 'Test-Koans')]
    param(
        [Parameter(Mandatory, ParameterSetName = "Meditate")]
        [switch]
        $Meditate,

        [Parameter(Mandatory, ParameterSetName = "Reset")]
        [switch]
        $Reset
    )
    switch ($PSCmdlet.ParameterSetName) {
        "Reset" {
            Initialize-KoanDirectory
        }
        "Meditate" {
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

            $SortedKoanList = Get-ChildItem "$env:PSKoans_Folder" -Recurse -Filter '*.Koans.ps1' |
                Get-Command {$_.FullName} |
                Where-Object {$_.ScriptBlock.Attributes.TypeID -match 'KoanAttribute'} |
                Sort-Object {
                $_.ScriptBlock.Attributes.Where( {
                        $_.TypeID -match 'KoanAttribute'
                    }).Position
            } | Select-Object -ExpandProperty Path

            $PesterParams = @{
                Script   = $SortedKoanList
                PassThru = $true
                Show     = 'None'
            }
            $PesterTestCount = Invoke-Pester @PesterParams |
                Select-Object -ExpandProperty TotalCount

            $KoansPassed = 0

            foreach ($KoanFile in $SortedKoanList) {
                $PesterParams = @{
                    Script   = $KoanFile
                    PassThru = $true
                    Show     = 'None'
                }
                $PesterTests = Invoke-Pester @PesterParams
                $KoansPassed += $PesterTests.PassedCount

                if ($PesterTests.FailedCount -gt 0) {
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
                    TotalKoans   = $PesterTestCount
                }
                Write-MeditationPrompt @Meditation
            }
            else {
                $Meditation = @{
                    Complete    = $true
                    KoansPassed = $KoansPassed
                    TotalKoans  = $PesterTestCount
                }
                Write-MeditationPrompt @Meditation
            }
        }
    }
}