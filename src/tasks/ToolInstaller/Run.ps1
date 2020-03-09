[CmdletBinding()]

param()

$toolsPath = "$($env:AGENT_TOOLSDIRECTORY)/PowerBI/1.0.13"

if (-not (Test-Path $toolsPath))
{
	New-Item -ItemType Directory $toolsPath | Out-Null
	Move-Item Modules $toolsPath
	Move-Item Scripts $toolsPath
}

Set-VstsTaskVariable -Name "PowerBI_Tools_Path" -Value $toolsPath