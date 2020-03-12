Function Update-PowerBIDataflow
{
	Param
	(
	    [Parameter(Mandatory = $true)][string]$Group,
		[Parameter(Mandatory = $true)][string]$Dataflow,
		[Parameter(Mandatory = $false)][string]$NotifyOption = "NoNotification"
	)

	$GroupId = Get-PowerBIGroup -Group $Group -Id
	$DataflowId = Get-PowerBIDataflow -Group $GroupId -Dataflow $Dataflow -Id

	$Url = Get-PowerBIUrl -Group $GroupId -Url "dataflows/$DataflowId/refreshes"
	$Body = @{ notifyOption = $NotifyOption } | ConvertTo-Json

	Invoke-PowerBI -Method Post -Url $Url -Body $Body
}