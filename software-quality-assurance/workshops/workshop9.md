## Workshop 9

## Workshop Name: Software Forensics Through Application of Logging in Machine Learning Code 

## Description 

Identify logging locations in a machine learning (ML) code. 

## Targeted Courses 

Software Quality Assurance 

## Activities 

### Pre-lab Content Dissemination 

We first need to know what to log and how to log. Let us use the following heuristics. 


#### Heuristics on what to log

- Resources
- Exceptions 
- Change issues 



#### Heuristics on how to log

- Include the name of the identity provider or security realm that vouched for the username, if that information is available. 
- Include the affected system component or other object (such as a user account, data resource, or file). 
- Include the status that says if the object succeeded or failed. 
- Include the application context, such as the initiator and target systems, applications, or components. 
- Include “from where” for messages related to network connectivity or distributed application operation. 
- Include the time stamp and time zone help answer “when.” The time zone is essential for distributed applications.

#### Heuristics on how not log 

- Do not log user names and passwords 
- Do not log sensitive information, such as credit card numbers or social security numbers 
- Do not log nullable objects 



### In-class Hands-on Experience 

> Open `https://docs.python.org/3/library/logging.html` 

> Learn about the common logging methods with Python 

> Integrate logging for `simple.py`. Target the basic important things to log.  

```
import 
```

> Code will be saved and uploaded in this repo. 

> Demo will be recorded and uploaded on CANVAS. 


### Assignment 3 (Post Lab Experience) 

Imagine this scenario: Dolly, a data science specialist at Auburn University. University has written machine learning (ML) code in `workshop9.py`. The output is correct but she just learned about adversarial machine learning, which talks about how ML code can be attacked. She learned that ML models are susceptible to security issues:  

1. `poisoning attacks` that are introduced through passing in erroneous dataset files into ML code 
2. `model tricking` that are results of models that are being attacked, which gives erroneous results. Incorrect prediction performance is an indicator of ML models being attacked.  

- Assist Dolly by writing logging code in the correct locations in `workshop9.py` with comments so that the two above-mentioned issues are logged for all provided ML functions. After writing the code, put in comments to justify your code, save `workshop9.py`. 
- You have the freedom to choose the locations that you think needs to be logged 
- Feel free to use the logger the instructor has provided in class 
- You must add at least find and add logging code to seven locations with comments (70%)
- Submit your code at `Workshop 9 - Forensics` 
- Complete the survey (https://auburn.qualtrics.com/jfe/form/SV_6W19tf7NcRt5y4K) (30%)
- Due Nov 14, 2022  


#### Sample Input/Output:

#### Input: 

> workshop9.py 

#### Expected Output: Code and Comments 

```
iris = datasets.load_iris()
// initiated logging 
logging.basicConfig(filename='app.log', filemode='w', format='%(name)s - %(levelname)s - %(message)s')
```  