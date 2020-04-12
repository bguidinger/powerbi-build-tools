Function Update-PowerBIPermissions
{
	$Url = Get-PowerBIUrl "RefreshUserPermissions"

	Invoke-PowerBI -Method Post -Url $Url
}