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

	$name = Get-VstsInput -Name Name
	$groupId = Invoke-Expression "$toolsPath/Scripts/Get-PowerBIWorkspace.ps1 -Name '$name'"

	if ($groupId)
	{
		Invoke-PowerBIRestMethod -Method Delete -Url "groups/$groupId"
	}
	else
	{
		Write-VstsTaskError -Message "Unable to find a workspace with the name '$name'"
	}
}
finally
{
	Trace-VstsLeavingInvocation $MyInvocation
}