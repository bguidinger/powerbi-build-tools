Function Set-PowerBIDataflowCredentials
{
	Param
	(
	    [Parameter(Mandatory = $true)][string]$Group,
		[Parameter(Mandatory = $true)][string]$Dataflow,
		[Parameter(Mandatory = $true)]$ConnectionStrings
	)

	$DataSources = Get-PowerBIDataflowDataSources -Group $Group -Dataflow $Dataflow

	Set-PowerBICredentials -DataSources $DataSources -ConnectionStrings $ConnectionStrings
}