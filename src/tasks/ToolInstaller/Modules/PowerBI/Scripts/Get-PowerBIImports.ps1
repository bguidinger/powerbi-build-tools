Function Get-PowerBIImports
{
	Param
	(
	    [Parameter(Mandatory = $false)][string]$Group
	)

	$Url = Get-PowerBIUrl -Group $Group -Url "imports"
	$Results = Invoke-PowerBI -Method Get -Url $Url

	return $Results.value
}