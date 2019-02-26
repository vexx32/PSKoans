#requires -modules dbatools
using module PSKoans
[Koan(Position = 1001)]
param()
<#
    Get-DbaDatabase

    The Get-DbaDatabase command gets SQL database information for each database
    that is present on the target instance(s) of SQL Server by default. If the 
    name of the database is provided, the command will return only the specific 
    database.
#>
Describe 'Get-DbaDatabase' {

    Mock -CommandName Get-DbaDatabase -MockWith {
        Import-Clixml -Path ".\PSKoans\Koans\dbatools\Mocks\Database_TestDb.xml" 
    }

    # `Get-DbaDatabase` requires one thing; A SQL Server instance name.
    # You can pass in "localhost" for the default name for a SQL Server instance.
    # The simplest usage of `Get-DbaDatabase` is to run it and passing in the name
    # of the SQL Server instance.
    $MasterDatabase = Get-DbaDatabase -SqlInstance localhost -Database ____
    $MasterDatabase.Name | Should -Be 'master'

}