Function Get-PowerBIGroup
{
	Param
	(
	    [Parameter(Mandatory = $false)][string]$Group,
		[Parameter(Mandatory = $false)][switch]$Id
	)

	if (-not $Group)
	{
		return
	}

	try
	{
		$GroupGuid = [System.Guid]::Parse($Group)
		$GroupId = $GroupGuid.ToString("D")

		if ($Id)
		{
			return $GroupId
		}
		else
		{
			$Url = "groups?`$filter=id eq '$GroupId'"
			$Result = Invoke-PowerBI -Method Get -Url $Url

			return $Result.value[0]
		}
	}
	catch
	{
		$Url = "groups?`$filter=name eq '$Group'"
		$Results = (Invoke-PowerBI -Method Get -Url $Url)
		$Result = $Results.value[0]
		
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