[CmdletBinding()]

param
(
    [Parameter(Mandatory = $true)][string]$Name
)

try
{
    $guid = [System.Guid]::Parse($Name)
    $groupId = $guid.ToString("D")
}
catch
{
    $result = Invoke-PowerBIRestMethod -Method Get -Url "groups?`$filter=name eq '$($Name)'" | ConvertFrom-Json
    $groupId = $result.value[0].id
}

return $groupId