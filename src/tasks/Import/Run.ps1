[CmdletBinding()]

param()

Trace-VstsEnteringInvocation $MyInvocation

try
{
	$toolsPath = Get-VstsTaskVariable -Name "PowerBI_Tools_Path"
	if (-not $toolsPath)
	{
		Write-VstsTaskError -Message "Please add the 'Power BI Tool Installer' before this task."
	}

	# Connect
	& "$toolsPath/Scripts/Connect-PowerBI.ps1"

	$groupId  = Get-VstsInput -Name WorkspaceId
	$path     = Get-VstsInput -Name Path
	$conflict = Get-VstsInput -Name Conflict

	$files = Get-ChildItem -Path $path

	foreach ($file in $files)
	{
		$boundary = [System.Guid]::NewGuid().ToString()
		$fileName = [System.IO.Path]::GetFileName($file)
		$fileBody = [System.IO.File]::ReadAlltext($file)

		$bodyRaw = "--{0}`r`nContent-Disposition: form-data`r`nContent-Type: application/xml`r`n`r`n{1}`r`n--{0}--`r`n"
		$body = $bodyRaw -f $boundary, $fileBody

		if ($groupId)
		{
			$url = "groups/$($env:GroupId)/imports?datasetDisplayName=$fileName&nameConflict=Overwrite"
		}
		else
		{
			$url = "imports?datasetDisplayName=$fileName&nameConflict=Overwrite"
		}

		Invoke-PowerBIRestMethod -Method Post -Url $url -Body $body -ContentType "multipart/form-data"
	}
}
finally
{
    Trace-VstsLeavingInvocation $MyInvocation
}