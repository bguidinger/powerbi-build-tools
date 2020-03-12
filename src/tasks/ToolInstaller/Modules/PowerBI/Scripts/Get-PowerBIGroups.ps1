Function Get-PowerBIGroups
{
	$Url = "groups"
	$Results = Invoke-PowerBI -Method Get -Url $Url
		
	return $Results.value
}