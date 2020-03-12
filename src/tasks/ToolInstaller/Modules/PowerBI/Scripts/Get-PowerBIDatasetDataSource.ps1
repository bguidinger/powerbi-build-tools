Function Get-PowerBIDatasetDataSource
{
	Param
	(
	    [Parameter(Mandatory = $false)][string]$Group,
		[Parameter(Mandatory = $true)][string]$Dataset,
		[Parameter(Mandatory = $true)][string]$Datasource
	)

	try
	{
		$DatasourceGuid = [System.Guid]::Parse($Datasource)
		$DatasourceId = $DatasourceGuid.ToString("D")

		if ($Id)
		{
			return $DatasourceId
		}
		else
		{
			$Results = Get-PowerBIDatasetDataSources -Group $Group -Dataset $Dataset
			$Result = $Results | ? { $_.datasourceId -eq $DatasourceId }
			
			return $Result
		}
	}
	catch
	{
		$Results = Get-PowerBIDatasetDataSources -Group $Group -Dataset $Dataset
		$Result = $Results | ? { $_.datasourceName -eq $Datasource }

		if ($Id)
		{
			return $Result.datasourceId
		}
		else
		{
			return $Result
		}
	}
}