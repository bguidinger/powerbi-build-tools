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

	$dataset = Get-VstsInput -Name Dataset
	$datasetId = Invoke-Expression "$toolsPath/Scripts/Get-PowerBIDataset.ps1 -Name '$dataset' -GroupId '$groupId'"

	if ($datasetId)
	{
		$body = @{ notifyOption = "NoNotification" } | ConvertTo-Json
		if ($groupId)
		{
			Invoke-PowerBIRestMethod -Method Post -Url "groups/$groupId/datasets/$datasetId/refreshes" -Body $body
		}
		else
		{
			Invoke-PowerBIRestMethod -Method Post -Url "datasets/$datasetId/refreshes" -Body $body
		}
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