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
	$ConnectionStrings = Get-VstsInput -Name ConnectionStrings | ConvertFrom-Json -ErrorAction SilentlyContinue

	switch ($Type)
	{
		"Dataset"
		{
			Set-PowerBIDatasetCredentials -Group $Group -Dataset $Name -ConnectionStrings $ConnectionStrings
		}
		"Dataflow"
		{
			Set-PowerBIDataflowCredentials -Group $Group -Dataflow $Name -ConnectionStrings $ConnectionStrings
		},
		"Report"
		{
			Set-PowerBIReportCredentials -Group $Group -Report $Name -ConnectionStrings $ConnectionStrings
		}
	}
}
Finally
{
	Trace-VstsLeavingInvocation $MyInvocation
}