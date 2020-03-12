Function Set-PowerBICredentials
{
	Param
	(
	    [Parameter(Mandatory = $true)]$DataSources,
		[Parameter(Mandatory = $true)]$ConnectionStrings
	)

	$ConnectionStrings | Get-Member -MemberType Properties | % `
	{
		$ConnectionString = $ConnectionStrings.$($_.Name)

		$Builder = New-Object System.Data.SqlClient.SqlConnectionStringBuilder($ConnectionString)

		$Candidates = $DataSources | ? {$_.connectionDetails.server -eq $Builder.DataSource -and $_.connectionDetails.database -eq $Builder.InitialCatalog}
		foreach ($Candidate in $Candidates)
		{
			$Body = @{
				credentialDetails = @{
					credentialType = "Basic";
					credentials = "{`"credentialData`":[{`"name`":`"username`", `"value`":`"$($Builder.UserID)`"},{`"name`":`"password`", `"value`":`"$($Builder.Password)`"}]}";
					encryptedConnection = "Encrypted";
					encryptionAlgorithm = "None";
					privacyLevel = "None"
				}
			} | ConvertTo-Json

			$gatewayId = $Candidate.gatewayId
			$datasourceId = $Candidate.datasourceId

			Write-Host "Setting credentials: $($Builder.DataSource):$($Builder.InitialCatalog)"

			$Url = Get-PowerBIUrl -Url "gateways/$gatewayId/datasources/$datasourceId"

			$Response = Invoke-PowerBI -Method Patch -Url $Url -Body $Body
		}
	}
}