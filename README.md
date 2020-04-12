# Power BI Build Tools for Azure DevOps


## Overview
Use Power BI Build Tools to automate common build and release tasks related to Power BI.

To find out more and get started, check out [this](./docs/GettingStarted.md) guide.

## Actions

| Action | Description
|--------|------------
| [Tool Installer](./docs/tasks/PowerBIToolInstaller.md) | Installs the required tools.
| [Create](./docs/tasks/PowerBICreate.md) | Creates a workspace.
| [Delete](./docs/tasks/PowerBIDelete.md) | Deletes a workspace, dataset, dataflow, or report.
| [Import](./docs/tasks/PowerBIImport.md) | Imports a file (.pbix, .rdl, etc.) into a workspace.
| [Export](./docs/tasks/PowerBIExport.md) | Exports a report to a file (.pbix, .pdf, etc.).
| [Data Refresh](./docs/tasks/PowerBIDataRefresh.md) | Triggers a refresh of a dataset or dataflow.
| [Data Refresh Schedule](./docs/tasks/PowerBIDataRefreshSchedule.md) | Updates the data refresh schedule of a dataset or dataflow.
| [Permissions](./docs/tasks/PowerBIPermissions.md) | Sets or refreshes permissions for a workspace.
| [Set Credentials](./docs/tasks/PowerBISetCredentials.md) | Sets data source credentials based on the supplied connection strings.


## FAQ

**Does this support all of the Power BI national/sovereign clouds?**

Yes, these build tools support GCC, GCC High, GCC DoD, China, and Germany.

  
**Can I import Paginated Report (.rdl) files?**

Yes, assuming you are using a dedicated capacity, you can import Paginated Report (.rdl) files.


**Can I set credentials on data sources for reports/datasets?**

Yes, you can either do this using either the `Import` task or the `Set Credentials` task.