function Get-Enlightenment {
	<#
	.NOTES
		Name: Get-Enlightenment
		Author: vexx32
	.SYNOPSIS
		Reflect on your progress and check your answers.
	.DESCRIPTION
		Get-Enlightenment executes Pester against the koans to evaluate if you have made the necessary corrections for success.
	.Parameter Meditate
		Opens your local koan folder.
	.Parameter Reset
		Resets everything in your local koan folder to a blank slate. Use with caution.
	.Parameter Destination
		Defaults to home directory\PSKoans.
    .EXAMPLE
        PS> Get-Enlightenment

        Assesses the results of the Pester tests, and builds the meditation prompt.
    .EXAMPLE
        PS> rake

        Assesses the results of the Pester tests, and builds the meditation prompt.
    .EXAMPLE
        PS> rake -Meditate

        Opens the user's koans folder, housed in $home\PSKoans
    .EXAMPLE
        PS> rake -Reset

        Prompts for confirmation, before wiping out the user's koans folder and restoring it back
        to its initial state.
	#>
	[CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = "Default")]
	[Alias('Rake', 'Invoke-PSKoans', 'Test-Koans')]
	param(

		[Parameter(Mandatory, ParameterSetName = "Meditate")]
		[switch]
		$Meditate,

		[Parameter(Mandatory, ParameterSetName = "Reset")]
		[switch]
		$Reset,

        [parameter()]
        [string]
        $Destination = ($Home | Join-Path -ChildPath 'PSKoans')
	)
	switch ($PSCmdlet.ParameterSetName) {
		"Reset" {
			Initialize-KoanDirectory
		}
		"Meditate" {
			Invoke-Item $Destination
		}
		"Default" {
			Clear-Host
			Write-MeditationPrompt -Greeting

			$PesterTestCount = Invoke-Pester -Script $Destination -PassThru -Show None |
				Select-Object -ExpandProperty TotalCount

			$Tests = Get-ChildItem -Path $Destination -Filter '*.Tests.ps1' -Recurse
			$KoansPassed = 0

			foreach ($KoanFile in $Tests) {
				$PesterTests = Invoke-Pester -PassThru -Show None -Script $KoanFile.FullName
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
					ItName		 = $NextKoanFailed.Name
					Meditation   = $NextKoanFailed.StackTrace
					KoansPassed  = $KoansPassed
					TotalKoans   = $PesterTestCount
				}
				Write-MeditationPrompt @Meditation
			}
		}
	}
} # end function