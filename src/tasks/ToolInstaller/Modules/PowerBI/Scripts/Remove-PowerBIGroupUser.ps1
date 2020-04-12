Function Remove-PowerBIGroupUser
{
	Param
	(
		[Parameter(Mandatory = $true)][string]$Group,
		[Parameter(Mandatory = $true)][string]$Principal
	)

	$GroupId = Get-PowerBIGroup -Group $Group -Id

	$Url = Get-PowerBIUrl -Group $GroupId "users/$Principal"

	Invoke-PowerBI -Method Delete -Url $Url
}