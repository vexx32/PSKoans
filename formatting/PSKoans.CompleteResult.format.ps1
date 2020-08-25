Write-FormatView -AsList -TypeName PSKoans.CompleteResult  -Name List -Property KoansPassed, TotalKoans, RequestedTopic, Complete

Write-FormatView -TypeName PSKoans.CompleteResult -Action {
    Write-FormatViewExpression -If { $_.RequestedTopic } -ControlName Prompt.TopicList -ScriptBlock {
        @{
            FormatString = @"
    Congratulations! You have taken the first steps towards enlightenment.

    You have completed the {0}:
{1}
"@
            Topics       = $_.RequestedTopic
        }
    }

    Write-FormatViewExpression -If { -not $_.RequestedTopic } -Text @"
    Congratulations! You have made great progress towards enlightenment.

    The journey to mastery is never-ending; if at any point you feel the need to
    revisit a topic, you can simply call "Reset-PSKoan -Topic `$name" to reset
    that specific topic and work through it once again.

    May your newfound knowledge serve you well, and may you find myriad ways to
    pass it along to others in turn.

    Mountains are, once again, merely mountains.
"@ -ForegroundColor 'PSKoans.Meditation.Text'

    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -Newline

    Write-FormatViewExpression -ScriptBlock { 1 } -ControlName Prompt.Koan

    Write-FormatViewExpression -ScriptBlock { $_ } -ControlName Prompt.ProgressPreamble

    Write-FormatViewExpression -If { $_.RequestedTopic.Count -gt 1 } -ControlName Prompt.ProgressBar -ScriptBlock {
        @{
            Completed = $_.CurrentTopic.Completed
            Total     = $_.CurrentTopic.Total
            Name      = $_.CurrentTopic.Name
            Width     = 0.5
        }
    }

    Write-FormatViewExpression -If { $_.RequestedTopic.Count -eq 1 } -ControlName Prompt.ProgressBar -ScriptBlock {
        @{
            Completed = $_.CurrentTopic.Completed
            Total     = $_.CurrentTopic.Total
            Name      = $_.CurrentTopic.Name
            Width     = 0.8
        }
    }

    Write-FormatViewExpression -If {
        -not $_.RequestedTopic -or
        $_.RequestedTopic.Count -gt 1
    } -ControlName Prompt.ProgressBar -ScriptBlock {
        @{
            Completed = $_.KoansPassed
            Total     = $_.TotalKoans
            Name      = 'Total'
            Width     = 0.8
        }
    }

    Write-FormatViewExpression -NewLine
    Write-FormatViewExpression -NewLine

    Write-FormatViewExpression -If { -not $_.RequestedTopic } -Text @"
    If you would like to further your studies in this manner, consider investing in
    "PowerShell by Mistake" by Don Jones - https://leanpub.com/powershell-by-mistake
"@ -ForegroundColor 'PSKoans.Meditation.Text'
}
