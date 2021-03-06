# Task: Power BI Create

## Overview

Creates a workspace.

## Schema

```
- task: PowerBICreate@1
  displayName: {string}
  inputs:
    connection: {string}
    type: {pickList}
    name: {string}
```

## Inputs

| Name | Label | Required | Type | Description
|------|-------|----------|------|------------
| Connection | Power BI connection | True | string | The service connection to Power BI.
| Type | Type | True | pickList | <ul><li>Workspace</li></ul>
| Name | Name | True | string | The name of the workspace to create.
