Trace-VstsEnteringInvocation $MyInvocation

Try
{
	If (-not ($toolsPath = Get-VstsTaskVariable -Name "PowerBI_Tools_Path"))
	{
		Write-VstsTaskError -Message "Please add the 'Power BI Tool Installer' before this task."
	}
	Else
	{
		Import-Module "$toolsPath/Modules/PowerBI" -Force
	}

	# Connect
	Connect-PowerBI -Endpoint (Get-VstsEndpoint -Name (Get-VstsInput -Name Connection))

	# Execute
	$Group = Get-VstsInput -Name Workspace
	$Action = Get-VstsInput -Name Action
	$PrincipalType = Get-VstsInput -Name PrincipalType
	$Principal = Get-VstsInput -Name Principal
	$Permission = Get-VstsInput -Name Permission

	Switch ($Action)
	{
		"Add"
		{
			Add-PowerBIGroupUser -Group $Group -PrincipalType $PrincipalType -Principal $Principal -Permission $Permission
		}
		"Update"
		{
			Update-PowerBIGroupUser -Group $Group -PrincipalType $PrincipalType -Principal $Principal -Permission $Permission
		}
		"Remove"
		{
			Remove-PowerBIGroupUser -Group $Group -Principal $Principal
		}
		"Refresh"
		{
			Update-PowerBIPermissions
		}
	}
}
Finally
{
	Trace-VstsLeavingInvocation $MyInvocation
}