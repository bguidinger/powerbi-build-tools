# Task: Power BI Permissions

## Overview

Sets or refreshes permissions for a workspace.

## Schema

```
- task: PowerBIPermissions@1
  displayName: {string}
  inputs:
    connection: {string}
    action: {pickList}
    workspace: {string}
    principalType: {pickList}
    principal: {string}
    permission: {pickList}
```

## Inputs

| Name | Label | Required | Type | Description
|------|-------|----------|------|------------
| Connection | Power BI connection | True | string | The service connection to Power BI.
| Action | Action | True | pickList | <ul><li>Add</li><li>Refresh</li><li>Remove</li><li>Update</li></ul>
| Workspace | Workspace | True | string | The ID or name of the workspace.
| PrincipalType | Principal Type | True | pickList | <ul><li>App</li><li>Group</li><li>User</li></ul>
| Principal | Principal | True | string | The ID or email address of the principal.
| Permission | Permission | True | pickList | <ul><li>Admin</li><li>Contributor</li><li>Member</li><li>None</li></ul>
