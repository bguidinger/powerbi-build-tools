Function Get-PowerBIReportDataSources
{
	Param
	(
	    [Parameter(Mandatory = $false)][string]$Group,
		[Parameter(Mandatory = $true)][string]$Report
	)

	$GroupId = Get-PowerBIGroup -Group $Group -Id
	$ReportId = Get-PowerBIReport -Group $GroupId -Report $Report -Id

	$Url = Get-PowerBIUrl -Group $GroupId -Url "reports/$ReportId/datasources"
	$Results = Invoke-PowerBI -Method Get -Url $Url

	return $Results.value
}