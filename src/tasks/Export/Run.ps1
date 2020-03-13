Trace-VstsEnteringInvocation $MyInvocation

Try
{
	#If (-not ($toolsPath = Get-VstsTaskVariable -Name "PowerBI_Tools_Path"))
	#{
	#	#Write-VstsTaskError -Message "Please add the 'Power BI Tool Installer' before this task."
	#}
	#Else
	#{
	#	#Import-Module "$toolsPath/Modules/PowerBI" -Force
	#}

	# Connect
	#Connect-PowerBI -Endpoint (Get-VstsEndpoint -Name (Get-VstsInput -Name Connection))

	# Execute
	$Group = Get-VstsInput -Name Workspace
	$Report = Get-VstsInput -Name Report
	$FileFormat = Get-VstsInput -Name FileFormat
	$Parameters = Get-VstsInput -Name Parameters

	$Export = New-PowerBIExport -Group $Group -Report $Report -FileFormat $FileFormat -Parameters $Parameters


}
Finally
{
	Trace-VstsLeavingInvocation $MyInvocation
}