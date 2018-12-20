using module PSKoans
[Koan(Position = 206)]
param()
<#
    Measure-Object

    Measure-Object is, as its name implies, a utility cmdlet that
    performs mathematical operations on collections of objects.
#>
Describe 'Measure-Object' {
    BeforeAll {
        $Numbers = @(
            839, 339, 763, 663, 238, 427, 577, 613, 284, 453
            850, 130, 250, 843, 669, 972, 572, 41, 172, 155
            729, 616, 285, 231, 128, 540, 204, 584, 407, 98
            668, 85, 320, 435, 87, 719, 936, 25, 75, 122
            665, 154, 943, 35, 391, 816, 420, 229, 3, 938
        )

        $Files = Get-ChildItem -Path $home -Recurse -Depth 2
    }

    It 'can count objects' {
        $Numbers |
            Measure-Object -Count |
            Select-Object -ExpandProperty Count |
            Should -Be __

        $Files |
            Measure-Object -Count |
            Select-Object -ExpandProperty Count |
            Should -Be __
    }

    It 'can sum numerical objects' {
        $StopIndex = __

        $Numbers[0..$StopIndex] |
            Measure-Object -Sum |
            Select-Object -ExpandProperty Sum |
            Should -Be 6046
    }

    It 'can average numerical objects' {
        $StartIndex = __

        $Numbers[$StartIndex..25] |
            Measure-Object -Average |
            Select-Object -ExpandProperty Average |
            Should -Be 421.5
    }

    It 'can find the largest or smallest value' {
        $StopIndex = __

        $Values = $Numbers[5..$StopIndex] |
            Measure-Object -Minimum -Maximum

        $Values.Minimum | Should -Be 130
        $Values.Maximum | Should -Be 972
    }

    It 'can find multiple values at once' {
        $StartIndex = __
        $StopIndex = __

        $Values = $Numbers[$StartIndex..$StopIndex] |
            Measure-Object -Average -Minimum -Sum

        $Values.Average | Should -Be 377
        # 'Count' is always present in the data from Measure-Object
        $Values.Count | Should -Be 11
        $Values.Minimum | Should -Be 85
        $Values.Sum | Should -Be 4147
    }

    It 'can operate on object properties' {
        $Data = $Files.BaseName | Measure-Object -Property Length -Sum -Average
        __ | Should -Be $Data.Sum
        __ | Should -Be $Data.Average
    }

    It 'can measure text lines, characters, and words of strings' {
        $Text = Get-Content "$(Get-PSKoanLocation)/Foundations/AboutTheStockChallenge.Koans.ps1"
        $Data = $Text | Measure-Object -Line -Word -Character

        __ | Should -Be $Data.Lines
        __ | Should -Be $Data.Words
        __ | Should -Be $Data.Characters
    }
}
