using module PSKoans
[Koan(Position = 104)]
param()
<#
    Object-Orientated Programming (OOP)

    PowerShell is object-orientated, but what does this mean? Everything is an object! 

    Objects are a way for us to build programs to scale, and OOP is 
    standard in software development. For the purposes of this Koan there's only three
    fundamentals you need to know:

    1) Objects are blueprints
    2) Objects have properties
    3) Objects have methods

    We'll cover properties in more depth when we go over the variables and primitive datatypes.
    We'll cover methods in more depth when we go over functions.

    Lets cover these all briefly below

#>

$RelativePath = ".\AnswerFunctions\IntroTraining\AboutOOPAnswers\AboutOOPAnswers.psd1"
Import-Module $RelativePath

Describe 'blueprint' {
        <#
            Objects are used to define a thing. We then make instances using the definition.
            
            For example, think of a kettle. The object will be called "Kettle".
            If we think about it, all kettles should have some common properties:

            - Whether or not it has a lid
            - The colour of the kettle
            - The material that it's made from

            All kettles might have a lid, all have a colour and all be made from something. 
            These are our properties.
            
            All kettles should also be able to do the following things:

            - Boil Water
            - Open lid (if it has a lid)
            - Close lid (if it has a lid)

            These "doing things" we can think of as our methods. These properties and 
            methods together make our object. Kettles come in all different shapes and
            sizes, but funamentally every single one will have the above properites and methods.

            The differences come when we create something from this blueprint, or an
            'instance' of the object. 
            
            We can have blue kettles, black kettles, kettles
            without lids, kettles with lids, kettles made from plastic or stainless steel etc.

            In "Hitchhiker's' Guide to the Galaxy", the character slartibartfast
            is a designer of planets. Below, you'll need to decide which of his work can
            be classed as an "object" and which can be classed as an "instance"
        #>

        It 'Norway Fjords' {
            # Design templates for the Fjords of Norway
            # Replace __ with either 'instance' or 'object'
            $Answer = '__'
            $Answer -eq (OOPTestAnswers -Test NorwayFjordsSchematics) | Should -BeTrue `
            -Because "design templates for the Fjords of Norway are either an instance or an object"
        }

        It 'Eyjafjallajokull' {
            # The volcano (Eyjafjallajokull) in Greenland which caused so much trouble back in 2010
            # Replace __ with either 'instance' or 'object'
            $Answer = '__'
            $Answer -eq (OOPTestAnswers -Test Eyjafjallajokull) | Should -BeTrue `
            -Because "Eyjafjallajokull is either an instance or an object"
        }

        It 'Coventry Schematics' {
            # The plans to the town hall in the midlands city of Coventry
            # Replace __ with either 'instance' or 'object'
            $Answer = '__'
            $Answer -eq (OOPTestAnswers -Test CoventrySchematics) | Should -BeTrue `
            -Because "the plans to Coventry Town Hall are either an instance or an object"
        }

        It 'Mars' {
            # The planet mars
            # Replace __ with either 'instance' or 'object'
            $Answer = '__'
            $Answer -eq (OOPTestAnswers -Test Mars) | Should -BeTrue `
            -Because "the planet Mars is either an instance or an object"

        }
}

Describe 'properties' {
    <#
        As we've already seen, properties are just things that the object has. Like a door having
        a door handle, or a car needing wing mirrors. Properties are not actions that a thing
        has. So the act of opening a door handle, or adjusting a wing mirror, is a method
        and not a property.

        In the below examples try and guess if these are properties are not.
    #>

    It 'doggoNose' {
        # Is the nose of a dog a property within the dog object?
        # Replace '$__' with $true if you think it is, or $false if you think it's not.
        # E.G. '$__' becomes $true
        $Answer = '$__'
        $Answer -eq (OOPTestAnswers -Test doggoNose) | Should -BeTrue `
        -Because "a dog's nose either is a property of the dog object ($true) or is not ($false)"
    }

    It 'doggoBark' {
        # Is the act of a dog barking a property within the dog object?
        # Replace '$__' with $true if you think it is, or $false if you think it's not.
        # E.G. '$__' becomes $true
        $Answer = '$__'
        $Answer -eq (OOPTestAnswers -Test doggoBark) | Should -BeTrue `
        -Because "a dog barking either is a property of the dog object ($true) or is not ($false)"
    }

    It 'doggoWoof' {
        # Is a dog being able to bark a property within the dog object?
        # Replace '$__' with $true if you think it is, or $false if you think it's not.
        # E.G. '$__' becomes $true
        $Answer = '$__'
        $Answer -eq (OOPTestAnswers -Test doggoWoof) | Should -BeTrue `
        -Because "a dog being able to bark either is a property of the dog object ($true) or is not ($false)"
    }

    It 'doggoTail' {
        # Is a dog's tail a property within the dog object?
        # Replace '$__' with $true if you think it is, or $false if you think it's not.
        # E.G. '$__' becomes $true
        $Answer = '$__'
        $Answer -eq (OOPTestAnswers -Test doggoTail) | Should -BeTrue `
        -Because "a dog's tail either is a property of the dog object ($true) or is not ($false)"
    }

}

Describe 'methods' {
    <#
        As we've already seen, methods are things that an object can do. A duck can quack, or
        a cat can meow. These actions are methods.

        "A duck can beak" or "A cat can hair" doesn't make sense, as these are properties
        that the respect objects have.

        In the below examples, try and guess if these are methods or not.
    #>

    It 'phoneVibrating' {
        # Is a phone vibrating a method of the phone object?
        # Replace '$__' with $true if you think it is, or $false if you think it's not.
        # E.G. '$__' becomes $true
        $Answer = '$__'
        $Answer -eq (OOPTestAnswers -Test phoneVibrating) | Should -BeTrue `
        -Because "a phone vibrating either is a method of the phone object ($true) or is not ($false)"
    }

    It 'keyboardColour' {
        # Is the colour of a keyboard a method of the keyboard object?
        # Replace '$__' with $true if you think it is, or $false if you think it's not.
        # E.G. '$__' becomes $true
        $Answer = '$__'
        $Answer -eq (OOPTestAnswers -Test keyboardColour) | Should -BeTrue `
        -Because "a keyboard's colour either is a method of the keyboard object ($true) or is not ($false)"
    }

    It 'lightPower' {
        # Is the watt of a light bulb a method of the light object?
        # Replace '$__' with $true if you think it is, or $false if you think it's not.
        # E.G. '$__' becomes $true
        $Answer = '$__'
        $Answer -eq (OOPTestAnswers -Test lightPower) | Should -BeTrue `
        -Because "the watt of a light bulb either is a method of the light object ($true) or is not ($false)"
    }

    It 'toast' {
        # Is the act of toasting bread a method of the toaster object?
        # Replace '$__' with $true if you think it is, or $false if you think it's not.
        # E.G. '$__' becomes $true
        $Answer = '$__'
        $Answer -eq (OOPTestAnswers -Test toast) | Should -BeTrue `
        -Because "the act of toasting bread either is a method of the toaster object ($true) or is not ($false)"
    }
}

Remove-Module $RelativePath
