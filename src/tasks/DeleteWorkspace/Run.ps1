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

	# Connect
	& "$toolsPath/Scripts/Connect-PowerBI.ps1"

	$name = Get-VstsInput -Name Name

	$result = Invoke-PowerBIRestMethod -Method Get -Url "groups?`$filter=name eq '$name'" | ConvertFrom-Json
	
	$groupId = $result.value[0].id
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