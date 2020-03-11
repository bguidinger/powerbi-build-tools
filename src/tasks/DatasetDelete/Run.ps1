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

	$group = Get-VstsInput -Name workspace
	$groupId = Invoke-Expression "$toolsPath/Scripts/Get-PowerBIGroup.ps1 -Name '$group'"
	
	$dataset = Get-VstsInput -Name dataset
	$datasetId = Invoke-Expression "$toolsPath/Scripts/Get-PowerBIDataset.ps1 -Name '$dataset' -GroupId '$groupId'"

	if ($datasetId)
	{
		if ($groupId)
		{
			Invoke-PowerBIRestMethod -Method Delete -Url "groups/$groupId/datasets/$datasetId"
		}
		else
		{
			Invoke-PowerBIRestMethod -Method Delete -Url "datasets/$datasetId"
		}
	}
	else
	{
		Write-VstsTaskError -Message "Unable to find a dataset with the name '$dataset'"
	}
}
finally
{
	Trace-VstsLeavingInvocation $MyInvocation
}