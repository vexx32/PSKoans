Add-Type -TypeDefinition @'
using System;

public class KoanAttribute : Attribute
{
    public uint Position = UInt32.MaxValue;
    public string Module = "_powershell";
}
'@
