using module PSKoans
[Koan(Position = 106)]
param()
<#

    Get-Member

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

Describe "Get Member" {
<#
    Use Get-Member to identify properties or methods of some common objects!

    Make sure you use a different cmdlet each time, we'll be checking :)
#>

    It 'allows us to explore properties on an object' {

        # Get some properties!

        <# EXAMPLE

        $Cmdlet1 = 'Get-Process'
        $PropertyName = 'Threads'
        $Reason = $BecauseString -f $PropertyName, $cmdlet1
        & (Get-Command -Name $Cmdlet1) |
            Get-Member -MemberType Property -Name $PropertyName |
            Should -Not -BeNullOrEmpty -Because $Reason

        #>
        $BecauseString = "property '{0}' should be present in output from {1}"

        $Cmdlet1 = '____'
        $PropertyName = '____'

        $Reason = $BecauseString -f $PropertyName, $cmdlet1
        & (Get-Command -Name $Cmdlet1) |
            Get-Member -MemberType Property -Name $PropertyName |
            Should -Not -BeNullOrEmpty -Because $Reason

        $Cmdlet2 = '____'
        $PropertyName = '____'

        $Reason = $BecauseString -f $PropertyName, $cmdlet2
        & (Get-Command -Name $Cmdlet2) |
            Get-Member -MemberType Property -Name $PropertyName |
            Should -Not -BeNullOrEmpty -Because $Reason

        $Cmdlet3 = '____'
        $PropertyName = '____'

        $Reason = $BecauseString -f $PropertyName, $cmdlet3
        & (Get-Command -Name $Cmdlet3) |
            Get-Member -MemberType Property -Name $PropertyName |
            Should -Not -BeNullOrEmpty -Because $Reason

        $cmdlet1, $cmdlet2, $cmdlet3 |
            Get-Unique |
            Should -HaveCount 3 -Because "three unique cmdlets should be supplied"
    }

    It 'allows us to explore methods on an object' {

        # Get some methods!

        <# EXAMPLE

        $Cmdlet1 = 'Get-Process'
        $MethodName = 'Close'
        $Reason = $BecauseString -f $MethodName, $cmdlet1
        & (Get-Command -Name $Cmdlet1) |
            Get-Member -MemberType Property -Name $MethodName |
            Should -Not -BeNullOrEmpty -Because $Reason
        #>
        $BecauseString = "method '{0}' should be present in output from {1}"

        $Cmdlet1 = '____'
        $MethodName = '____'
        $Reason = $BecauseString -f $MethodName, $cmdlet1
        & (Get-Command -Name $Cmdlet1) |
            Get-Member -MemberType Method -Name $MethodName |
            Should -Not -BeNullOrEmpty -Because $Reason

        $Cmdlet2 = '____'
        $MethodName = '____'
        $Reason = $BecauseString -f $MethodName, $cmdlet2
        & (Get-Command -Name $Cmdlet2) |
            Get-Member -MemberType Method -Name $MethodName |
            Should -Not -BeNullOrEmpty -Because $Reason

        $Cmdlet3 = '____'
        $MethodName = '____'
        $Reason = $BecauseString -f $MethodName, $cmdlet3
        & (Get-Command -Name $Cmdlet3) |
            Get-Member -MemberType Method -Name $MethodName |
            Should -Not -BeNullOrEmpty -Because $Reason

        $cmdlet1, $cmdlet2, $cmdlet3 |
            Get-Unique |
            Should -HaveCount 3 -Because "three unique cmdlets should be supplied"
    }
}
