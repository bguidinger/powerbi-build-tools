# Power BI Build Tools for Azure DevOps


## Overview
Use Power BI Build Tools to automate common build and release tasks related to Power BI.


## Actions

| Action | Description
|--------|------------
| [Tool Installer](./docs/tasks/PowerBIToolInstaller.md) | Installs the tools.
| [Import](./docs/tasks/PowerBIImport.md) | Imports a file into a workspace.
| [Set Credentials](./docs/tasks/PowerBISetCredentials.md) | Sets data source credentials.
| [Dataset Delete](./docs/tasks/PowerBIDatasetDelete.md) | Deletes a dataset.
| [Dataset Refresh](./docs/tasks/PowerBIDatasetRefresh.md) | Refreshes a dataset.
| [Report Delete](./docs/tasks/PowerBIReportDelete.md) | Deletes a report.
| [Workspace Create](./docs/tasks/PowerBIWorkspaceCreate.md) | Creates a workspace.
| [Workspace Delete](./docs/tasks/PowerBIWorkspaceDelete.md) | Deletes a workspace.


## FAQ

**Does this support support all of the Power BI national/sovereign clouds?**

Yes, these build tools support GCC, GCC High, GCC DoD, China, and Germany.

  
**Can I import Paginated Report (.rdl) files?**

Yes, assuming you are using a dedicated capacity, you can import Paginated Report (.rdl) files.


**Can I set credentials on data sources for reports/datasets?**

Yes, you can either do this using either the `Import` task or the `Set Credentials` task.