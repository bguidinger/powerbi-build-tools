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
	$Type = Get-VstsInput -Name Type
	$Name = Get-VstsInput -Name Name
	$NotifyOption = Get-VstsInput -Name NotifyOption

	switch ($Type)
	{
		"Dataset"
		{
			Update-PowerBIDataset -Group $Group -Dataset $Name -NotifyOption $NotifyOption
		}
		"Dataflow"
		{
			Update-PowerBIDataflow -Group $Group -Dataflow $Name -NotifyOption $NotifyOption
		}
	}
}
Finally
{
	Trace-VstsLeavingInvocation $MyInvocation
}