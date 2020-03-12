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
	$Type = Get-VstsInput -Name Action
	$Name = Get-VstsInput -Name Name
	$Action = Get-VstsInput -Name Action

	switch ($Action)
	{
		"SetState"
		{
			$Enabled = Get-VstsInput -Name Enabled -Require
			switch ($Type)
			{
				"Dataset"
				{
					Set-PowerBIDatasetRefreshSchedule -Group $Group -Dataset $Name -Enabled $Enabled
				}
				"Dataflow"
				{
					Set-PowerBIDataflowRefreshSchedule -Group $Group -Dataflow $Name -Enabled $Enabled
				}
			}
		}
	}
}
Finally
{
	Trace-VstsLeavingInvocation $MyInvocation
}