#Requires -Modules dbatools
using module PSKoans
[Koan(Position = 1002)]
param()
<#
    Invoke-DbaQuery

    The default language for querying SQL Server is T-SQL. To run explicit
    T-SQL commands or files, the function `Invoke-DbaQuery` was created.

    Based off of `Invoke-Sqlcmd`, `Invoke-DbaQuery` was designed to be more
    convenient to use in a pipeline and behave in a way that is consistent with
    the rest of the dbatools functions.
#>