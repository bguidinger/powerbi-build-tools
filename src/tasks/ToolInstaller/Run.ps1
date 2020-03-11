[CmdletBinding()]

param()

$toolsPath = "$($env:AGENT_TOOLSDIRECTORY)/PowerBI"

if (-not (Test-Path $toolsPath))
{
	New-Item -ItemType Directory $toolsPath | Out-Null
}

Move-Item Modules $toolsPath -Force
Move-Item Scripts $toolsPath -Force

Set-VstsTaskVariable -Name "PowerBI_Tools_Path" -Value $toolsPath