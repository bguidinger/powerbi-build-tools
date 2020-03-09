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

	$groupName   = Get-VstsInput -Name WorkspaceName
	$path        = Get-VstsInput -Name Path
	$conflict    = Get-VstsInput -Name Conflict
	$connections = Get-VstsInput -Name ConnectionStrings | ConvertFrom-Json -ErrorAction SilentlyContinue

	$files = Get-ChildItem -Path $path

	foreach ($file in $files)
	{
		$boundary  = [System.Guid]::NewGuid().ToString()
		$fileName  = [System.IO.Path]::GetFileName($file)
		$extension = [System.IO.Path]::GetExtension($file)
		
		if ($extension -eq '.rdl')
		{
			$contentType = "application/rdl"
			$fileBody    = [Xml](Get-Content $file.FullName)

			$dataSources = $xml.Report.DataSources.ChildNodes

			foreach ($dataSource in $dataSources)
			{
				$connectionString = $connections[$dataSource.Name]

				if ($connectionString) {
					$dataSource.ConnectionProperties.ConnectString = $connectionString
				}
			}
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

		$fileName = [System.Net.WebUtility]::UrlEncode($fileName)

		$groupId = Invoke-Expression "$toolsPath/Scripts/Get-PowerBIWorkspace.ps1 -Name '$groupName'"

		if ($groupId)
		{
			$url = "groups/$groupId/imports?datasetDisplayName=$fileName&nameConflict=$conflict"
		}
		else
		{
			$url = "imports?datasetDisplayName=$fileName&nameConflict=$conflict"
		}

		Write-Host $url

		try
		{
			Invoke-PowerBIRestMethod -Method Post -Url $url -Body $body -ContentType "multipart/form-data"
		}
		catch
		{
			Resolve-PowerBIError -Last
			throw
		}
	}
}
finally
{
	Trace-VstsLeavingInvocation $MyInvocation
}