Function Set-PowerBIDatasetCredentials
{
	Param
	(
	    [Parameter(Mandatory = $false)][string]$Group,
		[Parameter(Mandatory = $true)][string]$Dataset,
		[Parameter(Mandatory = $true)]$ConnectionStrings
	)

	$DataSources = Get-PowerBIDatasetDataSources -Group $GroupId -Dataset $Dataset

	Set-PowerBICredentials -DataSources $DataSources -ConnectionStrings $ConnectionStrings
}