Function Get-PowerBIDataset
{
	Param
	(
	    [Parameter(Mandatory = $false)][string]$Group,
		[Parameter(Mandatory = $true)][string]$Dataset,
		[Parameter(Mandatory = $false)][switch]$Id
	)

	try
	{
		$DatasetGuid = [System.Guid]::Parse($Dataset)
		$DatasetId = $DatasetGuid.ToString("D")

		if ($Id)
		{
			return $DatasetId
		}
		else
		{
			$Url = Get-PowerBIUrl -Group $Group -Url "datasets/$DatasetId"
			$Result = Invoke-PowerBI -Method Get -Url $Url

			return $Result
		}
	}
	catch
	{
		$Results = Get-PowerBIDatasets -Group $Group
		$Result = $Results | ? { $_.name -eq $Dataset }

		if ($Id)
		{
			return $Result.id
		}
		else
		{
			return $Result
		}
	}
}