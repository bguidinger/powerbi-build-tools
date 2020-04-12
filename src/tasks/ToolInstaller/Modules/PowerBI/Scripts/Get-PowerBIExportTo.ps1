Function Get-PowerBIExportTo
{
	Param
	(
	    [Parameter(Mandatory = $false)][string]$Group,
		[Parameter(Mandatory = $true)][string]$Report,
		[Parameter(Mandatory = $true)][string]$Export
	)

	$GroupId = Get-PowerBIGroup -Group $Group -Id
	$ReportId = Get-PowerBIReport -Group $GroupId -Report $Report -Id

	$Url = Get-PowerBIUrl -Group $GroupId -Url "reports/$ReportId/exports/$ExportId"
	$Result = Invoke-PowerBI -Method Get -Url $Url
		
	return $Result
}