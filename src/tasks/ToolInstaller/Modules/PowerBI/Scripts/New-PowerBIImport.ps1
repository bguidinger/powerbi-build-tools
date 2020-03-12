Function New-PowerBIImport
{
	Param
	(
	    [Parameter(Mandatory = $false)][string]$Group,
		[Parameter(Mandatory = $true)]$File,
		[Parameter(Mandatory = $false)]$ConnectionStrings
	)

	Write-Host "Importing '$($File.Name)'"

	$FileName = [System.IO.Path]::GetFileName($File)
	$Extension = [System.IO.Path]::GetExtension($File)
	$ReportName = [System.IO.Path]::GetFileNameWithoutExtension($File)
		
	if ($Extension -eq '.rdl')
	{
		$xml = [Xml](Get-Content $File.FullName)

		$dataSources = $xml.Report.DataSources.ChildNodes
		foreach ($dataSource in $dataSources)
		{
			if ($connectionString = $ConnectionStrings.$($dataSource.Name)) {
				$dataSource.ConnectionProperties.ConnectString = $connectionString
			}
		}

		$ContentType = "application/rdl"
		$FileBody = $xml.InnerXml
	}
	else
	{
		$FileBytes = [System.IO.File]::ReadAllBytes($File.FullName)
		$Encoding = [System.Text.Encoding]::GetEncoding("ISO-8859-1")
			
		$ContentType = "application/octet-stream"
		$FileBody = $Encoding.GetString($FileBytes)
	}

	$GroupId = Get-PowerBIGroup -Group $Group -Id
	$ReportId = Get-PowerBIReport -Group $GroupId -Report $ReportName -Id
		
	if ($ReportId)
	{
		$NameConflict = "Overwrite"
	}
	else
	{
		$NameConflict = "Abort"
	}

	$Boundary = [System.Guid]::NewGuid().ToString()
	$BodyRaw = "--{0}`r`nContent-Disposition: form-data`r`nContent-Type: {1}`r`n`r`n{2}`r`n--{0}--`r`n"

	$Url = Get-PowerBIUrl -Group $GroupId "imports?datasetDisplayName=$FileName&nameConflict=$NameConflict"
	$Body = $BodyRaw -f $Boundary, $ContentType, $FileBody

	$Result = Invoke-PowerBI -Method Post -Url $Url -Body $Body -ContentType "multipart/form-data"
	$ImportId = $Result.id

	$Attempts = 1
	Do
	{
		$Import = Get-PowerBIImport -Group $GroupId -Import $ImportId
		If ($Import.importState -eq 'Publishing')
		{
			Start-Sleep -Milliseconds (100 * $Attempts)
		}
		Else
		{
			Break
		}
	}
	While ($Attempts++ -le 10)

	Return $Import
}