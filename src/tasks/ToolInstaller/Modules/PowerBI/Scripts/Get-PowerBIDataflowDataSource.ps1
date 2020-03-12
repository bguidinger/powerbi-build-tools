Function Get-PowerBIDataflowDataSource
{
	Param
	(
	    [Parameter(Mandatory = $true)][string]$Group,
		[Parameter(Mandatory = $true)][string]$Dataflow,
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
			$Results = Get-PowerBIDataflowDataSources -Group $Group -Dataflow $Dataflow
			$Result = $Results | ? { $_.datasourceId -eq $DatasourceId }
			
			return $Result
		}
	}
	catch
	{
		$Results = Get-PowerBIDataflowDataSources -Group $Group -Dataflow $Dataflow
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