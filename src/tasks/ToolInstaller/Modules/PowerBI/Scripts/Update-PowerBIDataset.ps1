Function Update-PowerBIDataset
{
	Param
	(
	    [Parameter(Mandatory = $false)][string]$Group,
		[Parameter(Mandatory = $true)][string]$Dataset,
		[Parameter(Mandatory = $false)][string]$NotifyOption = "NoNotification"
	)

	$GroupId = Get-PowerBIGroup -Group $Group -Id
	$DatasetId = Get-PowerBIDataset -Group $GroupId -Dataset $Dataset -Id

	$Url = Get-PowerBIUrl -Group $GroupId -Url "datasets/$DatasetId/refreshes"
	$Body = @{ notifyOption = $NotifyOption } | ConvertTo-Json

	Invoke-PowerBI -Method Post -Url $Url -Body $Body
}