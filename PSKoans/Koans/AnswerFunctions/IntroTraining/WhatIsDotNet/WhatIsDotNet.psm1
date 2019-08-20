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


function JitVsCompiled {
param(
[parameter(mandatory=$true)][JitVsCompledTests]$Test
)   

    If ($test -eq [JitVsCompledTests]::arrivalOne) {
        return "JIT"
    }
    If ($test -eq [JitVsCompledTests]::arrivalTwo) {
        return "Compiled"
    }
    If ($test -eq [JitVsCompledTests]::babelFish) {
        return "JIT"
    }
    If ($test -eq [JitVsCompledTests]::bookPublishers) {
        return "Compiled"
    }
    If ($test -eq [JitVsCompledTests]::UN) {
        return "JIT"
    }


} 

Export-ModuleMember -Function "JitVsCompiled"