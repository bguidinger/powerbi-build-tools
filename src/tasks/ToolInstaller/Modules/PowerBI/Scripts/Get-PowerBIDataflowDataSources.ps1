Function Get-PowerBIDataflowDataSources
{
	Param
	(
	    [Parameter(Mandatory = $true)][string]$Group,
		[Parameter(Mandatory = $true)][string]$Dataflow
	)

	$GroupId = Get-PowerBIGroup -Group $Group -Id
	$DataflowId = Get-PowerBIDataflow -Group $GroupId -Dataflow $Dataflow -Id

	$Url = Get-PowerBIUrl -Group $GroupId -Url "dataflows/$DataflowId/datasources"
	$Results = Invoke-PowerBI -Method Get -Url $Url

	return $Results.value
}