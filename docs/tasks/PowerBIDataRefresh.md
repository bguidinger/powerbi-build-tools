# Task: Power BI Data Refresh

## Overview

Refresh a dataset or dataflow.

## Schema

```
- task: PowerBIDataRefresh@1
  displayName: {string}
  inputs:
    connection: {string}
    type: {pickList}
    workspace: {string}
    name: {string}
    notifyOption: {pickList}
```

## Inputs

| Name | Label | Required | Type | Description
|------|-------|----------|------|------------
| Connection | Power BI connection | True | string | The service connection to Power BI.
| Type | Type | True | pickList | <ul><li>Dataflow</li><li>Dataset</li></ul>
| Workspace | Workspace | False | string | The ID or name of the workspace. If not specified, your personal workspace will be used.
| Name | Name | True | string | The ID or name of the dataset or dataflow.
| NotifyOption | Notify Option | True | pickList | <ul><li>MailOnCompletion</li><li>MailOnFailure</li><li>NoNotification</li></ul>
