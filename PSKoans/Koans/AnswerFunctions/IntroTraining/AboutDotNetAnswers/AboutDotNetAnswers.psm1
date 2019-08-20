<# 

This is the answer file for PSKoans\IntroTraining\WhatIsDotNot.koans.ps1

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

    return $ResultsHash[$Test]

} 