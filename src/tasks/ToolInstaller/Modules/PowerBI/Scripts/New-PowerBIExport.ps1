Function New-PowerBIExport
{
	Param
	(
	    [Parameter(Mandatory = $false)][string]$Group,
		[Parameter(Mandatory = $true)]$Report,
		[Parameter(Mandatory = $true)]$FileFormat,
		[Parameter(Mandatory = $false)]$Parameters
	)

	Write-Host "Exporting '$Report' to $FileFormat"

	$GroupId = Get-PowerBIGroup -Group $Group -Id
	$ReportId = Get-PowerBIReport -Group $GroupId -Report $Report -Id

	
	$Body = @{
		format = $FileFormat,
		paginatedReportExportConfiguration = @{
			parameterValues = @{}
		}
	}

	if ($Parameters)
	{
		$Params = $Parameters | ConvertFrom-Json
		$Params | Get-Member -MemberType Properties | % { $Body.paginatedReportExportConfiguration.parameterValues[$_.Name] = $Params.$($_.Name) }
	}
	$Body | ConvertTo-Json
	$Url = Get-PowerBIUrl -Group $GroupId -Url "reports/$ReportId/ExportTo"

	Invoke-PowerBI -Method Post -Url $Url -Body ($Body | ConvertTo-Json)
}