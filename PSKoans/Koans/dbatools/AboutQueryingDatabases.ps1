#Requires -Modules dbatools
using module PSKoans
[Koan(Position = 1002)]
param()
<#
    Invoke-DbaQuery

    The default language for querying SQL Server is T-SQL. To run explicit T-SQL commands or files,
    the function Invoke-DbaQuery was created.

    Based off of Invoke-Sqlcmd, Invoke-DbaQuery was designed to be more convenient to use in a pipeline
    and behave in a way that is consistent with the rest of the dbatools functions.
#>
Describe "Invoke-DbaQuery" {

    <#
        Let's setup the environment for you. Unless you want the Koans to nearly always fail, I would
        suggest not messing with this bit.
    #>
    Mock -CommandName Invoke-DbaQuery -MockWith {
        Import-Clixml -Path .\PSKoans\Koans\dbatools\Mocks\BasicInvokeDbaQuery.xml
    } -ParameterFilter { $_.Query -eq "SELECT DB_NAME() AS database_name;" }

    Mock -CommandName Invoke-DbaQuery -MockWith {
        Import-Clixml -Path .\PSKoans\Koans\dbatools\Mocks\SqlParamInvokeDbaQueryBob.xml
    } -ParameterFilter { $_.Query -eq 'SELECT PersonName, PhoneNumber FROM PhoneBook WHERE PersonName = @name' -and $_.SqlParameters.name -eq 'Bob' }
    Mock -CommandName Invoke-DbaQuery -MockWith {
        Import-Clixml -Path .\PSKoans\Koans\dbatools\Mocks\SqlParamInvokeDbaQueryFrank.xml
    } -ParameterFilter { $_.Query -eq 'SELECT PersonName, PhoneNumber FROM PhoneBook WHERE PersonName = @name' -and $_.SqlParameters.name -eq 'Frank' }
    
    <#
        Invoke-DbaQuery can be used to connect to the SQL Server, in much the same way that Get-DbaDatabase
        does, by using the -SqlInstance parameter.
        Complete the below command to query "localhost" using Invoke-DbaQuery.
    #>
    $Bar = Invoke-DbaQuery -SqlInstance ____ -Query "SELECT DB_NAME() AS database_name;"
    $Bar.database_name | Should -Be 'master'

    <#
        Invoke-DbaQuery allows you to query a single database, multiple databases, or even multiple
        servers.
        The T-SQL command @@SERVERNAME returns the name of the server that the database is on. We can
        use this to see what instance we are connected to.
    #>
    $ManyServers = 'localhost', 'localhost\SQLDEV2K14' | Invoke-DbaQuery -Query "SELECT @@SERVERNAME AS ____;"
    $ManyServers.server_name | Should -BeIn 'localhost', 'localhost\SQLDEV2K14'

    <#
        It is possible to save T-SQL scripts into files. Invoke-DbaQuery has the ability to use the
        -File parameter, by passing in the location of the file, to run the T-SQL scripts against the
        instance.
        We've created a file called SimpleTSQL.sql that contains a T-SQL statement, which we want to
        run against the tempdb database on the localhost instance.
    #>
    Out-File - FilePath TestDrive:\SimpleTSQL.sql -InputObject "SELECT 'From a File' AS Origin;" 
    $InvokeDbaQueryParams = @{
        SqlInstance = 'localhost'
        Database    = 'tempdb'
        File        = ____
    }
    $DbResult = Invoke-DbaQuery @InvokeDbaQueryParams
    $DbResult.Origin | Should -Be 'From a File'

    <#
        T-SQL may seem like a strict, rigid language. We have a script that returns a value or values.
        If we want to get different values then we will have to change the full query. 
        From
            "SELECT PersonName, PhoneNumber FROM PhoneBook WHERE PersonName = 'Bob';"
        to
            "SELECT PersonName, PhoneNumber FROM PhoneBook WHERE PersonName = 'Ross';"
        In the above example, we only want to change what the name is equal to. Invoke-DbaQuery allows
        you to specify what this value is equal to by passing in a parameter.
        All we have to do is pass in a hashtable with the name of the parameter and the value we want.
    #>
    $InvokeDbaQueryParam01 = @{
        SqlInstance = 'localhost'
        Query = 'SELECT PersonName, PhoneNumber FROM PhoneBook WHERE PersonName = @name'
        SqlParameters = @{ name = 'Bob' }
    }
    $SqlParamResult01 = Invoke-DbaQuery @InvokeDbaQueryParam01
    $SqlParamResult01.PersonName | Should -Be 'Bob'

    $InvokeDbaQueryParam02 = @{
        SqlInstance = 'localhost'
        Query = 'SELECT PersonName, PhoneNumber FROM PhoneBook WHERE PersonName = @name'
        SqlParameters = @{ name = ____ }
    }
    $SqlParamResult02 = Invoke-DbaQuery @InvokeDbaQueryParam01
    $SqlParamResult02.PersonName | Should -Be 'Frank'
}

