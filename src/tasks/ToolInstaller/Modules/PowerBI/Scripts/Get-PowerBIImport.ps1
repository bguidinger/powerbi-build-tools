Function Get-PowerBIImport
{
	Param
	(
	    [Parameter(Mandatory = $false)][string]$Group,
		[Parameter(Mandatory = $true)][string]$Import,
		[Parameter(Mandatory = $false)][switch]$Id
	)

	try
	{
		$ImportGuid = [System.Guid]::Parse($Import)
		$ImportId = $ImportGuid.ToString("D")

		if ($Id)
		{
			return $ImportId
		}
		else
		{
			$Url = Get-PowerBIUrl -Group $Group -Url "imports/$ImportId"
			$Result = Invoke-PowerBI -Method Get -Url $Url

			return $Result
		}
	}
	catch
	{
		$Results = Get-PowerBIImports -Group $Group
		$Result = $Results | ? { $_.name -eq $Import }

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