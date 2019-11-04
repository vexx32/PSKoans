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