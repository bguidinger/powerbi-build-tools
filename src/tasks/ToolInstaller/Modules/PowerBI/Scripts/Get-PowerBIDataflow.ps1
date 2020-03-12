Function Get-PowerBIDataflow
{
	Param
	(
	    [Parameter(Mandatory = $true)][string]$Group,
		[Parameter(Mandatory = $true)][string]$Dataflow,
		[Parameter(Mandatory = $false)][switch]$Id
	)

	try
	{
		$DataflowGuid = [System.Guid]::Parse($Dataflow)
		$DataflowId = $DataflowGuid.ToString("D")

		if ($Id)
		{
			return $DataflowId
		}
		else
		{
			$Url = Get-PowerBIUrl -Group $Group -Url "dataflows/$DataflowId"
			$Result = Invoke-PowerBI -Method Get -Url $Url

			return $Result
		}
	}
	catch
	{
		$Results = Get-PowerBIDataflows -Group $Group
		$Result = $Results | ? { $_.name -eq $Dataflow }

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