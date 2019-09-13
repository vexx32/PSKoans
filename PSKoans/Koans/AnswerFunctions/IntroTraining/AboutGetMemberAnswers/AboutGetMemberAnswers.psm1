<#
    Functions in this module are intended to verify answers given
    for the AboutDataTypes Koans

#>

enum memberTypes {
Property
Method
}

$EnumTypeHash = [ordered]@{
    [memberTypes]::Method = "Method";
    [memberTypes]::Property = "Property"
}

function VerifyMember() {
param(
[parameter(Mandatory=$true)][MemberTypes]$MemberType,
[parameter(Mandatory=$True)][string]$MemberName,
[parameter(Mandatory=$true)][System.Object[]]$Object
)
<#
.SYNOPSIS
Provides a mechanism for verifying an object has a member of a certain type

.PARAMETER MemberType
Specify what member type we're verifying.
Has to be a type of the MemberTypes enum:
Property
Method

.PARAMETER MemberName
Specify the name of the member we are attempting to verify

.PARAMETER Object
The object we are verifying MemberType against. Can also be a cmdlet if it returns an object.
IF a cmdlet is used then the returned object is verified.

.INPUTS 
None. You cannot pipe objects through to VerifyMember.

.OUTPUTS
System.Boolean
Returns $True if given object param has the given MemberName and this member
is of the given MemberType

.EXAMPLE
PS> VerifyMember -MemberType Property -MemberName "Cheese" -Object $CheeseWheel
$True

.LINK
https://github.com/Sudoblark/PSKoans

.LINK 
https://github.com/vexx32/PSKoans
#>

    $Type = $EnumTypeHash[$MemberType]
    $Members = $Object | Get-Member -MemberType $Type -Name $MemberName
    if ($Members.count -eq 0) {
        return $false
    } else {
        return $true
    }
}
