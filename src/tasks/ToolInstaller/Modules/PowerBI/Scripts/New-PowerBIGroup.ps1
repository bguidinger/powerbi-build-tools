Function New-PowerBIGroup
{
	Param
	(
	    [Parameter(Mandatory = $true)][string]$Name
	)

	$Url = Get-PowerBIUrl -Url "groups"
	$Body = @{ name = $Name } | ConvertTo-Json

	Invoke-PowerBI -Method Post -Url $Url -Body $Body
}