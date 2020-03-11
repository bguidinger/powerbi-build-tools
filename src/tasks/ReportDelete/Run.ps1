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

	$group = Get-VstsInput -Name Workspace
	$groupId = Invoke-Expression "$toolsPath/Scripts/Get-PowerBIGroup.ps1 -Name '$group'"
	
	$report = Get-VstsInput -Name Report
	$reportId = Invoke-Expression "$toolsPath/Scripts/Get-PowerBIReport.ps1 -Name '$report' -GroupId '$groupId'"

	if ($reportId)
	{
		if ($groupId)
		{
			Invoke-PowerBIRestMethod -Method Delete -Url "groups/$groupId/reports/$reportId"
		}
		else
		{
			Invoke-PowerBIRestMethod -Method Delete -Url "reports/$reportId"
		}
	}
	else
	{
		Write-VstsTaskError -Message "Unable to find a report with the name '$name'"
	}
}
finally
{
	Trace-VstsLeavingInvocation $MyInvocation
}