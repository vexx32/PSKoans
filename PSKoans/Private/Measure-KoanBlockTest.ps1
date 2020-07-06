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
