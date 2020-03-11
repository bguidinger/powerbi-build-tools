Trace-VstsEnteringInvocation $MyInvocation

try
{
	If (-not ($toolsPath = Get-VstsTaskVariable -Name "PowerBI_Tools_Path"))
	{
		Write-VstsTaskError -Message "Please add the 'Power BI Tool Installer' before this task."
	}
	Else
	{
		Import-Module "$toolsPath/Modules/PowerBI"
	}

	# Connect
	Connect-PowerBI -Endpoint (Get-VstsEndpoint -Name (Get-VstsInput -Name Connection))

	# Execute
	$Group = Get-VstsInput -Name Workspace
	$Report = Get-VstsInput -Name Report

	Remove-PowerBIReport -Group $Group -Report $Report
}
finally
{
	Trace-VstsLeavingInvocation $MyInvocation
}