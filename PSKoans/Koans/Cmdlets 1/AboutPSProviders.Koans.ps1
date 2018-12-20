using module PSKoans
[Koan(Position = 202)]
param()
<#
    PSProviders

    Providers are PowerShell's general-purpose solution for accessing resources. The default set of
    providers that come with PowerShell on all platforms are listed below:

    Name                 Capabilities                            Drives
    ----                 ------------                            ------
    Alias                ShouldProcess                           {Alias}
    Environment          ShouldProcess                           {Env}
    FileSystem           Filter, ShouldProcess, Credentials      {/}
    Function             ShouldProcess                           {Function}
    Variable             ShouldProcess                           {Variable}

    Several are for accessing internal PowerShell resources (aliases, functions, variables), but the
    rest typically interact with the surrounding environment like the filesystem or OS environment.

    On Windows, PowerShell also comes with a Registry provider, for interacting with the Windows
    registry.

    All providers that have a defined function with the Get-Content cmdlet can also be accessed
    similarly to variable scopes, e.g., { $env:Path } instead of { Get-Content 'Env:Path' }
#>
Describe 'Alias Provider' {
    <#
        Aliases are PowerShell command shortcuts. By querying the Alias: provider, you can get a
        list of all command shortcuts in the current session. The available aliases may increase
        when a new module is imported.
    #>
    Context 'Direct Access' {

        It 'can be queried with generic provider cmdlets' {
            $Aliases = Get-ChildItem 'Alias:'

            __ | Should -Be $Aliases.Name[0]
            __ | Should -Be $Aliases.Definition[0]
        }

        It 'maps aliases to the full command' {
            $Alias = '__'
            $AliasObject = Get-Item "Alias:\$Alias" -ErrorAction SilentlyContinue

            $AliasObject | Get-Content | Should -Be 'Set-Location'
        }

        It 'can create aliases too!' {
            __ | Should -Be $Aliases.Count

            New-Item -Path 'Alias:\grok' -Value 'Get-Item' -ErrorAction SilentlyContinue
            $File = grok '__' -ErrorAction SilentlyContinue

            $File | Should -BeOfType 'System.IO.FileInfo'
            __ | Should -Be $Aliases.Count

            Remove-Item -Path 'Alias:\grok'
        }
    }

    Context 'Access Via Cmdlet' {

        It 'can be accessed with Get-Alias' {
            $AliasObjects = Get-ChildItem 'Alias:'
            $AliasObjects2 = Get-Alias

            __ | Should -Be $AliasObjects2.Count
            $AliasObjects | Should -Be $AliasObjects2
        }

        It 'allows for seeking out aliases for a command' {
            $CmdletName = __
            $AliasData = Get-Alias -Definition $CmdletName

            $AliasData.Name | Should -Be 'gcm'
        }

        It 'can be used to find the exact command' {
            $AliasData = Get-Alias -Name 'ft'

            '__' | Should -Be $AliasData.Definition
        }

        It 'can create aliases too!' {
            Set-Alias -Name 'grok' -Value 'Get-Item'
            $File = grok $home

            $File | Should -BeOfType __
        }
    }

    Context 'Variable Access' {

        It 'can be accessed like a variable' {
            __ | Should -Be $Alias:gci
        }

        It 'is the same as using Get-Content on the path' {
            Get-Content -Path 'Alias:\gcm' | Should -Be $Alias:gcm

            $AliasTarget = Get-Content -Path 'Alias:\echo'
            __ | Should -Be $AliasTarget
        }
    }
}

Describe 'Environment Provider' {
    <#
        The Env: drive contains system environment data. Its contents can vary wildly from OS to OS,
        especially between Windows, Mac, and Linux, for example.

        The only shared Env: items across all OS's currently are Path and PSModulePath.
    #>
    $EnvironmentData = Get-ChildItem -Path 'Env:'

    It 'allows access to system environment data' {
        $SelectedItem = $EnvironmentData.Where{ $_.Value -is [string] }[7]
        $Content = $SelectedItem | Get-Content

        '__' | Should -Be $Content
        '__' | Should -Be $SelectedItem.Name
    }

    It 'can be accessed via variables' {
        '__' | Should -Be $env:Path
    }
}

