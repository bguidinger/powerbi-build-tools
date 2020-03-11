[string]$EndpointUrl = $null

Function Connect-PowerBI
{
	Param
	(
        [Parameter(Mandatory = $true)]$Endpoint
    )

	$path = "$PSScriptRoot/../MicrosoftPowerBIMgmt.Profile"
	if (Test-Path $path)
	{
		Import-Module -Name "$PSScriptRoot/../MicrosoftPowerBIMgmt.Profile"
	}
	Else
	{
		$module = Get-Module MicrosoftPowerBIMgmt.Profile
		if (-not $module)
		{
			Install-Module MicrosoftPowerBIMgmt.Profile -Scope CurrentUser
		}
		Import-Module MicrosoftPowerBIMgmt.Profile
	}
	
	$script:EndpointUrl = $Endpoint.Url

	$authScheme = $Endpoint.Auth.Scheme
	$environment = $Endpoint.Data.Environment

	If ($authScheme -eq "UsernamePassword")
	{
		$username = $Endpoint.Auth.Parameters.Username
		$password = ConvertTo-SecureString $Endpoint.Auth.Parameters.Password -AsPlainText -Force
		$credential = New-Object System.Management.Automation.PSCredential $username, $password

		Connect-PowerBIServiceAccount -Environment $environment -Credential $credential
	}
	Else
	{
		$tenantId = $Endpoint.Auth.Parameters.TenantId	
		$clientId = $Endpoint.Auth.Parameters.ClientId
		$clientSecret = ConvertTo-SecureString $Endpoint.Auth.Parameters.ClientSecret -AsPlainText -Force
		$credential = New-Object System.Management.Automation.PSCredential $clientId, $clientSecret

		Connect-PowerBIServiceAccount -Environment $environment -Tenant $tenantId -Credential $credential -ServicePrincipal
	}
}