#Requires -Modules PSKoans

InModuleScope 'PSKoans' {
    Describe "Show-Advice" {

        BeforeAll{
            Mock Write-ConsoleLine { } 
            $Backup = @()
            # Exporting incorrect advices to the folder
            $AdviceFolder = $script:ModuleRoot | Join-Path -ChildPath 'Data/Advice'
            $AdviceObject = Get-ChildItem -Path $AdviceFolder -Recurse -File -Filter "*.Advice.json"
            $RandomAdvicesFilePaths = ($AdviceObject | Get-Random -Count 3).FullName
            $Backup = $RandomAdvicesFilePaths | ForEach-Object {Get-Content $_ | ConvertFrom-Json}
        }

        Context "Behaviour of Parameter-less Calls" {
            $result = Show-Advice

            It "calls Write-ConsoleLine with Parameter -Title" {
                Assert-MockCalled -CommandName Write-ConsoleLine -ParameterFilter { $null -eq $Title }
            }

            It "calls Write-ConsoleLine with only the display string" {
                Assert-MockCalled -CommandName Write-ConsoleLine -ParameterFilter { $null -ne $Title } -Times 1
            }
            
            It "outputs nothing to the pipeline" {
                $result | Should -BeNullOrEmpty
            }
        }

        Context "Behaviour with -Name Parameter" {

            It "should call Write-ConsoleLine with normal parameters" {
                Show-Advice -Name "Profile" 
                Assert-MockCalled -CommandName Write-ConsoleLine -ParameterFilter { $null -ne $Title }
            }

            It "should call Write-ConsoleLine without parameters" {
                Show-Advice -Name "Profile" 
                Assert-MockCalled -CommandName Write-ConsoleLine -ParameterFilter { $null -eq $Title }
            }

            It "should throw an error if the requested file cannot be found" {
                $message = "Could not find any Advice files matching the specified Name: ThisDoesntExist"
                { Show-Advice -Name "ThisDoesntExist" -ErrorAction Stop } | Should -Throw -ExpectedMessage $Message
            }

            # Creating incorrect Advice
            $IncorrectObjectsData = @(
                @{
                    NotTitle = "Fake title"
                    NotContent = @(1..4 | ForEach-Object {"Fake line $_"})
                },
                @{
                    Content = @(1..4 | ForEach-Object {"Fake line $_"})
                },
                @{
                    Title = "Fake title"
                }
            )
            for ($i = 0; $i -lt 3; $i++) {
                $IncorrectObjectsData[$i] | ConvertTo-Json | Out-File $RandomAdvicesFilePaths[$i]
            }
            
            It "should throw an error if the requested file's format is not correct" {
                for ($i = 0; $i -lt 3; $i++) {
                    $AdviceName = (Get-Item $RandomAdvicesFilePaths[$i]).BaseName -replace('^(.*)(?:.Advice)','$1')
                    $Message = "Could not find Title and/or Content elements for Advice file: {0}" -f $AdviceName
                    { Show-Advice -Name $AdviceName -ErrorAction Stop } | Should -Throw -ExpectedMessage $Message
                }
            }

        }

        AfterAll{
            for ($i = 0; $i -lt 3; $i++) {
                Set-Content -Path ((Get-Item $RandomAdvicesFilePaths[$i]).FullName) -Value ($Backup[$i] | ConvertTo-Json)
            }
        }
    }   
}
