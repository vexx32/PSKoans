Write-FormatView -AsList -TypeName PSKoans.Result -Name List -Property Describe, It, Expectation, Meditation, KoansPassed, TotalKoans, CurrentTopic

Write-FormatView -TypeName PSKoans.Result -Name Meditation -Action {

    Write-FormatViewExpression -ScriptBlock { 1 } -ControlName Prompt.Preface

    Write-FormatViewExpression -ScriptBlock { $_.Describe } -ControlName Prompt.Describe

    Write-FormatViewExpression -ScriptBlock { $_ } -ControlName Prompt.Expectation

    Write-FormatViewExpression -ScriptBlock { $_ } -ControlName Prompt.Meditation

    Write-FormatViewExpression -ScriptBlock { 1 } -ControlName Prompt.Koan

    Write-FormatViewExpression -If { $_.RequestedTopic } -ControlName Prompt.TopicList -ScriptBlock {
        @{
            Topics       = $_.RequestedTopic
            FormatString = @"
    You must meditate further on your selected {0}:
{1}
"@
        }
    }

    Write-FormatViewExpression -ScriptBlock { $_ } -ControlName Prompt.ProgressPreamble

    Write-FormatViewExpression -If { $_.RequestedTopic.Count -ne 1 } -ControlName Prompt.ProgressBar -ScriptBlock {
        @{
            Completed = $_.CurrentTopic.Completed
            Total     = $_.CurrentTopic.Total
            Name      = $_.CurrentTopic.Name
            Width     = 0.5
        }
    }

    Write-FormatViewExpression -If { $_.RequestedTopic.Count -eq 1 } -ControlName Prompt.ProgressBar -ScriptBlock { @{
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

    Write-FormatViewExpression -ScriptBlock { 1 } -ControlName Prompt.End
}

Write-FormatView -TypeName PSKoans.Result -Name Detailed -Action {

    Write-FormatViewExpression -ScriptBlock { $_ } -ControlName Prompt.Expectation

    Write-FormatViewExpression -ScriptBlock { $_ } -ControlName Prompt.Meditation

    Write-FormatViewExpression -ScriptBlock { 1 } -ControlName Prompt.Koan

    Write-FormatViewExpression -If { $_.RequestedTopic } -ControlName Prompt.TopicList -ScriptBlock {
        @{
            Topics       = $_.RequestedTopic
            FormatString = @"
    You must meditate further on your selected {0}:
{1}
"@
        }
    }

    Write-FormatViewExpression -ScriptBlock { $_ } -ControlName Prompt.ProgressPreamble

    Write-FormatViewExpression -Newline

    Write-FormatViewExpression -ScriptBlock { $_.Results } -ControlName Prompt.Details -Enumerate

    $ExecutionContext.SessionState.PSVariable.Remove("global:_Koan_Block_Name")
    # $ExecutionContext.SessionState.PSVariable.Remove("global:_Koan_Context")

    Write-FormatViewExpression -If { $_.RequestedTopic.Count -ne 1 } -ControlName Prompt.ProgressBar -ScriptBlock {
        @{
            Completed = $_.CurrentTopic.Completed
            Total     = $_.CurrentTopic.Total
            Name      = $_.CurrentTopic.Name
            Width     = 0.5
            Newline   = $true
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
}
