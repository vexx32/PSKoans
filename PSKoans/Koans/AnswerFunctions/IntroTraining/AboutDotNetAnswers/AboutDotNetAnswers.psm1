<# 

This is the answer file for PSKoans\IntroTraining\AboutDotNet.koans.ps1

It provides a single function which, when given a test, will provide the correct answer.

#>

enum JitVsCompledTests {
    arrivalOne
    arrivalTwo
    babelFish
    bookPublishers
    UN
}

$ResultsHash = @{
    [JitVsCompledTests]::arrivalOne = "JIT";
    [JitVsCompledTests]::arrivalTwo = "Compiled";
    [JitVsCompledTests]::babelFish = "JIT";
    [JitVsCompledTests]::bookPublishers = "Compiled";
    [JitVsCompledTests]::UN = "JIT";


}
function DotNetTestAnswers {
param(
[parameter(mandatory=$true)][JitVsCompledTests]$Test
)   
<#
.SYNOPSIS
Provides a mechanism for marking Koans in IntroTraining\AboutDotNet.koans.ps1.

.PARAMETER Test
Specify the name of the test you want the result for. 
This must be of the enum type JitVsCompledTests

.INPUTS 
None. You cannot pipe objects through to DotNetTestAnswers.

.OUTPUTS
System.String. DotNetTestAnswers will output a string reading either
'JIT' or 'Compiled' depending on the Test param given.

.EXAMPLE
PS> DotNetTestAnswers -Test arrivalOne

.LINK
https://github.com/Sudoblark/PSKoans

.LINK 
https://github.com/vexx32/PSKoans
#>


    return $ResultsHash[$Test]

} 