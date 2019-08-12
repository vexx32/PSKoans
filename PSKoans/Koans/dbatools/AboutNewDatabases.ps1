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

    <#
        New-DbaDatabase, while having a few different parameters, requires only that you have an instance
        of SQL Server that you can connect to and it can create a database on.

        Complete the below to create a new database on localhost.
    #>
    $NewDatabase = New-DbaDatabase -SqlInstance '__'
    $NewDatabase.ComputerName | Should -Be 'localhost'

}