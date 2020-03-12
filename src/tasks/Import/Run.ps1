Trace-VstsEnteringInvocation $MyInvocation

Try
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
	$Path = Get-VstsInput -Name Path
	$ConnectionStrings = Get-VstsInput -Name ConnectionStrings | ConvertFrom-Json -ErrorAction SilentlyContinue

	$Files = Get-ChildItem -Path $Path

	foreach ($File in $Files)
	{
		$GroupId = Get-PowerBIGroup -Group $group -Id

		$Import = New-PowerBIImport -Group $GroupId -File $File -ConnectionStrings $ConnectionStrings

		Set-PowerBIReportCredentials -Group $GroupId -Report $Import.reports.id -ConnectionStrings $ConnectionStrings
	}
}
Finally
{
	Trace-VstsLeavingInvocation $MyInvocation
}