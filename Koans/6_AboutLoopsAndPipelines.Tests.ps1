<#
    The Pipeline & Loops

    A core tenet of PowerShell scripts is its pipeline. It's mainly just a fancy way of iterating
    over an array of items, so we'll also cover standard loops as well to give a comparison.

    Unlike standard loops, where altering the collection you're iterating through is considered
    a terrible idea, so much so that many languages (including PowerShell) actually throw an
    error if you try, pipelines are designed to break apart a collection into its parts and
    operate on the pieces one at a time.

    As such, modifying the 'collection' mid-pipeline is very common. Pipelines are commonly used
    to take an input and perform multiple actions before storing or outputting the result.
#>

Describe "Pipelines and Loops" {

}