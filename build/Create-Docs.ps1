$docTemplate = @'
# Task: {0}

## Overview

{1}

## Schema

```
{2}
```

## Inputs

{3}
'@

$schemaTemplate = @'
- task: {0}@{1}
  displayName: {{string}}
  {2}
'@
$schemaInputsTemplate = @"
inputs:
{0}
"@

$inputsSchema = @'
| Name | Label | Required | Type | Description
|------|-------|----------|------|------------
{0}
'@

$tasks = Get-ChildItem ..\src\tasks\**\task.json

foreach($task in $tasks)
{
	$taskDef = (Get-Content $task) | ConvertFrom-Json
    
    $taskName = $taskName = $taskDef.name
    $taskFriendlyName = $taskDef.friendlyName
    $taskDesc = $taskDef.description
    $taskMajorVersion = $taskDef.version.Major
    
    if ($taskDef.inputs)
    {
        $taskDef.inputs[0].type = 'string'

        $inputYaml = $taskDef.inputs | % { "    $($_.aliases[0]): {$($_.type)}" }
        $inputTable = $taskDef.inputs | % { "| $($_.name) | $($_.label) | $($_.required) | $($_.type) | $($_.helpMarkDown)" }

        $schema = $schemaTemplate -f $taskName, $taskMajorVersion, ($schemaInputsTemplate -f ($inputYaml -join "`r`n"))
        $inputs = $inputsSchema -f ($inputTable -join "`r`n")
    }
    else
    {
        $schema = $schemaTemplate -f $taskName, $taskMajorVersion, ""
        $inputs = "None"
    }

    $markdown = $docTemplate -f $taskFriendlyName, $taskDesc, $schema, $inputs
    $markdown > "..\docs\tasks\$taskName.md"
}