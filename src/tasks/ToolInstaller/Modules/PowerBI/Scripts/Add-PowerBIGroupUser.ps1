Function Add-PowerBIGroupUser
{
	Param
	(
		[Parameter(Mandatory = $true)][string]$Group,
	    [Parameter(Mandatory = $true)][string]$PrincipalType,
		[Parameter(Mandatory = $true)][string]$Principal,
		[Parameter(Mandatory = $true)][string]$Permission
	)

	$GroupId = Get-PowerBIGroup -Group $Group -Id

	$Url = Get-PowerBIUrl -Group $GroupId "users"
	If ($PrincipalType -eq "User")
	{
		$Body = @{
			principalType = $PrincipalType;
			groupUserAccessRight = $Permission;
			emailAddress = $Principal;
		} | ConvertTo-Json
	}
	Else
	{
		$Body = @{
			principalType = $PrincipalType;
			groupUserAccessRight = $Permission;
			identifier = $Principal;
		} | ConvertTo-Json
	}

	Invoke-PowerBI -Method Post -Url $Url -Body $Body
}