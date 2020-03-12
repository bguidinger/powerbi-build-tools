Function Set-PowerBIDataflowRefreshSchedule
{
	Param
	(
	    [Parameter(Mandatory = $true)][string]$Group,
		[Parameter(Mandatory = $true)][string]$Dataflow,
		[Parameter(Mandatory = $true)][bool]$Enabled,

	)

	$GroupId = Get-PowerBIGroup -Group $Group -Id
	$DataflowId = Get-PowerBIDataflow -Group $GroupId -Dataflow $Dataflow -Id

	$Url = Get-PowerBIUrl -Group $GroupId -Url "dataflows/$DataflowId/refreshSchedule"

	$Body = @{
		value = @{
			enabled = $Enabled
		}
	} | ConvertTo-Json

	Invoke-PowerBI -Method Patch -Url $Url -Body $Body
}