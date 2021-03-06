# Task: Power BI Import

## Overview

Import a file or folder.

## Schema

```
- task: PowerBIImport@1
  displayName: {string}
  inputs:
    connection: {string}
    workspace: {string}
    path: {filePath}
    connectionStrings: {multiLine}
```

## Inputs

| Name | Label | Required | Type | Description
|------|-------|----------|------|------------
| Connection | Power BI connection | True | string | The service connection to Power BI.
| Workspace | Workspace | False | string | The ID or name of the workspace. If not specified, your personal workspace will be used.
| Path | Path | True | filePath | The path to the file or folder to import.
| ConnectionStrings | Connection Strings | False | multiLine | Connection strings in JSON format. The keys are the names of the data sources.  The values are the connection strings.
