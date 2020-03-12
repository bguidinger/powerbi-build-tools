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

	$Enabled = Get-VstsInput -Name Enabled
	$Days = Get-VstsInput -Name Days
	$Times = Get-VstsInput -Name Times
	$TimeZone = Get-VstsInput -Name TimeZone
	$NotifyOption = Get-VstsInput -Name NotifyOption

	switch ($Type)
	{
		"Dataset"
		{
			Set-PowerBIDatasetRefreshSchedule -Group $Group -Dataset $Name -Enabled $Enabled -Days $Days -Times $Times -TimeZone $TimeZone -NotifyOption $NotifyOption
		}
		"Dataflow"
		{
			Set-PowerBIDataflowRefreshSchedule -Group $Group -Dataflow $Name -Enabled $Enabled -Days $Days -Times $Times -TimeZone $TimeZone -NotifyOption $NotifyOption
		}
	}
}
Finally
{
	Trace-VstsLeavingInvocation $MyInvocation
}