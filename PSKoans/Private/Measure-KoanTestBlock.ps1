<#
    .SYNOPSIS
        Counts the number of tests in the given Koan block or file.
    .DESCRIPTION
        Recursively counts all the tests within a Koan file by counting the tests
        in all the blocks of the file.
    .PARAMETER Block
        The block, or file, of Koans to measure.
    .EXAMPLE
        Measure-KoanTestBlock C:\userKoanDir\Foundations\AboutArrays.Koans.ps1

        16
    .NOTES
        Author: Joel Sallow (@vexx32)

#>
function Measure-KoanTestBlock {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject]
        $Block
    )

    $Label = if ($Block.Name) {
        "Block $($Block.Name)"
    }
    else {
        "File $($Block.BlockContainer.Item)"
    }

    $Count = $Block.Tests.Count
    foreach ($testBlock in $Block.Blocks) {
        $Count += Measure-KoanTestBlock $testBlock
    }

    $Count
    Write-Information "$Label Tests: $Count"
}
