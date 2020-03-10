[CmdletBinding()]

param
(
    [Parameter(Mandatory = $true)][string]$Name,
    [Parameter(Mandatory = $false)][string]$GroupId
)

try
{
    $guid = [System.Guid]::Parse($Name)
    $datasetId = $guid.ToString("D")
}
catch
{
    if ($GroupId)
    {
        $results = Invoke-PowerBIRestMethod -Method Get -Url "groups/$GroupId/datasets"
    }
    else
    {
        $results = Invoke-PowerBIRestMethod -Method Get -Url "datasets"
    }

    $results = ($results | ConvertFrom-Json).value
    $dataset = $results | ? { $_.name -eq $Name}

    $datasetId = $dataset.id
}

return $datasetId