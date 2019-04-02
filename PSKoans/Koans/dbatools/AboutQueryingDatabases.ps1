#Requires -Modules dbatools
using module PSKoans
[Koan(Position = 1002)]
param()
<#
    Invoke-DbaQuery

    The default language for querying SQL Server is T-SQL. To run explicit
    T-SQL commands or files, the function Invoke-DbaQuery was created.

    Based off of Invoke-Sqlcmd, Invoke-DbaQuery was designed to be more
    convenient to use in a pipeline and behave in a way that is consistent with
    the rest of the dbatools functions.
#>
Describe "Invoke-DbaQuery" {

    <#
        Let's setup the environment for you. Unless you want the Koans to
        nearly always fail, I would suggest not messing with this bit.
    #>
    Mock -CommandName Invoke-DbaQuery -MockWith {
        Import-Clixml -Path .\PSKoans\Koans\dbatools\Mocks\BasicInvokeDbaQuery.xml
    } -ParameterFilter { $_.Query -eq "SELECT DB_NAME() AS database_name;" }

    <#
        Invoke-DbaQuery can be used to connect to the SQL Server, in much the
        same way that Get-DbaDatabase does, by using the -SqlInstance parameter.
        Complete the below command to query "localhost" using Invoke-DbaQuery.
    #>
    $Bar = Invoke-DbaQuery -SqlInstance ____ -Query "SELECT DB_NAME() AS database_name;"
    $Bar.database_name | Should -Be 'master'

    <#
        Invoke-DbaQuery allows you to query a single database, multiple
        databases, or even multiple servers.
        The T-SQL command @@SERVERNAME returns the name of the server that the
        database is on. We can use this to see what instance we are connected to.
    #>
    $ManyServers = 'localhost', 'localhost\SQLDEV2K14' | Invoke-DbaQuery -Query "SELECT @@SERVERNAME AS ____;"
    $ManyServers.server_name | Should -BeIn 'localhost', 'localhost\SQLDEV2K14'
}

