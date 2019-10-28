
[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 0)]
    [ValidateScript( { Test-Path $_ -IsValid })]
    [string]
    $Path = "$env:SYSTEM_DEFAULTWORKINGDIRECTORY/Changelog.md",

    [Parameter(Position = 1)]
    [ValidatePattern('[a-f0-9]{6,40}|v?(\d+\.)+\d+(-\w+\d+)?')]
    [string]
    $CommitID = (git tag | Select-Object -Last 1),

    [Parameter(Mandatory)]
    [string]
    $ApiKey
)

begin {
    Invoke-RestMethod -SessionVariable AuthSession -Uri https://api.github.com/ -Headers @{
        Authorization = "token $ApiKey"
    } |
        Out-String |
        Write-Verbose
}
process {
    $Args = @(
        '--no-pager'
        'log'
        '--first-parent'
        "$CommitID..HEAD"
        '--format="%H~%aN~%aE~%s"'
        '--'
        '.'
        '":(exclude)*.md"'
    )
    $Commits = & git @args |
        ConvertFrom-Csv -Delimiter '~' -Header Hash, Name, Email, Subject |
        Group-Object -Property Name

    $CsvString = $(
        $Commits |
            ForEach-Object {
                $result = Invoke-RestMethod -Uri "https://api.github.com/search/users?q=$($_.Group[0].Email)+in:email" -WebSession $AuthSession
                $Name = if ($result.total_count -ne 0) { $result.items[0].login }

                $_.Group | Select-Object -Property @(
                    @{ Name = 'Hash'; Expression = { $_.Hash.Substring(0, 7) } }
                    @{
                        Name       = 'Name'
                        Expression = {
                            $(
                                $_.Name
                                if ($Name) { "(@$Name)" }
                            ) -join ' '
                        }
                    }
                    'Subject'
                )
            } |
            ConvertTo-Csv -Delimiter '|'
    ) -replace '"'

    $MarkdownTable = @(
        # Header Row Only
        $CsvString | Select-Object -First 1
        # Adding Markdown table column alignments
        "| :--: | :--- | :--- |"
        # Data Rows
        $CsvString | Select-Object -Skip 1
    )

    $MarkdownTable | Set-Content -Path $Path
}
