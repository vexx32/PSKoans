class FILL_ME_IN {}
class __ : FILL_ME_IN {}

class KoanAttribute : System.Attribute {
    [uint32] $Position
    [String] $HelpURL
    [String] $HelpPath
    [ScriptBlock] $HelpAction
    [String] $FilePath
    [System.Management.Automation.CommandInfo] $FileCmdlet
    [PSObject] $FilePesterTests

    KoanAttribute($Position, $HelpURL, $HelpAction) {
        $this.Position = $Position
        $this.HelpURL = $HelpURL
        $this.HelpAction = $HelpAction
    }

    KoanAttribute($Position, $HelpURL) {
        $this.Position = $Position
        $this.HelpURL = $HelpUrl
    }

    KoanAttribute($Position) {
        $this.Position = $Position
    }

    KoanAttribute() {
        $this.Position = [uint32]::MaxValue
    }

    [Object] InvokePester([HashTable]$PesterParams) {
        Write-Verbose "Testing karma with file [$($this.FileCmdlet.Name)]"

        $PesterParams.Script = $this.FilePath
        $this.FilePesterTests = Invoke-Pester @PesterParams
        return $this.FilePesterTests
    }

    [int] GetFailedCount() {
        return $this.FilePesterTests.FailedCount
    }

    [PSObject] GetTestResults([string]$Type) {
        switch ($Type) {
            'Failed' {
                return $this.FilePesterTests.TestResult | Where-Object Result -eq $Type
            }
            Default: {
                throw "Not Expected"
            }
        }
        
        return $false
    }

    [void] InvokeHelpAction() {
        $this.HelpAction.InvokeReturnAsIs()
    }

    [void] InvokeHelpURL() {
        Write-ConsoleLine "Confusion is only the beginning"
        Write-ConsoleLine "Your defeat has only made you stronger"
        Write-ConsoleLine ("Learn through Zen: {0}" -f $this.HelpURL)
    }

    [void] InvokeHelpPath() {
        Write-ConsoleLine "Confusion is only the beginning"
        Write-ConsoleLine "To become Master must be able to snatch the coin from my hand"
        Write-ConsoleLine ("You are improving but you must learn more about {0}" -f $this.HelpPath)
    }
    
    [void] InvokeHelpInfo() {
        if ($this.HelpAction) {
            $this.InvokeHelpAction()
        }
        elseif ($this.HelpPath) {
            $this.InvokeHelpPath()
        }
        elseif ($this.HelpURL) {
            $this.InvokeHelpURL()
        }
    }

}