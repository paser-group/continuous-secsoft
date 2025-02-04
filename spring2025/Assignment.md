# Assignment for COMP 7970

## Security Landscape of VS Code Extensions 

This assignment focuses on VS Code extensions and their security. As part of this assignment, you will perform three tasks described below.  

### Download repositories that contain VS Code extension code 

Download the top 500 installed VS Code extension repositories from here: https://marketplace.visualstudio.com/search?target=VSCode&category=All%20categories&sortBy=Installs 

You can do it manually or automatically by writing a script. Upload the downloaded repositories [here](https://tigermailauburn-my.sharepoint.com/:f:/g/personal/azr0154_auburn_edu/Eoj0d1VWoaNKuqFjsXG5BbkBQ5lFJohIj8rZE6BgGsGsaA?e=75bKx3) as a TAR or a ZIP file. The file name format should be: `EMAIL-VSCODE-DATA.tar.gz`. 

### Apply security static analysis tool 

For each repository apply a security static analysis testing tool that is applicable for the repository. For example, for a Go-based repository you have to apply a tool that works for Go. You need to find the appropriate tool and apply it. You will generate one comma separated value (CSV) file that contains all the results of all the 500 extensions. The CSV file is based on analysis results grouped by file name. The CSV file must look like this: 

| FILENAME  | CATEGORY  |  REPOPATH | COUNT   |
|---|---|---|---|
|   |   |   |   |
|   |   |   |   |
|   |   |   |   |

Name of the file should be `EMAIL-SAST-VSCODE.csv`


### Apply supply chain analysis tool 

For each repository apply the OpenSSF tool. You will generate one comma separated value (CSV) file that contains all the results of all the 500 extensions. The CSV file is based on analysis results grouped by file name. The CSV file must look like this:

| REPOPATH  | LASTUPDATED  | RATING  | ISSUES  |  DOWNLOADS |  NAME | SCORE |  REASON |
|---|---|---|---|---|---|---|---|
|   |   |   |   |   |   |   |   |
|   |   |   |   |   |   |   |   |
|   |   |   |   |   |   |   |   |

Name of the file should be `EMAIL-OPENSSF-VSCODE.csv`

### Deadline 

May 02, 2025 , 11:59 PM CST 

### Grade Distribution

| ITEM  | AMOUNT  |
|---|---|
|  `EMAIL-VSCODE-DATA.tar.gz` |  40% | 
|  `EMAIL-SAST-VSCODE.csv`    |  30% | 
|  `EMAIL-OPENSSF-VSCODE.csv` |  30% | 
