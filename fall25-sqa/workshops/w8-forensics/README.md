## Software Forensics Through Application of Logging in Machine Learning Code 


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

### Tasks for You To Do 

Imagine this scenario: Dolly, a data science specialist at Auburn University. University has written machine learning (ML) code in `w8.py`. The output is correct but she just learned about adversarial machine learning, which talks about how ML code can be attacked. She learned that ML models are susceptible to security issues:  

1. `poisoning attacks` that are introduced through passing in erroneous dataset files into ML code 
2. `model tricking` that are results of models that are being attacked, which gives erroneous results. Incorrect prediction performance is an indicator of ML models being attacked.  

- Assist Dolly by writing logging code in the correct locations in `w8.py` with comments so that the two above-mentioned issues are logged for all provided ML functions. After writing the code, put in comments to justify your code, save `w8.py`. 
- You do not have to generate the logs by executing `w8.py`
- You must find and add logging code to 20 locations with comments


### Rubric 

- Code with comments: 100%
