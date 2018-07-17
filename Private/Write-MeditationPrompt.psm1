function Write-MeditationPrompt {
	<#
	.NOTES
		Name: Write-MeditationPrompt
		Author: vexx32
	.SYNOPSIS
		Provides "useful" output for enlightenment results.
	.DESCRIPTION
		Provides a mechanism for Get-Enlightenment to write clean output. 
	#>
	[CmdletBinding(DefaultParameterSetName = 'Meditation')]
	param(
		[Parameter(Mandatory, ParameterSetName = "Meditation")]
		[ValidateNotNullOrEmpty()]
		[string]
		$DescribeName,

		[Parameter(Mandatory, ParameterSetName = "Meditation")]
		[ValidateNotNullOrEmpty()]
		[string]
		$Expectation,

		[Parameter(Mandatory, ParameterSetName = "Meditation")]
		[ValidateNotNullOrEmpty()]
		[string]
		$ItName,

		[Parameter(Mandatory, ParameterSetName = "Meditation")]
		[ValidateNotNullOrEmpty()]
		[string]
		$Meditation,

		[Parameter(Mandatory, ParameterSetName = "Meditation")]
		[ValidateNotNull()]
		[int]
		$KoansPassed,

		[Parameter(Mandatory, ParameterSetName = "Meditation")]
		[ValidateNotNull()]
		[int]
		$TotalKoans,

		[Parameter(Mandatory, ParameterSetName = 'Greeting')]
		[switch]
		$Greeting
	)

	$Red = @{ForegroundColor = "Red"}
	$Blue = @{ForegroundColor = "Cyan"}
	$Koan = $Script:ZenSayings | Get-Random
	$SleepTime = @{Milliseconds = 500}

	if ($PSCmdlet.ParameterSetName -eq 'Greeting') {
		Write-Host -ForegroundColor Cyan @"
Welcome, seeker of enlightenment.
Please wait a moment while we examine your karma...

"@
return
}
Write-Host @Red @"
{Describe "$DescribeName"} has damaged your karma.
"@
Start-Sleep @SleepTime
Write-Host @Blue @"

You have not yet reached enlightenment.

The answers you seek...

"@
	Write-Host @Red @"
$Expectation
"@
Start-Sleep @SleepTime
Write-Host @Blue @"

Please meditate on the following code:

"@
Write-Host @Red @"
[It] $ItName
$Meditation
"@
Start-Sleep @SleepTime
Write-Host @Blue @"

$($Koan -replace "`n","`n    ")

Your path thus far:

"@
	$ProgressAmount = "$KoansPassed/$TotalKoans"
	[int]$ProgressWidth = $host.UI.RawUI.WindowSize.Width * 0.8 - ($ProgressAmount.Length + 4)
	$PortionDone = ($KoansPassed / $TotalKoans) * $ProgressWidth

	" [{0}{1}] {2}" -f @(
		"$([char]0x25a0)" * $PortionDone
		"$([char]0x2015)" * ($ProgressWidth - $PortionDone)
		$ProgressAmount
	) | Write-Host @Blue
	Write-Host @Blue @"

You may run 'rake -Meditate' to begin your meditation.

"@
}