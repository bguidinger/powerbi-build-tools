Function New-PowerBIExport
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

	$Url = Get-PowerBIUrl -Group $GroupId -Url "reports/$ReportId/Export"

	Invoke-PowerBI -Method Get -Url $Url -OutFile "$Path/$Report.$($FileFormat.ToLower())"
}