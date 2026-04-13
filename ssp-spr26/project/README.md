## Introduction 

Security requirements documents change constantly. The security tools that we develop need to keep up with these changes. As part of this class project you will be designing and developing a functional software that can automatically detects changes in two security requirements documents and execute a static analysis tool accordingly. The project will involve application of multiple techniques that we discussed and practiced in class. This is a group project, where each group will include at most three students. 

## Tasks 

You will need to complete the following tasks. Each tasks needs a set of inputs and expected deliverables as shown below. 

### Task-1: Extractor 


##### Tasks 

- Create a function that automatically takes the two documents below as input and applies adequate input validation measures. Here, you want to make sure that you can open the documents and load all the text in the document in some data structure. 
- Create a function that constructs a `zero shot prompt` to identify key data elements in the two input documents. Output of this function will be a string. 
- Create a function that constructs a `few shot prompt` to identify key data elements in the two input documents. Output of this function will be a string. 
- Create a function that constructs a `chain of thought prompt` to identify key data elements in the two input documents. Output of this function will be a string.
- Create a function that uses each of the constructed prompts to identify key data elements (KDEs) in the two input documents. Your function must use the [Gemma-3-1B](https://huggingface.co/google/gemma-3-1b-it) LLM. One KDE can map to multiple requirements. As output, the function will generate a nested dictionary will the following fields: 

```
- element1:
  - name:
  - requirements: 
    - req1
    - req2 
    - req3 
```

Save the generated output in a YAML file. For the two requirements documents you must generate two separate YAML files. Make sure the file names of the two YAML files include the names of the two input documents. For example, sth. like `cis-r1-kdes.yaml`. 

- Create a function that automatically collects the output all LLMs and dumps the output in a TEXT file. The file needs to be formatted as follows:

```
*LLM Name* 
...
*Prompt Used*
...
*Prompt Type*
...
*LLM Output*
...
```

##### Input 

Nine input combinations:

  - Input-1: cis-r1.pdf and cis-r1.pdf
  - Input-2: cis-r1.pdf and cis-r2.pdf
  - Input-3: cis-r1.pdf and cis-r3.pdf
  - Input-4: cis-r1.pdf and cis-r4.pdf
  - Input-5: cis-r2.pdf and cis-r2.pdf
  - Input-6: cis-r2.pdf and cis-r3.pdf  
  - Input-7: cis-r2.pdf and cis-r4.pdf  
  - Input-8: cis-r3.pdf and cis-r3.pdf  
  - Input-9: cis-r3.pdf and cis-r4.pdf    


##### Expected Deliverables 

- All prompts in a Markdown file called `PROMPT.md`. The file must have three sections: `zero-shot`, `few-shot`, and `chain-of-thought`. Each of these section will include the prompts that you used. So, for `zero-shot`, `few-shot`, and `chain-of-thought` respectively, you will provide the zero shot, few shot, and chain of thought prompts that you used. 
- Two YAML files as output for the two documents 
- Source code for the six functions 
- Test cases for the six functions. One test case for each of the six functions 


### Task-2: Comparator 


##### Tasks 

- Create a function that automatically takes the two YAML files as input from the Task-1. 
- Create a function that identifies differences in the two YAML files with respect to names of key data elements. Output of the function will be a TEXT file with the names of the elements that are different across the two YAML files as input. If there are no differences, then report 'NO DIFFERENCES IN REGARDS TO ELEMENT NAMES' in a TEXT file.   
- Create a function that identifies differences in the two YAML files with respect to (i) names of key data elements; and (ii) requirements for the key data elements. Output of the function will be a TEXT file with the names of the elements that are different across the two YAML files as input along with their requirements. The output should be dumped as a tuple as follows:

```
NAME,ABSENT-IN-<FILENAME>,PRESENT-IN-<FILENAME>,NA  # a KDE is present  in one file but absent in another 
NAME,ABSENT-IN-<FILENAME>,PRESENT-IN-<FILENAME>,REQ1 # a KDE is present  in both files but one requirement called REQ1 is present in one file but absent in another  
```


If there are no differences, then report 'NO DIFFERENCES IN REGARDS TO ELEMENT REQUIREMENTS' in a TEXT file.   


##### Input 

- Two YAML files created in Task-1 

##### Expected Deliverables 

- Two TEXT files as output
- Source code for the three functions 
- Test cases for the three functions. One test case for each of the three functions. 

### Task-3: Executor 


##### Tasks 

- Create a function that automatically takes the three TEXT files as input from Task-2
- Create a function that automatically determines if the two TEXT files showcase a difference in data elements and their requirements. If there is at least one difference, then the output of the function is going to be the [controls](https://kubescape.io/docs/controls/) available as part of [Kubescape](https://github.com/kubescape/kubescape/blob/master/docs/getting-started.md#usage) that map to these differences. If there are no differences, then just report 'NO DIFFERENCES FOUND' in a TEXT file. The output is going to be a TEXT file with two possible content: 
    - `NO DIFFERENCES FOUND` or 
    - the [controls](https://kubescape.io/docs/controls/) of Kubescape that map to the identified differences. You can do this mapping manually or using an automated approach, such as an LLM or pattern matching.  
- Create a function that executes the Kubescape tool from the command line on `project-yamls.zip` based on the content of the TEXT file. If the TEXT file only contains `NO DIFFERENCES FOUND` then run the Kubescape tool with all controls available. Otherwise, run the tool only on the controls that are in the TEXT file. The output of this function will be a [pandas dataframe](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.html) object with the scan results from the tool. 
- Create a function that generates a comma separated value (CSV) file with the following headers:
`FilePath`, `Severity`, `Control name`, `Failed resources`, `All Resources`, `Compliance score`. The output of the function will be a CSV file with these five headers. The data for these fields will come from the function you created above. 


##### Input 

- Two TEXT files created in Task-2
- The [Kubescape](https://github.com/kubescape/kubescape/blob/master/docs/getting-started.md#usage) tool

##### Expected Deliverables 

- A CSV file 
- Source code for the four functions 
- Test cases for the four functions. One test case for each of the four functions 


### Task-4: Repository Organization 


##### Tasks 

- Create a `requirements.txt` file with all the libraries with versions that you used to complete Task-1, 2, and 3. 
- Create a README with your team members' names and university email IDs. In the README, report the LLM name that you are using for Task-1.  
- Create a GitHub Action workflow so that every time a user, i.e., a contributor or someone who has forked your repository types `git status`, all test cases created in Task-1, Task-2, and Task-3 are executed automatically. All test cases must pass.  
- Create a binary or a BASH file so that the TA can run your project automatically using a Python-based virtual environment. As input the TA will provide nine inputs each of which includes two PDF files:
  - Input-1: cis-r1.pdf and cis-r1.pdf
  - Input-2: cis-r1.pdf and cis-r2.pdf
  - Input-3: cis-r1.pdf and cis-r3.pdf
  - Input-4: cis-r1.pdf and cis-r4.pdf
  - Input-5: cis-r2.pdf and cis-r2.pdf
  - Input-6: cis-r2.pdf and cis-r3.pdf  
  - Input-7: cis-r2.pdf and cis-r4.pdf  
  - Input-8: cis-r3.pdf and cis-r3.pdf  
  - Input-9: cis-r3.pdf and cis-r4.pdf    

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


## Notes 
- Please start early 
- Please resolve your installation issues by March 20, 2026. You can use `any installation issue` as an excuse for an incomplete project.
- A [tutorial](https://huggingface.co/blog/proflead/gemma-3-tutorial) on how to use Gemma3
- Instructions used for demo: 
```
python3 -m venv comp5700-venv 
source comp5700-venv/bin/activate 
pip install transformers datasets evaluate accelerate torch
cd project
python3 demo.py   
```