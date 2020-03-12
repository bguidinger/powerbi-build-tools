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
	$Type = Get-VstsInput -Name Type
	$Name = Get-VstsInput -Name Name
	
	switch ($Type)
	{
		"Workspace"
		{
			New-PowerBIGroup -Name $Name
		}
	}
}
Finally
{
	Trace-VstsLeavingInvocation $MyInvocation
}