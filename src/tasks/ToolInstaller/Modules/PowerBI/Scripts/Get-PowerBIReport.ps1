Function Get-PowerBIReport
{
	Param
	(
	    [Parameter(Mandatory = $false)][string]$Group,
		[Parameter(Mandatory = $true)][string]$Report,
		[Parameter(Mandatory = $false)][switch]$Id
	)

	try
	{
		$ReportGuid = [System.Guid]::Parse($Report)
		$ReportId = $ReportGuid.ToString("D")

		if ($Id)
		{
			return $ReportId
		}
		else
		{
			$Url = Get-PowerBIUrl -Group $Group -Url "reports/$ReportId"
			$Result = Invoke-PowerBI -Method Get -Url $Url

			return $Result
		}
	}
	catch
	{
		$Results = Get-PowerBIReports -Group $Group
		$Result = $Results | ? { $_.name -eq $Report }

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