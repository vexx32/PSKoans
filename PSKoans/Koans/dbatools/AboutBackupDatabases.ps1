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

    At it's lowest level, Backup-DbaDatabase can backup every database on the SQL Instance to the default
    backup directory.
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
                SqlInstance = $ENV:COMPUTERNAME
                Database = ('Database_{0:d2}' -f $_)
                Type = 'Full'
                TotalSize = ({0} -f ([Math]::PI * $_))
                DeviceType = 'Disk'
                Start = $RestoreStart
                Duration = $RestoreEnd - $RestoreStart
                End = $RestoreEnd
            }
            $StartDate = $RestoreEnd
        }
    }
}