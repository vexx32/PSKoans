#Requires -Modules dbatools
using module PSKoans
[Koan(Position = 1004)]
param()
<#
    Backup-DbaDatabase

    Backing up a database is crucially important to all who use databases.

    If there is a need to recover data from an earlier time, then backups get used to recover the data.

    There are many filters and options for backing up a database. dbatools helps you to take a backup
    with the Backup-DbaDatabase command.
#>
Describe "Backup-DbaDatabase" {
    <#
        Let's setup the environment for you. Unless you want the Koans to nearly always fail, I would
        suggest not messing with this bit.
    #>
    Mock -CommandName Backup-DbaDatabase -MockWith {
        $StartDate = [Datetime]::new(2019, 01, 01, 12, 00, 00)
        1..10 | ForEach-Object -Process {
            $RestoreStart = $StartDate
            $RestoreEnd = $StartDate.AddSeconds(10)

            [PSCustomObject]@{
                ComputerName = 'localhost'
                SqlInstance = $ENV:COMPUTERNAME
                Database = ('Database_{0:d2}' -f $_)
                Type = 'Full'
                TotalSize = ('{0}' -f ([Math]::PI * $_))
                DeviceType = 'Disk'
                Start = $RestoreStart
                Duration = $RestoreEnd - $RestoreStart
                End = $RestoreEnd
            }
            $StartDate = $RestoreEnd
        }
    }
    Mock -CommandName Backup-DbaDatabase -MockWith {
        $StartDate = [Datetime]::new(2019, 01, 01, 12, 00, 00)
        1..2 | ForEach-Object -Process {
            $RestoreStart = $StartDate
            $RestoreEnd = $StartDate.AddSeconds(15)

            [PSCustomObject]@{
                ComputerName = 'localhost'
                SqlInstance = $ENV:COMPUTERNAME
                Database = ('Database_{0:d2}' -f $_)
                Type = 'Full'
                TotalSize = ('{0}' -f ([Math]::PI * $_))
                DeviceType = 'Disk'
                Start = $RestoreStart
                Duration = $RestoreEnd - $RestoreStart
                End = $RestoreEnd
            }

            $StartDate = $RestoreEnd
        }
    } -ParameterFilter {
        $_.Database -contains ('Database_01', 'Database_02')
    }
    Mock -CommandName Backup-DbaDatabase -MockWith {
        [PSCustomObject]@{
            ComputerName = 'localhost'
            SqlInstance = 
        }
        $StartDate = [Datetime]::new(2019, 01, 01, 12, 00, 00)

    }

    <#
        By default, Backup-DbaDatabase will backup every database on the SQL Instance.
        These backups will get saved to the default backup directory.
        Complete the below command to backup all the databases on the localhost instance.
    #>
    $AllBackups = Backup-DbaDatabase -SqlInstance '____'
    $AllBackups.ComputerName | Should -Be 'localhost'

    <#
        By using the -Database parameter, you can backup a single or many databases.
        Complete the below command to backup the databases Database_01 and Database_02
    #>
    $SpecificBackups = Backup-DbaDatabase -SqlInstance localhost -Database '____','____'
    $SpecificBackups.Database | Should -Contain 'Database_01', 'Database_02'

    <#
        There are different types of backups that can be taken i.e. Full, Differential, and
        Transaction Log.
        Backup-DbaDatabase can take each of these backup types by using the -Type parameter
        and specifying Full, Diff, or Log for each respective type.
        Complete the below command to take a Transaction Log of the Database_01 database.
    #>
    $SpecificTypeOfBackup = Backup-DbaDatabase -SqlInstance localhost -Database Database_01 -Type '____'
    $SpecificTypeOfBackup.Type | Should -be 'Log'

}