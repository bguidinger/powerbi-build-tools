Trace-VstsEnteringInvocation $MyInvocation

Try
{
	$toolsPath = "$($env:AGENT_TOOLSDIRECTORY)/PowerBI"

	if (-not (Test-Path $toolsPath))
	{
		New-Item -ItemType Directory $toolsPath | Out-Null
	}

	Copy-Item Modules $toolsPath -Recurse -Force

	Set-VstsTaskVariable -Name "PowerBI_Tools_Path" -Value $toolsPath
}
Finally
{
	Trace-VstsLeavingInvocation $MyInvocation
}