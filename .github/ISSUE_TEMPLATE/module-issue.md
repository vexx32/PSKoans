---
name: "💥 Module Issue or Bug"
about: File an issue or bug report about the module features/functions themselves.

---

# Describe "Module Bug or Issue"

<!-- A clear and concise description of the problems you're encountering. -->

## Context "The Problem"

<!-- Describe the issue you're having, and what you're doing that seems to be triggering it. -->

## Context "Expected Behavior"

<!-- Describe or give examples of the behavior you _expected_ to see, but did not. -->

## Context "Additional Information"

<!-- Please run the below commands and include the output in the code block. -->

```powershell
Get-Module -Name PSKoans -ListAvailable |
    Select-Object -Property Name, Version

$PSVersionTable | Out-String
```

<!-- Add any other context or references you think would be helpful (existing unit tests, documentation, etc.) -->
