Function Set-PowerBIReportCredentials
{
	Param
	(
	    [Parameter(Mandatory = $false)][string]$Group,
		[Parameter(Mandatory = $true)][string]$Report,
		[Parameter(Mandatory = $true)]$ConnectionStrings
	)

	$DataSources = Get-PowerBIReportDataSources -Group $GroupId -Report $Report

	Set-PowerBICredentials -DataSources $DataSources -ConnectionStrings $ConnectionStrings
}