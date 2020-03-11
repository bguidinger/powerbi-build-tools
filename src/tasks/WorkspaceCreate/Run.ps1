[CmdletBinding()]

param()

Trace-VstsEnteringInvocation $MyInvocation

try
{
	$toolsPath = Get-VstsTaskVariable -Name "PowerBI_Tools_Path"
	if (-not $toolsPath)
	{
		Write-VstsTaskError -Message "Please add the 'Power BI Tool Installer' before this task."
	}

	Invoke-Expression "$toolsPath/Scripts/Connect-PowerBI.ps1"

	$name = Get-VstsInput -Name name
	$body = @{ name = $name } | ConvertTo-Json

	Invoke-PowerBIRestMethod -Method Post -Url "groups" -Body $body
}
finally
{
	Trace-VstsLeavingInvocation $MyInvocation
}