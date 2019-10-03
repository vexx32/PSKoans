#Requires -Modules dbatools
using module PSKoans
[Koan(Position = 1003)]
param()
<#
    New-DbaDatabase

    Getting details and querying a database are useful when there is a database to query.
    What if we need to create a new database?
    dbatools has us covered with New-DbaDatabase
#>
Describe 'New-DbaDatabase' {

    <#
        Let's set up the environment for you.
        
        Unless you want the Koans to nearly always fail, I would suggest not messing with this bit.
    #>
    Mock -CommandName New-DbaDatabase -MockWith {
        [PSCustomObject]@{
            ComputerName = 'localhost'
            InstanceName = 'MSSQLSERVER'
            SqlInstance = 'localhost'
            Name = 'random-123456789'
            Status = 'Normal'
            IsAccessible = $true
            RecoveryModel = 'Simple'
            LogReuseWaitStatus = 'Nothing'
            SizeMB = 16
            Compatibility = 'Version140'
            Collation = 'SQL_Latin1_General_CP1_CI_AS'
            Owner = $ENV:USERNAME
            LastFullBackup = (Get-Date '0001-01-01')
            LastDiffBackup = (Get-Date '0001-01-01')
            LastLogBackup = (Get-Date '0001-01-01')
        }
    } -ParameterFilter {$_.SqlInstance -eq 'localhost'}

    Mock -CommandName New-DbaDatabase -MockWith {
        [PSCustomObject]@{
            ComputerName = 'localhost'
            InstanceName = 'MSSQLSERVER'
            SqlInstance = 'localhost'
            Name = 'RandomIsGood'
            Status = 'Normal'
            IsAccessible = $true
            RecoveryModel = 'Simple'
            LogReuseWaitStatus = 'Nothing'
            SizeMB = 16
            Compatibility = 'Version140'
            Collation = 'SQL_Latin1_General_CP1_CI_AS'
            Owner = $ENV:USERNAME
            LastFullBackup = (Get-Date '0001-01-01')
            LastDiffBackup = (Get-Date '0001-01-01')
            LastLogBackup = (Get-Date '0001-01-01')
        },
        [PSCustomObject]@{
            ComputerName = 'localhost'
            InstanceName = 'MSSQLSERVER'
            SqlInstance = 'localhost'
            Name = 'SpecificIsBetter'
            Status = 'Normal'
            IsAccessible = $true
            RecoveryModel = 'Simple'
            LogReuseWaitStatus = 'Nothing'
            SizeMB = 16
            Compatibility = 'Version140'
            Collation = 'SQL_Latin1_General_CP1_CI_AS'
            Owner = $ENV:USERNAME
            LastFullBackup = (Get-Date '0001-01-01')
            LastDiffBackup = (Get-Date '0001-01-01')
            LastLogBackup = (Get-Date '0001-01-01')
        }
    } -ParameterFilter {
        $_.SqlInstance -eq 'localhost' -and
        @('RandomIsGood', 'SpecificIsBetter') -in $_.Name
    }

    Mock -CommandName New-DbaDatabase -MockWith {
        'Val', 'Dev', 'Prod' | ForEach-Object -Process {
            [PSCustomObject]@{
                ComputerName = $_
                InstanceName = 'MSSQLSERVER'
                SqlInstance = $_
                Name = 'DBScripts'
                Status = 'Normal'
                IsAccessible = $true
                RecoveryModel = 'Simple'
                LogReuseWaitStatus = 'Nothing'
                SizeMB = 16
                Compatibility = 'Version140'
                Collation = 'SQL_Latin1_General_CP1_CI_AS'
                Owner = $ENV:USERNAME
                LastFullBackup = (Get-Date '0001-01-01')
                LastDiffBackup = (Get-Date '0001-01-01')
                LastLogBackup = (Get-Date '0001-01-01')
            }
        }
    } -ParameterFilter {
        $_.Name -eq 'DBScripts' -and
        @('Val', 'Dev', 'Prod') -in $_.SqlInstance
    }

    <#
        New-DbaDatabase, while having a few different parameters, requires only that you have an instance
        of SQL Server that you can connect to and it can create a database on.

        Complete the below to create a new database on localhost.
    #>
    $NewDatabase = New-DbaDatabase -SqlInstance '__'
    $NewDatabase.ComputerName | Should -Be 'localhost'

    <#
        While only specifying the server name is convenient, it is rare that we want a randomly named
        database. Most of the time we want to specify the database name(s) to be created.

        Luckily, New-DbaDatabase allows us to do that!
    #>
    $NewSpecifiedDatabase = New-DbaDatabase -SqlInstance localhost -Name '____', '____'
    $NewSpecifiedDatabase.Name | Should -Be 'RandomIsGood', 'SpecificIsBetter'

    <#
        If you're interacting with databases regularly then you more than likely have a list of
        scripts that you run often enough to save. You can save these scripts as files or you can
        save them to a database on each server.

        If only there was a way to create a database on your Dev, Val, and Prod servers that you
        can save these scripts to...
    #>
    $NewScriptsDatabase = New-DbaDatabase -SqlInstance '____', '____', '____' -Name DBScripts
    $NewScriptsDatabase.SqlInstance | Should -Be 'Dev', 'Val', 'Prod'

    <#
        There is also an option to specify where to place the database data and log files. By using the parameters
        -DataFilePath and -LogFilePath, you can specify where to place these files.
    #>
}