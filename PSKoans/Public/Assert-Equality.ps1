function Assert-Equality {
    param(
        [object[]]
        $ReferenceValue,

        [object[]]
        $TestValue
    )
    $TestValue | Should -Be $DifferenceValue
}