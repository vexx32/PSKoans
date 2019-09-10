using module PSKoans
[Koan(Position = 106)]
param()
<#

    AboutGetMember
 
    Following on from our last Koan about cmdlet verbs, lets cover the nouns.

    As previously stated, the nouns are objects. These are also known as DataTypes.

    If you use the "Get-Member" cmdlet on any object you'll see its datatype.

    For example:

    PS C:\Users\Administrator\Documents\GitHub\Dev\PSKoans> Get-Service | Get-Member


   TypeName: System.ServiceProcess.ServiceController

    Notice the "TypeName" is System.ServiceProcess.ServiceController. This tells us that
    the Get-Service cmdlet returns objects of a ServiceController type. They reside in
    the System.ServiceProcess namespace but you don't need to know more about this unless
    you dive into .NET development.

    In these Koans we'll go over the Get-Member cmdlet,
    expanding upon our knowledge of object-orientated program, in order to find properties
    and methods of an object. The next kew Koans will relate to what these "TypeName" items are.

#>

$RelativePath = ".\AnswerFunctions\IntroTraining\AboutGetMemberAnswers\AboutGetMemberAnswers.psd1"
Import-Module $RelativePath


Describe 'Get-Member' {
<#
    The Get-Member cmdlet is super useful.

    If you remember back in "AboutDotNet" we discovered that PowerShell is object-orientated;
    everything is an object with properties (things the object has) and methods (things
    the object can do). 

    When we use Get-Member on any object (everything is an object in PowerShell!) it'll return to you
    the datatype (TypeName) and a list of properties and methods the object has.

    That's pretty neat. Using this not only can we figure out what type of object a 
    thing is, but we can also see all of the information available to us from it and
    any actions we can do with it.

    So we can get properties and methods via Get-Member, and we know what these things are,
    but how do we access them? .NET has a concept called dot notation, which boils down to:

    Object.property
    Object.method()

    We'll cover why we have to use brackets with methods later.

    For now, use Get-Member - plus dot notation - to retrieve a few methods and properties.
#>

    It 'Propeties' {

        # Retrieve properties returned by various cmdlets.
        # See below for an example:
        <# EXAMPLE
        # Specify the cmdlet here.
        $cmdlet = Get-Service
        # And the name of the property you've found
        # E.G. "__" becomes "CanPauseAndContinue"
        $PropertyName = "CanPauseAndContinue"
        VerifyMember -MemberType Property -MemberName $PropertyName -Object $cmdlet | Should -BeTrue `
        -Because "$PropertyName property doesn't exist in given cmdlet $cmdlet"
        #>
        

        # Below, specify three cmdlets and some of their properites you've discovered.

        ##### 01 #####
        # Specify the cmdlet here.
        # e.g. "__" becomes Get-Service
        $cmdlet = "__"
        # And the name of the property you've found
        # E.G. "__" becomes "CanPauseAndContinue"
        $PropertyName = "__"
        VerifyMember -MemberType Property -MemberName $PropertyName -Object $cmdlet | Should -BeTrue `
        -Because "$PropertyName property doesn't exist in given cmdlet $cmdlet"

        ##### 02 #####
        # Specify the cmdlet here.
        # e.g. "__" becomes Get-Service
        $cmdlet = "__"
        # And the name of the property you've found
        # E.G. "__" becomes "CanPauseAndContinue"
        $PropertyName = "__"
        VerifyMember -MemberType Property -MemberName $PropertyName -Object $cmdlet | Should -BeTrue `
        -Because "$PropertyName property doesn't exist in given cmdlet $cmdlet"

        ##### 03 #####
        # Specify the cmdlet here.
        # e.g. "__" becomes Get-Service
        $cmdlet = "__"
        # And the name of the property you've found
        # E.G. "__" becomes "CanPauseAndContinue"
        $PropertyName = "__"
        VerifyMember -MemberType Property -MemberName $PropertyName -Object $cmdlet | Should -BeTrue `
        -Because "$PropertyName property doesn't exist in given cmdlet $cmdlet"

    }

    It 'Methods' {

        # Retrieve methods returned by various cmdlets.
        # See below for an example:
        <# EXAMPLE

        # Specify the cmdlet here.
        # e.g. "__" becomes Get-Service
        $cmdlet = Get-Service
        # And the name of the Method you've found
        # E.G. "__" becomes "GetType"
        $MethodName = "GetType"
        VerifyMember -MemberType Method -MemberName $MethodName -Object $cmdlet | Should -BeTrue `
        -Because "$MethodName method doesn't exist in given cmdlet $cmdlet"


        #>
        

        # Below, specify three cmdlets and some of their methods you've discovered.


        ##### 01 #####
        # Specify the cmdlet here.
        # e.g. "__" becomes Get-Service
        $cmdlet = "__"
        # And the name of the Method you've found
        # E.G. "__" becomes "GetType"
        $MethodName = "__"
        VerifyMember -MemberType Method -MemberName $MethodName -Object $cmdlet | Should -BeTrue `
        -Because "$MethodName method doesn't exist in given cmdlet $cmdlet"


        ##### 02 #####
        # Specify the cmdlet here.
        # e.g. "__" becomes Get-Service
        $cmdlet = "__"
        # And the name of the Method you've found
        # E.G. "__" becomes "GetType"
        $MethodName = "__"
        VerifyMember -MemberType Method -MemberName $MethodName -Object $cmdlet | Should -BeTrue `
        -Because "$MethodName method doesn't exist in given cmdlet $cmdlet"


        ##### 03 #####
        # Specify the cmdlet here.
        # e.g. "__" becomes Get-Service
        $cmdlet = "__"
        # And the name of the Method you've found
        # E.G. "__" becomes "GetType"
        $MethodName = "__"
        VerifyMember -MemberType Method -MemberName $MethodName -Object $cmdlet | Should -BeTrue `
        -Because "$MethodName method doesn't exist in given cmdlet $cmdlet"

    }

}
