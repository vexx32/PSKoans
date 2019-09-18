using module PSKoans
[Koan(Position = 106)]
param()
<#

    Introduction to Get-Member
 
    Following on from our last Koan about cmdlet verbs, lets cover the nouns.

    As previously stated, the noun portion indicates the target of a given command.

    If you use the "Get-Member" cmdlet on any object you'll see its type name, or data type.

    For example:

        PS C:\Users\Administrator\Documents\GitHub\Dev\PSKoans> Get-Process | Get-Member


            TypeName: System.Diagnostics.Process

        Name                       MemberType     Definition
        ----                       ----------     ----------
        Handles                    AliasProperty  Handles = Handlecount
        Name                       AliasProperty  Name = ProcessName
        NPM                        AliasProperty  NPM = NonpagedSystemMemorySize64
        PM                         AliasProperty  PM = PagedMemorySize64
        SI                         AliasProperty  SI = SessionId
        VM                         AliasProperty  VM = VirtualMemorySize64
        WS                         AliasProperty  WS = WorkingSet64

    You'll also see properties and methods. Together with the TypeName, this tells us everything
    we need to know in order to access the object's data and any actions it can perform.

    Accessing a property or method is done via dot notation, which boils down to:

    $Object.Property
    $Object.Method()

    We'll cover why we have to use parentheses with method calls later.

#>

$RelativePath = ".\AnswerFunctions\IntroTraining\AboutGetMemberAnswers\AboutGetMemberAnswers.psd1"
Import-Module $RelativePath


Describe 'Get-Member' {
<#
    Use Get-Member to identify properties or methods of some common objects!

    Make sure you use a different cmdlet each time, we'll be checking :)
#>

    It 'allows us to explore properties on an object' {

        # Get some properties!
        
        <# EXAMPLE

        $cmdlet = Get-Process
        $PropertyName = "Threads"
        $Members =  $cmdlet | Get-Member -MemberType Property -Name $PropertyName
        $Members.count -ne 0 | Should -BeTrue `
        -Because "$PropertyName property doesn't exist in given cmdlet $cmdlet"

        #>

        $cmdlet1 = '__'
        $PropertyName = "__"
        $Members = ____ | Get-Member -MemberType Property -Name $PropertyName
        $Members.count -ne 0 | Should -BeTrue `
        -Because "$PropertyName property doesn't exist in given cmdlet $cmdlet1"

        $cmdlet2 = '__'
        $PropertyName = "__"
        $Members =  ____ | Get-Member -MemberType Property -Name $PropertyName
        $Members.count -ne 0 | Should -BeTrue `
        -Because "$PropertyName property doesn't exist in given cmdlet $cmdlet2"

        $cmdlet3 = '__'
        $PropertyName = "__"
        $Members =  ____ | Get-Member -MemberType Property -Name $PropertyName
        $Members.count -ne 0 | Should -BeTrue `
        -Because "$PropertyName property doesn't exist in given cmdlet $cmdlet3"

        $Cmdlets = $cmdlet1, $cmdlet2, $cmdlet3
        $UniqueCheck = $Cmdlets | Get-Unique
        $UniqueCheck -eq 3 | Should -BeTrue `
        -Because "three unique cmdlets should be supplied"

    }

    It 'allows us to explore methods on an object' {

        # Get some methods!

        <# EXAMPLE

            $cmdlet = Get-Process
            $PropertyName = "Close"
            VerifyMember -MemberType Property -MemberName $PropertyName -Object $cmdlet | Should -BeTrue `
            -Because "$PropertyName property doesn't exist in given cmdlet $cmdlet"

        #>

        $cmdlet1 = "__"
        $MethodName = "__"
        $Members =  $cmdlet | Get-Member -MemberType Method -Name $MethodName
        $Members.count -ne 0 | Should -BeTrue `
        -Because "$MethodName method doesn't exist in given cmdlet $cmdlet1"

        $cmdlet2 = "__"
        $MethodName = "__"
        $Members =  $cmdlet | Get-Member -MemberType Method -Name $MethodName
        $Members.count -ne 0 | Should -BeTrue `
        -Because "$MethodName method doesn't exist in given cmdlet $cmdlet2"

        $cmdlet3 = "__"
        $MethodName = "__"
        $Members =  $cmdlet | Get-Member -MemberType Method -Name $MethodName
        $Members.count -ne 0 | Should -BeTrue `
        -Because "$MethodName method doesn't exist in given cmdlet $cmdlet3"

        $Cmdlets = $cmdlet1, $cmdlet2, $cmdlet3
        $UniqueCheck = $Cmdlets | Get-Unique
        $UniqueCheck -eq 3 | Should -BeTrue `
        -Because "three unique cmdlets should be supplied"

    }

}
