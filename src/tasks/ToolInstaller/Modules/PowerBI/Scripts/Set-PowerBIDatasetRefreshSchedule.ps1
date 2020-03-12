Function Set-PowerBIDatasetRefreshSchedule
{
	Param
	(
	    [Parameter(Mandatory = $false)][string]$Group,
		[Parameter(Mandatory = $true)][string]$Dataset,
		[Parameter(Mandatory = $true)][bool]$Enabled,

	)

	$GroupId = Get-PowerBIGroup -Group $Group -Id
	$DatasetId = Get-PowerBIDataset -Group $GroupId -Dataset $Dataset -Id

	$Url = Get-PowerBIUrl -Group $GroupId -Url "datasets/$DatasetId/refreshSchedule"

	$Body = @{
		value = @{
			enabled = $Enabled
		}
	} | ConvertTo-Json

	Invoke-PowerBI -Method Patch -Url $Url -Body $Body
}