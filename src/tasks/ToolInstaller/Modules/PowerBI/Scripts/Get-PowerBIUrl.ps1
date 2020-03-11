Function Get-PowerBIUrl
{
	Param
	(
	    [Parameter(Mandatory = $false)][string]$Group,
		[Parameter(Mandatory = $false)][string]$Url
	)

	if ($Group)
    {
		try
		{
		    $GroupGuid = [System.Guid]::Parse($Group)
			$GroupId = $groupGuid.ToString("D")
		}
		catch
		{
			$GroupId = Get-PowerBIGroup -Group $Group -Id
		}

		if ($Url)
		{
			return "groups/$GroupId/$Url"
		}
        else
		{
			return "groups/$GroupId"
		}
    }
    else
    {
        return "$Url"
    }
}