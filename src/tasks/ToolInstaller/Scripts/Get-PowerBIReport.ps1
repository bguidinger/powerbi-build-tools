[CmdletBinding()]

param
(
    [Parameter(Mandatory = $true)][string]$Name,
    [Parameter(Mandatory = $false)][string]$GroupId
)

try
{
    $guid = [System.Guid]::Parse($Name)
    $reportId = $guid.ToString("D")
}
catch
{
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

    $reportId = $report.id
}

return $reportId