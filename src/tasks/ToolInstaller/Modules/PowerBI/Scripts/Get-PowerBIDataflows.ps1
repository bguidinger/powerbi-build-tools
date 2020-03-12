Function Get-PowerBIDataflows
{
	Param
	(
	    [Parameter(Mandatory = $true)][string]$Group
	)

	$Url = Get-PowerBIUrl -Group $Group -Url "dataflows"
	$Results = Invoke-PowerBI -Method Get -Url $Url

	return $Results.value
}