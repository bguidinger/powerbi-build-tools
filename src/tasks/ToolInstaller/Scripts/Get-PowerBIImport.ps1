[CmdletBinding()]

param
(
    [Parameter(Mandatory = $true)][string]$ImportId,
    [Parameter(Mandatory = $false)][string]$GroupId
)

if ($GroupId)
{
    $results = Invoke-PowerBIRestMethod -Method Get -Url "groups/$GroupId/imports/$ImportId"
}
else
{
    $results = Invoke-PowerBIRestMethod -Method Get -Url "imports/$ImportId"
}

$import = $results | ConvertFrom-Json

return $import