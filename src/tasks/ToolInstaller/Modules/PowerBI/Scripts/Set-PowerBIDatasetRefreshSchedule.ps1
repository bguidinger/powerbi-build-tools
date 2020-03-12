Function Set-PowerBIDatasetRefreshSchedule
{
	Param
	(
	    [Parameter(Mandatory = $false)][string]$Group,
		[Parameter(Mandatory = $true)][string]$Dataset,
		[Parameter(Mandatory = $false)][string]$Enabled,
		[Parameter(Mandatory = $false)][string]$Days,
		[Parameter(Mandatory = $false)][string]$Times,
		[Parameter(Mandatory = $false)][string]$TimeZone,
		[Parameter(Mandatory = $false)][string]$NotifyOption
	)

	$GroupId = Get-PowerBIGroup -Group $Group -Id
	$DatasetId = Get-PowerBIDataset -Group $GroupId -Dataset $Dataset -Id

	$Url = Get-PowerBIUrl -Group $GroupId -Url "datasets/$DatasetId/refreshSchedule"

	$Body = @{ value = @{ } }

	# Enabled
	switch($Enabled)
	{
		"Enabled"
		{
			$Body.value.Add("enabled", $true)
		}
		"Disabled"
		{
			$Body.value.Add("enabled", $false)
		}
	}

	# Days
	if ($Days)
	{
		$Body.value.Add("days", ($Days | ConvertFrom-Json))
	}

	# Times
	if ($Times)
	{
		$Body.value.Add("times", ($Times | ConvertFrom-Json))
	}

	# Time Zone
	if ($TimeZone)
	{
		$Body.value.Add("localTimeZoneId", $TimeZone)
	}

	# Time Zone
	if ($NotifyOption)
	{
		$Body.value.Add("notifyOption", $NotifyOption)
	}

	Invoke-PowerBI -Method Patch -Url $Url -Body ($Body | ConvertTo-Json)
}