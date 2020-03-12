Function Get-PowerBIDatasets
{
	Param
	(
	    [Parameter(Mandatory = $false)][string]$Group
	)

	$Url = Get-PowerBIUrl -Group $Group -Url "datasets"
	$Results = Invoke-PowerBI -Method Get -Url $Url

	return $Results.value
}