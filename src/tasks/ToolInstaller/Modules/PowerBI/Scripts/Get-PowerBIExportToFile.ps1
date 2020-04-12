Function Get-PowerBIExportToFile
{
	Param
	(
	    [Parameter(Mandatory = $false)][string]$Group,
		[Parameter(Mandatory = $true)][string]$Report,
		[Parameter(Mandatory = $true)][string]$Export,
		[Parameter(Mandatory = $true)][string]$Path
	)

	$GroupId = Get-PowerBIGroup -Group $Group -Id
	$ReportId = Get-PowerBIReport -Group $GroupId -Report $Report -Id

	$Url = Get-PowerBIUrl -Group $GroupId -Url "reports/$ReportId/exports/{$Export}/file"

	Invoke-PowerBI -Method Get -Url $Url -OutFile $Path
}