using module PSKoans
[Koan(Position = 113)]
param()
<#
    The Pipeline & Loops

    A core tenet of PowerShell scripts is its pipeline. It's mainly just a fancy way
    of iterating over an array of items, so we'll also cover standard loops as well
    to give a comparison.

    Unlike standard loops, where altering the collection you're iterating through is
    considered  a terrible idea, so much so that many languages (including PowerShell)
    actually throw an error if you try, pipelines are designed to break apart a
    collection into its parts and operate on the pieces one at a time.

    As such, modifying the 'collection' mid-pipeline is very common. Pipelines are
    commonly used to take an array of input and perform multiple actions on each item
    before storing or outputting the result.
#>
Describe 'Pipelines and Loops' {
    It 'is used to process input in several stages' {
        # The .. operator is used to quickly create arrays with a range of numbers
        $Values = 1..5
        # Where-Object is a filtering cmdlet, used to discard selected objects mid-pipeline.
        $Values | Where-Object {$_ -lt 3} | Should -Be @(1, 2)
    }

    It 'works with many cmdlets to efficiently process input' {
        <#
            The pipeline takes each element of the array and feeds them one by one
            into the next cmdlet.
        #>
        1..5 | ForEach-Object {
            <#
                ForEach-Object is a cmdlet that utilises the pipeline to create a
                sort of loop, where each object that it receives from the pipeline
                has the same set of actions performed on it.

                In pipeline contexts, you will frequently see $_ or $PSItem variables
                used. These are automatic variables used to denote 'the current
                object in the pipeline'.
            #>
            $_ | Should -Be $PSItem
            <#
                Expressions not stored in a variable are dropped back to the output
                stream. In pipelines, this means that they are passed along to the
                next pipeline command. If a pipeline ends and it is not stored in a
                variable, all output will eventually end up in the main output stream.

                In the console, this will be displayed on screen.
            #>
            $_ + 2
        } | Should -Be __ # What happens to the array after we change each value?
        <#
            Values can be stored at the end of a pipeline by storing the entire
            pipeline sequence in a variable. This will create an array of the final
            values.
        #>
        $Strings = 3..7 |
            ForEach-Object {"Hello $_!"} | # Line breaks after a pipe character are OK!
            Where-Object {$_ -notlike '*5*'} # (Indents are optional.)
        __ | Should -Be $Strings
    }

    It 'is like a specialised loop' {
        <#
            Standard loops are also available in PowerShell, but unlike other languages we
            can still utilise PowerShell's output stream to bundle all their output.
        #>
        $Values = foreach ($Number in 1..5) {
            <#
                In these kinds of loops, the specified variable name ($Number in this case)
                takes the place of the $_ or $PSItem automatic variables instead.
            #>
            $Number
        }
        __ | Should -Be $Values

        $Values = for ($i = 0; $i -lt 5; $i++) {
            # For loops are quite rare in native PowerShell code. They have their uses, but are
            # frequently too semantically obscure to have a place in PS's verbose ecosystem.
            # Remember, ++ after the variable mean assign the value then increment.
            # ++ before the variable means increment and the assign the value.
            $i
        }
        $Values | Should -Be @(0, 1, 2, 3, 4)

        $Values = while ($true) {
            # watch out for infinite loops!

            # Remember: an undeclared variable acts as zero until we increment it!
            # Incrementing a variable won't output the value
            # unless the expression is wrapped in parentheses.
            (++$Tick)

            # An alternative would be the following:
            # $returnvalue = ++$Tick
            # $returnvalue
            # Perhaps slightly more clear but more verbose

            if ($Tick -gt 2) {
                break # the break statement breaks out of the current loop.
            }
        }
        __ | Should -Be $Values

        <#
            There are some other types of loops available, but these are the main ones.
            The reverse of a while loop is an until loop, e.g.:
                until ($condition -eq $true) { Do-Things }

            Similarly, Do..While and Do..Until loops are just like their standard counterparts,
            but will always execute the loop at least once:
                do { Do-Things } until ($condition -eq $true)
        #>
        $Values = do {
            'eat me!'
        } while ($false) # had we put our while at the head of the loop, there would be zero iterations
        __ | Should -Be $Values
    }
}
