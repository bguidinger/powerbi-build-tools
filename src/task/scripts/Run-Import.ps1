[CmdletBinding()]

param()

Trace-VstsEnteringInvocation $MyInvocation

Try
{
	$groupId  = Get-VstsInput -Name WorkspaceId
	$path     = Get-VstsInput -Name Path
	$conflict = Get-VstsInput -Name Conflict

	$files = Get-ChildItem -Path $path

	foreach ($file in $files) {
		$fileName = [System.IO.Path]::GetFileName($file)

		$xml = [Xml](Get-Content $file)
	
		# 4. Update data sources.
		$dataSources = $xml.Report.DataSources.ChildNodes

		foreach ($dataSource in $dataSources) {
			$connectionString = Get-Variable -Name "env:$($dataSource.Name)" -ValueOnly

			if ($connectionString) {
				$dataSource.ConnectionProperties.ConnectString = $connectionString
			}
		}

		# 5 . Upload report to Power BI
		$boundary = [System.Guid]::NewGuid().ToString()

		$bodyRaw = "--{0}`r`nContent-Disposition: form-data`r`nContent-Type: application/rdl`r`n`r`n{1}`r`n--{0}--`r`n"
		$body = $bodyRaw -f $boundary, $xml.InnerXml

		If ($groupId)
		{
			$url = "groups/$($env:GroupId)/imports?datasetDisplayName=$fileName&nameConflict=Overwrite"
		}
		Else
		{
			$url = "imports?datasetDisplayName=$fileName&nameConflict=Overwrite"
		}

		Invoke-PowerBIRestMethod -Method Post -Url $url -Body $body -ContentType "multipart/form-data"
	}
}
Finally
{
	Resolve-PowerBIError -Last
    Trace-VstsLeavingInvocation $MyInvocation
}