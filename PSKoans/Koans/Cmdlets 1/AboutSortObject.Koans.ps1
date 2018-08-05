#Requires -Module PSKoans
[Koan(Position = 211)]
param()
<#
    Sort-Object

    Sort-Object is the most common pipeline-collating cmdlet. It is extremely useful
    when sorting a collection of objects, and is capable of fairly sophisticated
    sorting methods as you require.

    However, note that it is a collating cmdlet; it will pause the pipeline where it
    is called in order to sort everything into the specified order. This can slow
    down processing, and as a result it is recommended to sort your collection as
    late in the pipeline sequence as possible.
#>
Describe 'Sort-Object' {

}