[CmdletBinding()]

param()

$toolsPath = "$($env:AGENT_TOOLSDIRECTORY)/PowerBI"

if (-not (Test-Path $toolsPath))
{
	New-Item -ItemType Directory $toolsPath | Out-Null
}

Copy-Item Modules $toolsPath -Recurse -Force
Copy-Item Scripts $toolsPath -Recurse -Force

Set-VstsTaskVariable -Name "PowerBI_Tools_Path" -Value $toolsPath