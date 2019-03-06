#Requires -Modules dbatools
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

    #region Mocks
    Mock -CommandName Get-DbaDatabase -MockWith {
        Import-Clixml -Path .\PSKoans\Koans\dbatools\Mocks\Database_All.xml
    } -ParameterFilter { $_.SqlInstance -eq 'localhost' }
    
    Mock -CommandName Get-DbaDatabase -MockWith {
        Import-Clixml -Path .\PSKoans\Koans\dbatools\Mocks\Database_TestDb.xml
    } -ParameterFilter { $_.SqlInstance -eq 'localhost' -and $_.Database -eq 'testdb' }

    Mock -CommandName Get-DbaDatabase -MockWith {
        Import-Clixml -Path .\PSKoans\Koans\dbatools\Mocks\Database_System.xml
    } -ParameterFilter { $_.SqlInstance -eq 'localhost' -and $_.ExcludeUser }

    Mock -CommandName Get-DbaDatabase -MockWith {
        Import-Clixml -Path .\PSKoans\Koans\dbatools\Mocks\Database_TestDb.xml
    } -ParameterFilter { $_.SqlInstance -eq 'localhost' -and $_.ExludeSystem }
    #endregion

    <#
        `Get-DbaDatabase` requires one thing; A SQL Server instance name.
        You can pass in "localhost" for the default name for a SQL Server
        instance.
        The simplest usage of `Get-DbaDatabase` is to run it and passing in the
        name of the SQL Server instance. This will get information about all
        the databases on the instance.
    #>
    $AllDatabases = Get-DbaDatabase -SqlInstance ____
    $AllDatabases.Count | Should -Be 5

    <#
        By passing in the SQL Server instance and the name of a specific
        database, by using the `-Database` parameter, we can get information on
        that single database instead.
    #>
    $MasterDatabase = Get-DbaDatabase -SqlInstance localhost -Database ____
    $MasterDatabase.Name | Should -Be 'testdb'

    <#
        You may want to get only the system databases on an instance. While it
        is different databases on the instance.
    #>
    $UserDbsExcluded = Get-DbaDatabase -SqlInstance localhost -____
    $UserDbsExcluded | Select-Object -ExpandProperty Name | Should -BeIn 'tempdb', 'master', 'model', 'msdb'

    <#
        The same can be done to exclude system databases by providing the
        -ExcludeSystem parameter switch.
    #>
    $SystemDbsExluded = Get-DbaDatabase -SqlInstance localhost -____
    $SystemDbsExluded | Select-Object -ExpandProperty Name | Should -Be 'testdb'

    <#
        Parameters have also been added to check for common questions and
        scenarios that people working with databases may have.
        These include getting databases that in the 'Full', 'Simple', or
        'BulkLogged' recovery models.
    #>
    $FullRecoveryDbs = Get-DbaDatabase -SqlInstance localhost -RecoveryModel ____
    $FullRecoveryDbs | Select-Object -ExpandProperty RecoveryModel | Should -Be 'Full'
}

