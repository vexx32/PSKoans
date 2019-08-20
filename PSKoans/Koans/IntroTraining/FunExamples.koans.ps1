using module PSKoans
[Koan(Position = 102)]
param()
<#

    FunExamples

    PowerShell is a super fun, and versitile, scripting language based off of .NET.
    To get you excited about the language we've given you some sample code to run.

    Once you've gone through the examples simply mark each __ as $true

#>

Describe 'Examples' {

    It 'rickroll' {
        <# The code provided will download a PowerShell script from the interwebs.

         This script plays the entire music video to the 1987 Rick Astley Song 
         "Never Gonna Give You Up"... but in ASCII!

         Turn down your sound for this one though, it can be quite loud!

         Run the following code by removing the "#" then running it in your PowerShell Window

         iex (New-Object Net.WebClient).DownloadString("http://bit.ly/e0Mw9w")

        #> 
        
        #Once run change __ to 'True!'
        '__' | Should -Be 'True!'
    }
    It 'catFacts' {
        # This example queries a database of cat facts then reads them out using

        # a speech synthesizer. Copy the entire comment block in <##> and run
        
        <#
        function CatFactsGalore{

        Add-Type -AssemblyName System.Speech
        $SpeechSynth = New-Object System.Speech.Synthesis.SpeechSynthesizer
        $Random = Get-Random -Maximum 200
        $CatFact = (ConvertFrom-Json (Invoke-WebRequest -Uri http://www.catfact.info/api/v1/facts.json?per_page=200)).Facts[$Random]
        $SpeechSynth.Speak("did you know?")
        $SpeechSynth.Speak($CatFact.details)
        } 

        CatFactsGalore
        
        #>
        # Once run change __ to 'True!'
        '__' | Should -Be 'True!'

    }

    It "GUI" {
        <#
        As PowerShell is based off of .NET it can also invoke .NET objects. Don't worry if
        this doesn't make much sense, we'll cover it all later!

        One such example is that we can create a graphical user interface, or GUI, using PowerShell.

        Once you have enough knowledge at your disposal you might want to make GUIS for your programs!

        To see the example, copy the code inside the next code block then change __ to 'True!'
        #>
        <#
        # Import Assemblies 
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")


        # Create a new form object and assign it to the variable GUIExample
        $GUIExample = New-Object System.Windows.Forms.Form

        # Define the background image and then set the form to be the same height/width as the image
        $BackgroundImage = [System.Drawing.Image]
        $GUIExample.BackColor = "Blue"
        $GUIExample.Width = 200
        $GUIExample.Height = 400

        # Make the GUI the topmost window and give it focus (make it the selected window)
        $GUIExample.TopMost = $True
        $GUIExample.Add_Shown({$GUIExample.Activate()})

        # Show the GUI
        [void]$GUIExample.ShowDialog()
        #>
        '__' | Should -Be 'True!'

    }







}