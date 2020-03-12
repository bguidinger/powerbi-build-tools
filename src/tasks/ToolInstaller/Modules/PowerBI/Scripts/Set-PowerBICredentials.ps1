Function Set-PowerBICredentials
{
	Param
	(
	    [Parameter(Mandatory = $true)]$DataSources,
		[Parameter(Mandatory = $true)]$ConnectionStrings
	)

	foreach ($ConnectionString in $ConnectionStrings)
	{
		$Builder = New-Object System.Data.SqlClient.SqlConnectionStringBuilder($ConnectionString)
		$Candidates = $DataSources | ? {$_.connectionDetails.server -eq $Builder.DataSource -and $_.connectionDetails.database -eq $Builder.InitialCatalog}
		foreach ($Candidate in $Candidates)
		{
			$Body = @{
				credentialDetails = @{
					credentialType = "Basic";
					credentials = "{`"credentialData`":[{`"name`":`"username`", `"value`":`"$($builder.UserID)`"},{`"name`":`"password`", `"value`":`"$($builder.Password)`"}]}";
					encryptedConnection = "Encrypted";
					encryptionAlgorithm = "None";
					privacyLevel = "None"
				}
			} | ConvertTo-Json

			$gatewayId = $candidate.gatewayId
			$datasourceId = $candidate.datasourceId

			$Url = Get-PowerBIUrl -Url "gateways/$gatewayId/datasources/$datasourceId"

			Invoke-PowerBI -Method Patch -Url $Url -Body $Body
		}
	}
}