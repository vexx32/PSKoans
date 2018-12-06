#requires -module dbatools
using module PSKoans
[Koan(Position = 1001)]
param()
<#
    Get-DbaDatabase

    The Get-DbaDatabase command gets SQL database information for each database
    that is present on the target instance(s) of SQL Server. If the name of the
    database is provided, the command will return only the specific database.
#>
Describe 'Get-DbaDatabase' {



}