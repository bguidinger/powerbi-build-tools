Function Get-PowerBIReports
{
	Param
	(
	    [Parameter(Mandatory = $false)][string]$Group
	)

	$Url = Get-PowerBIUrl -Group $Group -Url "reports"
	$Results = Invoke-PowerBI -Method Get -Url $Url

	return $Results.value
}