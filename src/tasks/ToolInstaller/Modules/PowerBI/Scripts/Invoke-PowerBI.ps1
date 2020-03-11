Function Invoke-PowerBI
{
	Param
	(
        [Parameter(Mandatory = $true)]$Method,
		[Parameter(Mandatory = $true)]$Url,
		[Parameter(Mandatory = $false)]$Body,
		[Parameter(Mandatory = $false)]$ContentType = 'application/json'
    )

	if (-not $script:EndpointUrl)
	{
		throw "You are not connected to Power BI."
	}

	$Headers = Get-PowerBIAccessToken
	$Uri = "$script:EndpointUrl/$Url"
	Write-Host $Uri
	Invoke-RestMethod -Method $Method -Headers $Headers -Uri $Uri -Body $Body -ContentType $ContentType
}