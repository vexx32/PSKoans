enum Test {
    NorwayFjordsSchematics
    Eyjafjallajokull
    CoventrySchematics
    Mars
    doggoNose
    doggoBark
    doggoWoof
    doggoTail
    phoneVibrating
    keyboardColour
    lightPower
    toast 
}

$ResultsHash = @{

        [Test]::NorwayFjordsSchematics = 'object';
        [Test]::Eyjafjallajokull = 'instance';
        [Test]::CoventrySchematics = 'object';
        [Test]::Mars = 'instance';
        [Test]::doggoNose = $true;
        [Test]::doggoBark = $false;
        [Test]::doggoWoof = $true;
        [Test]::doggoTail = $true;
        [Test]::phoneVibrating = $true;
        [Test]::keyboardColour = $false;
        [Test]::lightPower = $false;
        [Test]::toast = $true;
}
function OOPTestAnswers {
param(
[parameter(mandatory=$true)][Test]$Test
)
    return $ResultsHash[$Test]
}