Describe 'FileSystem Provider' {
    $Path = 'TestDrive:' | Join-Path -ChildPath 'File001.tmp'
    if (-not (Test-Path $Path)) {
        New-Item -Path $Path > $null

        -join (1..10000 | ForEach-Object {
                Get-Random -Minimum 32 -Maximum 96 |
                    ForEach-Object {[char]$_ -as [string]}
                if ((Get-Random) -match '[25]0$') {
                    "`n"
                }
            }) | Set-Content -Path $Path
    }

    It 'allows access to various files and their properties' {
        $File = Get-Item -Path $Path

        '__' | Should -Be $File.Name
        '__' | Should -Be $File.Attributes
        '__' | Should -Be $File.Length
    }

    It 'allows you to extract the contents of files' {
        $FirstLine = Get-Content -Path $Path | Select-Object -First 1
        '__' | Should -Be $FirstLine
    }

    It 'allows you to copy, rename, or delete files' {
        $File = Get-Item -Path $Path

        $NewPath = "$Path-002"
        $NewFile = Copy-Item -Path $Path -Destination $NewPath -PassThru

        $NewFile.Length | Should -Be $File.Length
        '__' | Should -Be $NewFile.Name

        $NewFile = Rename-Item -Path $NewPath -NewName 'TESTNAME.tmp' -PassThru
        '__' | Should -Be $NewFile.Name
        '__' | Should -Be $NewFile.Length

        $FilePath = $NewFile.FullName
        Remove-Item -Path $FilePath
        {Get-Item -Path $FilePath -ErrorAction Stop} | Should -Throw -ExceptionType '__'
    }
}

Describe 'Function Provider' {
    $Functions = Get-ChildItem 'Function:'

    It 'allows access to all currently loaded functions' {
        # Most proper functions are named in the Verb-Noun convention
        '__' | Should -Be $Functions[5].Verb
        '__' | Should -Be $Functions[5].Noun
        '__' | Should -Be $Functions[5].Name

        '__' | Should -Be $Functions[4].Name
    }

    It 'exposes the entire script block of a function' {
        $Functions[3].ScriptBlock | Should -BeOfType ScriptBlock
        __ | Should -Be $Functions[1].ScriptBlock.ToString().Length

        $Functions[4] | Get-Content | Should -BeOfType __
    }

    It 'allows you to rename the functions however you wish' {
        function Test-Function {'Hello!'}

        $TestItem = Get-Item 'Function:\Test-Function'
        Test-Function | Should -Be 'Hello!'

        $TestItem | Rename-Item -NewName 'Get-Greeting'
        '__' | Should -Be (Get-Greeting)
    }

    It 'can also be accessed via variables' {
        function Test-Function {'Bye!'}
        <#
            Because most functions use hyphens, their names are atypical for variables, and the ${}
            syntax must be used to indicate to the PowerShell parser that all contained characters
            are part of the variable name.
        #>
        ${function:Test-Function} | Should -BeOfType __
    }

    It 'can be defined using variable syntax' {
        <#
            Although slower than the usual method of creating functions, it is a quick way to make a
            function out of a script block.
        #>
        $Script = {
            1..3
        }
        ${function:Get-Numbers} = $Script

        __ | Should -Be (Get-Numbers)
    }
}

Describe 'Variable Provider' {
    <#
        The variable provider allows direct access to variables as objects, allowing you to determine
        the name, value, and metadata of variables that are available in the current session and scope.
    #>
    Context 'Generic Cmdlets' {

        It 'allows access to variables in the current scope' {
            Set-Variable -Name 'Test' -Value 22
            $VariableData = Get-Item 'Variable:\Test'

            $VariableData.Name | Should -Be 'Test'
            __ | Should -Be $VariableData.Value
            __ | Should -Be $VariableData.Options
        }

        It 'allows you to remove variables' {
            $Test = 123

            __ | Should -Be $Test

            Remove-Item 'Variable:\Test'
            __ | Should -Be $Test
            {Get-Item 'Variable:\Test'} | Should -Throw -ExceptionType __
        }

        It 'exposes data from default variables' {
            $Variables = Get-ChildItem 'Variable:'

            __ | Should -Be $Variables.Where{$_.Name -eq 'ConfirmPreference'}.Value
            __ | Should -Be $Variables.Where{$_.Name -eq 'MaximumAliasCount'}.Value
        }

        It 'allows you to set variable options' {
            Set-Variable -Name 'Test' -Value 'TEST'

            $Var = Get-Item 'Variable:\Test'
            $Var.Options = [System.Management.Automation.ScopedItemOptions]::ReadOnly

            __ | Should -Be $Var
            {Remove-Item 'Variable:\Test'} | Should -Throw -ExceptionType __
        }
    }

    Context 'Variable Cmdlets' {

        It 'works similarly to the generic cmdlets' {
            Set-Variable 'test' -Value 7357

            $Info = Get-Variable -Name 'Test'
            'test' | Should -Be $Info.Name
            __ | Should -Be $Info.Options
            __ | Should -Be $Info.Value
        }

        It 'can retrieve just the value' {
            Set-Variable 'GetMe' -Value 'GOT!'

            $Get = Get-Variable -Name 'GetMe' -ValueOnly

            __ | Should -Be $Get
        }
    }
}

