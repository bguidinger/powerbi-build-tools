[CmdletBinding()]

param
(
    [Parameter(Mandatory = $true)][string]$ReportId,
    [Parameter(Mandatory = $false)][string]$GroupId
)

if ($GroupId)
{
    $results = Invoke-PowerBIRestMethod -Method Get -Url "groups/$GroupId/reports/$ReportId/datasources"
}
else
{
    $results = Invoke-PowerBIRestMethod -Method Get -Url "reports/$ReportId/datasources"
}

$results = ($results | ConvertFrom-Json).value

return $results