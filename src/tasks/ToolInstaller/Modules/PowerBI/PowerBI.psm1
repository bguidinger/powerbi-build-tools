Get-ChildItem -Path $PSScriptRoot\Scripts\*.ps1 | % {. $_.FullName }

Export-ModuleMember -Function *