## Introduction 

Security requirements documents change constantly. The security tools that we develop need to keep up with these changes. As part of this class project you will be designing and developing a functional software that can automatically detects changes in two security requirements documents and execute a static analysis tool accordingly. The project will involve application of multiple techniques that we discussed and practiced in class. 

## Tasks 

You will need to complete the following tasks. Each tasks needs a set of inputs and expected deliverables as shown below. 

### Task-1: Extractor 


##### Tasks 

- Create a function that automatically takes the two documents below as input and applies adequate input validation measures. 
- Create a function that constructs a zero shot prompt to identify key data elements in the two input documents. Output of this function will be a string. 
- Create a function that constructs a few shot prompt to identify key data elements in the two input documents. Output of this function will be a string. 
- Create a function that constructs a chain of thought prompt to identify key data elements in the two input documents. Output of this function will be a string.
- Create a function that uses each of the constructed prompts to identify key data elements in the two input documents. Your function must use the [GPT-OSS-SAFEGUARD-120B](https://huggingface.co/openai/gpt-oss-safeguard-120b) large language model (LLM) or the [GPT-OSS-SAFEGUARD-20B](https://huggingface.co/openai/gpt-oss-safeguard-20b) LLM. As output, the function will generate a nested dictionary will the following fields: 

```
- element1:
  - name:
  - type:
  - requirements: 
    - req1
    - req2 
    - req3 
```

##### Input 

- Two documents: [NIST-800-53-V5](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r5.pdf) and [NIST-800-53-V4](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r4.pdf) 

##### Expected Deliverables 

- All prompts in a Markdown file called `PROMPT.md`. The file must have three sections: `zero-shot`, `few-shot`, and `chain-of-thought`. Each of these section will include the prompts that you used. So, for `zero-shot`, `few-shot`, and `chain-of-thought` respectively, you will provide the zero shot, few shot, and chain of thought prompts that you used. 
- Two YAML files as output for the two documents 
- Source code for the five functions 
- Test cases for the five functions. One test case for each of the five functions 


### Task-2: Comparator 


##### Tasks 

- Create a function that automatically takes the two YAML files as input from the Task-1. 
- Create a function that identifies differences in the two YAML files with respect to names of key data elements. Output of the function will be a TEXT file with the names of the elements that are different across the two YAML files as input. If there are no differences, then report 'NO DIFFERENCES IN REGARDS TO ELEMENT NAMES' in a TEXT file.   
- Create a function that identifies differences in the two YAML files with respect to names of key data types. Output of the function will be a TEXT file with the names of the elements that are different across the two YAML files as input along with their types. The output should be dumped as a tuple, i.e., `TYPE,NAME`. If there are no differences, then report 'NO DIFFERENCES IN REGARDS TO ELEMENT TYPES' in a TEXT file.   
- Create a function that identifies differences in the two YAML files with respect to names of key data requirements. Output of the function will be a TEXT file with the names of the elements that are different across the two YAML files as input along with their requirements. The output should be dumped as a tuple, i.e., `TYPE,REQU`. If there are no differences, then report 'NO DIFFERENCES IN REGARDS TO ELEMENT REQUIREMENTS' in a TEXT file.   


##### Input 

- Two YAML files created in Task-1 

##### Expected Deliverables 

- Three TEXT files as output
- Source code for the four functions 
- Test cases for the four functions. One test case for each of the four functions 

### Task-3: Executor 


##### Tasks 

- Create a function that automatically takes the three TEXT files as input from Task-2
- Create a function that automatically determines if the three TEXT files showcase a difference in data elements and their requirements. If there is at least one difference, then the output of the function is going to be the [controls](https://kubescape.io/docs/controls/) available as part of [Kubescape](https://github.com/kubescape/kubescape/blob/master/docs/getting-started.md#usage) that map to these differences. If there are no differences, then just report 'NO DIFFERENCES FOUND' in a TEXT file. The output is going to be a TEXT file with two possible content: 
    - `NO DIFFERENCES FOUND` or 
    - the [controls](https://kubescape.io/docs/controls/) of Kubescape that map to the identified differences. 
- Create a function that executes the Kubescape tool from the command line on `project-yamls.zip` based on the content of the TEXT file. If the TEXT file only contains `NO DIFFERENCES FOUND` then run the Kubescape tool with all controls available. Otherwise, run the tool only on the controls that are in the TEXT file. The output of this function will be a [pandas dataframe](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.html) object with the scan results from the tool. 
- Create a function that generates a comma separated value (CSV) file with the following headers:
`FilePath`, `Severity`, `Control name`, `Failed resources`, `All Resources`, `Compliance score`. The output of the function will be a CSV file with these five headers. The data for these fields will come from the function you created above. 


##### Input 

- Three TEXT files created in Task-2
- The [Kubescape](https://github.com/kubescape/kubescape/blob/master/docs/getting-started.md#usage) tool

##### Expected Deliverables 

- A CSV file 
- Source code for the four functions 
- Test cases for the four functions. One test case for each of the four functions 


### Task-4: Repository Organization 


##### Tasks 

- Create a `requirements.txt` file with all the libraries with versions that you used to complete Task-1, 2, and 3. 
- Create a README with your team members' names, BannerIDs, and university email IDs. In the README, report the LLM name that you are using for Task-1.  
- Create a GitHub Action workflow so that every time a user, i.e., a contributor or someone who has forked your repository types `git status`, all test cases created in Task-1, Task-2, and Task-3 are executed automatically. All test cases must pass.  
- Create a binary so that the TA can run your project automatically using a Python-based virtual environment. As input the TA will provide three inputs each of which includes two PDF files:
  - Input-1: r5.pdf and r4.pdf
  - Input-2: r4.pdf and r4.pdf
  - Input-3: r5.pdf and r5.pdf

Please create the binary using [PyInstaller](https://pyinstaller.org/en/stable/). 

##### Input 

- Your test cases created in Task-1, 2, and 3
- Your source code from Task-1, 2, and 3

##### Expected Deliverables 

- A public repository on github.com
- A GitHub Action file with logs of test case execution 
- A binary that can be executed in a Python virtual environment
- A `requirements.txt` file


## Deadline 

- April 24, 2026, 11:59 PM CST
- Submission Form: https://forms.office.com/r/fMQeqiUbK3 

## Rubric 

- `Task-1`: 40%
- `Task-2`: 30%
- `Task-3`: 20%
- `Task-4`: 10%


