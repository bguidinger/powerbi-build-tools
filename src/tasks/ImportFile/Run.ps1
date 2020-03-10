[CmdletBinding()]

param()

Trace-VstsEnteringInvocation $MyInvocation

try
{
	$toolsPath = Get-VstsTaskVariable -Name "PowerBI_Tools_Path"
	if (-not $toolsPath)
	{
		Write-VstsTaskError -Message "Please add the 'Power BI Tool Installer' before this task."
	}

	# Connect
	Invoke-Expression "$toolsPath/Scripts/Connect-PowerBI.ps1"

	$group       = Get-VstsInput -Name Group
	$path        = Get-VstsInput -Name Path
	$connections = Get-VstsInput -Name ConnectionStrings | ConvertFrom-Json -ErrorAction SilentlyContinue

	$files = Get-ChildItem -Path $path

	foreach ($file in $files)
	{
		$boundary   = [System.Guid]::NewGuid().ToString()
		$fileName   = [System.IO.Path]::GetFileName($file)
		$extension  = [System.IO.Path]::GetExtension($file)
		$reportName = [System.IO.Path]::GetFileNameWithoutExtension($file)
		
		if ($extension -eq '.rdl')
		{
			$contentType = "application/rdl"
			$xml         = [Xml](Get-Content $file.FullName)

			$dataSources = $xml.Report.DataSources.ChildNodes

			foreach ($dataSource in $dataSources)
			{
				if ($connectionString = $connections.$($dataSource.Name)) {
					$dataSource.ConnectionProperties.ConnectString = $connectionString
				}
			}

			$fileBody = $xml.InnerXml
		}
		else
		{
			$contentType = "application/octet-stream"
			$fileBytes   = [System.IO.File]::ReadAllBytes($file.FullName)
			$encoding    = [System.Text.Encoding]::GetEncoding("ISO-8859-1")
			$fileBody    = $encoding.GetString($fileBytes)
		}

		$bodyRaw = "--{0}`r`nContent-Disposition: form-data`r`nContent-Type: {1}`r`n`r`n{2}`r`n--{0}--`r`n"
		$body = $bodyRaw -f $boundary, $contentType, $fileBody

		$groupId  = Invoke-Expression "$toolsPath/Scripts/Get-PowerBIGroup.ps1 -Name '$group'"
		$reportId = Invoke-Expression "$toolsPath/Scripts/Get-PowerBIReport.ps1 -Name '$reportName' -GroupId '$groupId'"
		
		if ($reportId)
		{
			$nameConflict = "Overwrite"
		}
		else
		{
			$nameConflict = "Abort"
		}

		if ($groupId)
		{
			$url = "groups/$groupId/imports?datasetDisplayName=$fileName&nameConflict=$nameConflict"
		}
		else
		{
			$url = "imports?datasetDisplayName=$fileName&nameConflict=$nameConflict"
		}

		Write-Host $url

		try
		{
			$importId = (Invoke-PowerBIRestMethod -Method Post -Url $url -Body $body -ContentType "multipart/form-data" | ConvertFrom-Json).id
		}
		catch
		{
			Resolve-PowerBIError -Last
			throw
		}


		# Update report data source credentials
		if ($extension -eq '.rdl')
		{
			# Sleeping because the API doesn't track the import right away
			Start-Sleep -Milliseconds 500

			$import = Invoke-Expression "$toolsPath/Scripts/Get-PowerBIImport.ps1 -ImportId '$importId' -GroupId '$groupId'"
			$reportId = $import.reports.id
			$reportDataSources = Invoke-Expression "$toolsPath/Scripts/Get-PowerBIReportDataSources.ps1 -ReportId '$reportId' -GroupId '$groupId'"

			# Set Credentials
			foreach ($dataSource in $dataSources)
			{
				if ($connectionString = $connections.$($dataSource.Name))
				{
					$dataProvider = $dataSource.ConnectionProperties.DataProvider
					if ($dataProvider -eq "SQLAZURE")
					{
						$builder = New-Object System.Data.SqlClient.SqlConnectionStringBuilder($connectionString)

						$candidates = $reportDataSources | ? {$_.connectionDetails.server -eq $builder.DataSource -and $_.connectionDetails.database -eq $builder.InitialCatalog}
						foreach ($candidate in $candidates)
						{
							$body = @{
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

							$url = "gateways/$gatewayId/datasources/$datasourceId"
							$url
							Invoke-PowerBIRestMethod -Method Patch -Url $url -Body $body
						}
					}
				}
			}
		}
	}
}
finally
{
	Trace-VstsLeavingInvocation $MyInvocation
}