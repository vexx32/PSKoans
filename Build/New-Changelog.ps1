<#
    .SYNOPSIS
    Creates a Markdown changelog file with table formatting.

    .DESCRIPTION
    Uses `git log` to compare the current commit to the last tagged commit,
    and parses the output into CSV data. This is then processed and email
    addresses of commit authors are used to retrieve their Github
    usernames, if available.

    The final result is stored in a Markdown plaintext file at the
    designated path.

    .PARAMETER Path
    The file location to save the markdown text to. The file will be
    overwritten if it already contains data.

    .PARAMETER CommitID
    The commit tag or hash that is used to identify the commit to
    compare with. By default, the last value given by `git tag`
    will be used.

    .PARAMETER ApiKey
    The Github API key to use when looking up commit authors'
    Github user names.

    .EXAMPLE
    New-Changelog.ps1 -Path File.md -ApiKey $GHApiKey

    Retrieves the commits since the last tagged commit and creates a
    Markdown-formatted plaintext file called File.md in the current
    location.

    .NOTES
    The Github API limitation of 60 requests per minute is -barely-
    usable without authentication. Authenticated requests have a
    substantially higher limit on requests per minute.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 0)]
    [ValidateScript( { Test-Path $_ -IsValid })]
    [string]
    $Path,

    [Parameter(Position = 1)]
    [ValidatePattern('[a-f0-9]{6,40}|v?(\d+\.)+\d+(-\w+\d+)?')]
    [string]
    $CommitID = (git tag | Select-Object -Last 1),

    [Parameter()]
    [Alias('OauthToken')]
    [string]
    $ApiKey
)

begin {
    if ($ApiKey) {
        $RequestParams = @{
            SessionVariable = 'AuthSession'
            Uri             = 'https://api.github.com/'
            Headers         = @{ Authorization = "token $ApiKey" }
        }
        Invoke-RestMethod @RequestParams | Out-String | Write-Verbose
    }
}
process {
    $RequestParams = if ($AuthSession) { @{ WebSession = $AuthSession } } else { @{ } }
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
    $Commits = & git @args | ConvertFrom-Csv -Delimiter '~' -Header Hash, Name, Email, Subject

    $NameTable = @{ }
    foreach ($Item in ($Commits | Sort-Object -Property Email -Unique)) {
        $RequestParams['Uri'] = "https://api.github.com/search/users?q=$($Item.Email)+in:email"

        do {
            $result = $null
            $attempt = 0
            try {
                $result = Invoke-RestMethod @RequestParams -ErrorAction Stop
            }
            catch {
                # If this errors, we have probably hit Github's per-minute API restriction,
                # so wait at least 30 seconds before retry.
                Start-Sleep -Seconds 30
                $attempt++
            }
        } while ($attempt -lt 3 -and -not $result)

        $NameTable[$Item.Email] = if ($result.total_count) { $result.items[0].login } else { $Item.Name }
    }

    $CsvString = $Commits |
        Select-Object -Property @(
            @{ Name = 'Hash'; Expression = { $_.Hash.Substring(0, 7) } }
            @{ Name = 'Name'; Expression = { $NameTable[$_.Email] } }
            'Subject'
        ) |
        ConvertTo-Csv -Delimiter '|'

    $TableRows = $CsvString -replace '"', ' ' -replace '^|$', '|'

    $MarkdownTable = @(
        # Header Row Only
        $TableRows | Select-Object -First 1
        # Adding Markdown table column alignments
        "| :--: | :--- | :--- |"
        # Data Rows
        $TableRows | Select-Object -Skip 1
    )

    $MarkdownTable | Set-Content -Path $Path
}
