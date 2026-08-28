# Research Project 

## Background 

The tasks listed below are related to Visual Studio Code (VSCode) extensions. VSCode is a popular integrated development environment (IDE) used to write and test code and includes a marketplace where users can share and download community-made extensions for increased functionality and ease-of-use. These extensions are not rigorously checked before being made public, so they may contain intentional or unintentional vulnerabilities.

In this document, I have listed multiple tasks that you need to complete for this research project. I have already curated a set of VSCode extensions that are open source and developed in Typescript. All of your tasks will be related to generating test cases for these repositories. 

## Tasks  

### Task-1 (Familiarization with Typescript)

- If you are not already familiar with Typescript, please be familiar. 

### Task-2 (Familiarization with VS Code Extensions Developed in Typescript)

- Download this compressed [file](https://tigermailauburn-my.sharepoint.com/:u:/r/personal/azr0154_auburn_edu/Documents/RESEARCH/VS-CODE-REPOS/yzz0229-VSCODE-DATA.zip?csf=1&web=1&e=EhdtJI).
- Identify repositories that use Typescript, i.e., at least 5% of the files are Typescript-related. 
- List repositories that are executable. 
- Create a repository on GitHub. The repository must be publicly available.
- Add the names of the repository in a Markdown file and put it in the repository that you have created. Make sure you add `RUNNABLE.md` file in the repository that contains the names of all the repos.  

#### Deliverables: 

- Your repository URL. 
- A README file listing the repositories that you executed 

### Task-3 (Apply a Testing Tool To Find Generic Defects)

- Familiarize yourself with a tool called `[fast-check](https://fast-check.dev/)`
- Use the `fast-check` tool to perform testing with the repositories that you were able to execute as part of Task-3.
- While performing testing, target a function in each Typescript file for each repository from Task-1
- Generate a comma separated value (CSV) file with the following columns:

> FilePath,TestCaseName,FunctionName,Status,ExpectedValue,ProvidedValue,ErrorMessage,FailureCategory,InputParamater
> Here, 
```
  - FilePath the full file path in where the function of interest is located 
  - TestCaseName is the name of test case 
  - FunctionName is the name of the function 
  - Status is either `Passed` or `Failed`
  - ExpectedValue is the value that is expected to satisfy
  - ProvidedValue is the value that the function is expected provide 
  - ErrorMessage is the first line of the error message if `Status` is `Failed`
  - FailureCategory is the reason of why it failed  
  - InputParameter is the parameter of the function that is being tested. If one function has multiple parameters, then repeat the entries.
``` 
- Upload your code in the repository. Add a Markdown file that contains necessary instructions to use your code. 

#### Deliverables 
- Your program(s) that perform all above-mentioned tasks automatically 
- A 'requirements.txt' file describing the packages needed to run your program(s)
- A README file detailing how to use your programs 
- The CSV file you generated

### Task-4 (Apply a Testing Tool to Find Race Conditions)

- Read this [tutorial](https://fast-check.dev/docs/tutorials/detect-race-conditions/wrapping-up/)
- Develop a method to use this tutorial to find race condition vulnerabilities in the repositories you identified from Task-1
- Apply your methodology to identify race conditions in the repositories that you identified from Task-2
- Upload your code in the repository. Add a Markdown file that contains necessary instructions to use your code. 
- Generate a CSV file with the following headers: 

> FilePath,Found,Location,ObservedConsequence
> Here, 
```
  - FilePath the full file path in where the function of interest is located 
  - Found is either `Y` or `N`. If the tool found a vulnerability in the file, then 'Y', 'N' otherwise. 
  - Location is the line number in which the race condition vulnerability is found. 'NA' if there was no vulnerability found 
  - ObservedConsequence is the symptom or consequence you saw as a result of the vulnerability.  These could be things like hang or crashes. 'NA' if you did not find any race condition vulnerability. 
``` 
- Upload your code in the repository. Add a Markdown file that contains necessary instructions to use your code. 

#### Deliverables 
- Your program(s) that perform all above-mentioned tasks automatically 
- A 'requirements.txt' file describing the packages needed to run your program(s)
- A README file detailing how to use your programs 
- The CSV file you generated


### Rubric 

- Task-1: 1%
- Task-2: 20%
- Task-3: 39%
- Task-4: 40%