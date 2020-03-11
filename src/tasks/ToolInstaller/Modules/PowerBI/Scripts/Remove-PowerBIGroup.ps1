Function Remove-PowerBIGroup
{
	Param
	(
	    [Parameter(Mandatory = $true)][string]$Group
	)

	$Url = Get-PowerBIUrl -Group $Group

	Invoke-PowerBI -Method Delete -Url $Url
}