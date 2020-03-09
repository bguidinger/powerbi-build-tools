[CmdletBinding()]

param
(
    [Parameter(Mandatory = $true)][string]$Name,
    [Parameter(Mandatory = $false)][string]$GroupId
)

if ($GroupId)
{
    $results = Invoke-PowerBIRestMethod -Method Get -Url "groups/$GroupId/reports"
}
else
{
    $results = Invoke-PowerBIRestMethod -Method Get -Url "reports"
}

$results = ($results | ConvertFrom-Json).value
$report = $results | ? { $_.name -eq $Name}

return $report.id