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
	$Name = Get-VstsInput -Name Name
	$FileFormat = Get-VstsInput -Name FileFormat
	$Path = Get-VstsInput -Name Path

	If ($FileFormat -eq "PBIX")
	{
		New-PowerBIExport -Group $Group -Report $Name -FileFormat $FileFormat -Path $Path
	}
	Else
	{
		New-PowerBIExportTo -Group $Group -Report $Name -FileFormat $FileFormat -Path $Path
	}
}
Finally
{
	Trace-VstsLeavingInvocation $MyInvocation
}