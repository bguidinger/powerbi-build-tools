Function New-PowerBIExportTo
{
	Param
	(
	    [Parameter(Mandatory = $false)][string]$Group,
		[Parameter(Mandatory = $true)]$Report,
		[Parameter(Mandatory = $true)]$FileFormat,
		[Parameter(Mandatory = $true)]$Path
	)

	Write-Host "Exporting '$Report' to $FileFormat"

	$GroupId = Get-PowerBIGroup -Group $Group -Id
	$ReportId = Get-PowerBIReport -Group $GroupId -Report $Report -Id

	$Url = Get-PowerBIUrl -Group $GroupId -Url "reports/$ReportId/ExportTo"
	$Body = @{ format = $FileFormat } | ConvertTo-Json -Compress

	$Result = Invoke-PowerBI -Method Post -Url $Url -Body $Body

	$ExportId = $Result.id

	$Attempts = 1
	Do
	{
		$Export = Get-PowerBIExportTo -Group $GroupId -Report $ReportId -Export $ExportId
		If ($Export.status -eq 'Running')
		{
			Start-Sleep -Milliseconds (100 * $Attempts)
		}
		Else
		{
			Break
		}
	}
	While ($Attempts++ -le 10)
	
	Get-PowerBIExportToFile -Group $GroupId -Report $ReportId -Export $ExportId -Path "$Path/$Report.$($FileFormat.ToLower())"
}