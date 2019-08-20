using module PSKoans
[Koan(Position = 103)]
param()
<#
    What is .NET?

    PowerShell is based on .NET. .NET acts as our translator; it turns what we write in PowerShell
    into machine code that can actually run (1s and 0s).

    Why is this important? Well as long as we have the right combination of .NET and PowerShell
    then our code can run virtually anywhere! How's that for a bag of chips?

    Specifically, the element of .NET that does this translation is called the Common Language
    Runtime, or CLR. 

    Our code is translated just-in-time as and when it's run. This is opposed to a compiled
    language - such as C# - where code is translated first and we always run the translation.

    Comparing the two...

    - JIT tends to be more portable, as we can run it anywhere with the right interpreter
    - Compiled is faster, but requires compiling for each system it will run on

    As PowerShell uses .NET for its translation, we can directly reference it if we want.
    For example, C# creates windows forms using .NET... but we can do the same thing in 
    PowerShell by directly referencing the .NET object.

    Don't worry too much about this, as we'll cover it in more depth later, but it's 
    definetely benefical to know for your scripting career!

    There's an ASCII diagram below to try and help you get your head around this:

                        +------------+
                        | PowerShell |
                        +------+-----+
                               |
                               v
                    +-------------+-------------------+
                    |  Common Language Runtime (CLR)  |
                    +-------------+-------------------+
                                  |
                    +-------------v-------------------+
                    |  Native Code                    |
                    +------------+--------------------+
                                 |
                                 |
                                 |
                            +----v-----+
                            |  Hello   |
                            |          |  ----- Computer
                            |  World   |
                            +----------+


Below are some more relatable examples of JIT and Compiled languages in action, but
you'll have to guess which is which! 

#>

$RelativePath = ".\AnswerFunctions\IntroTraining\AboutDotNetAnswers\AboutDotNetAnswers.psd1"
Import-Module $RelativePath

Describe "JIT or Compiled" {

    It 'arrival-part_1' {
        <#
        The plot line of the movie “Arrival” involves humans and 
        aliens attempting to talk to each other. They don’t just do word-for-word 
        translations, they fundamentally have different ways of thinking about the world. 

        When the main character attempts to understand the aliens, 
        she translates line-by-line what they’re saying to make 
        it understandable to those around her.

        Would this be an example of language being JIT or Compiled?
        #>

        # Replace __ with either 'jit' or 'compiled'
        $Answer = '__'
        $Answer -eq (DotNetTestAnswers -Test arrivalOne) | Should -BeTrue `
        -Because "arrival-part_1 answer is either jit or compiled"
    }

    It 'arrival-part_2' {
        <#
            Later on in the movie “Arrival” the character attempts to 
            communicate back to the aliens. She works out what she wants to say 
            ahead of time, creates the translation and then presents it to the aliens.

            Would this be an example of language being JIT or Compiled?
        #>

        # Replace __ with either 'jit' or 'compiled'
        $Answer = '__'
        $Answer -eq (DotNetTestAnswers -Test arrivalTwo) | Should -BeTrue `
        -Because "arrival-part_2 answer is either jit or compiled"
    }

    It 'babelFish' {
        <#
            The Babel Fish. If you’re unfamiliar with the Babel Fish, it’s an entity 
            in “Hitchhiker’s Guide to the Galaxy”. Specifically, it allows an individual 
            to “instantly understand anything said to you in any form of language”. 
            It directly translates language in real-time, by taking the sound 
            waves in your ear and translating them to your own language.

            Would this be an example of language being JIT or Compiled?
        #>

        # Replace __ with either 'jit' or 'compiled'
        $Answer = '__'
        $Answer -eq (DotNetTestAnswers -Test babelFish) | Should -BeTrue `
        -Because "babelFish answer is either jit or compiled"
    }

    It 'bookPublishers' {
        <#
            When an author writes a book and sends it off to a publisher to be printed 
            around the world, it’ll only be in one or two languages. To make the book available 
            to other markets around the world, the publisher will translate the 
            written material and then distribute copies of that. The original book 
            is translated once into a language, and that translated copy may 
            only be consumed by individuals who can read that language.

            Would this be an example of language being JIT or Compiled?
        #>

        # Replace __ with either 'jit' or 'compiled'
        $Answer = '__'
        $Answer -eq (DotNetTestAnswers -Test bookPublishers) | Should -BeTrue `
        -Because "bookPublishers answer is either jit or compiled"
    }

    It 'UN' {
        <#
            An example closer to home would be translators in the UN. Delegations 
            from all over the world converse with each other in one of six 
            official languages, with the speech interpreted in real-time 
            into the other official languages by language professionals.

            Would this be an example of language being JIT or Compiled?
        #>

        # Replace __ with either 'jit' or 'compiled'
        $Answer = '__'
        $Answer -eq (DotNetTestAnswers -Test arrivalOne) | Should -BeTrue `
        -Because "UN answer is either jit or compiled"
    }

}

Remove-Module $RelativePath