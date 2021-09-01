# Workshop-2: Forensics in Machine Learning Code 

`Due: Tuesday, Sep 07, 2021 (AoE) `


## Pick Any One  (Option-1 or Option-2) 

### (Option-1) Tasks for Pythonistas  

Imagine this scenario: Dolly, a data science specialist at Tennessee Tech. University has written machine learning (ML) code in `ML.py`. The output is correct but she just learned about adverserial machine learning, which talks about how ML code can be attacked. She learned that 
ML models are susceptible to security issues:  

1. `poisoning attacks` that are introduced through passing in erroneous dataset files into ML code 
2. `model tricking` that are results of models that are being attacked, which gives erroneous results. Incorrect prediction performance is an indicator of ML models being attacked.  

Use knowledge from the class on what things need to be logged and how. Assist Dolly by writing logging code in the correct locations in `ML.py` with comments so that the two above-mentioned issues are logged 
for all provided ML examples. After writing the code, put in comments to justify your code, save `ML.py`, and then push it to your repository. Then, use the `Software Forensics Workshop` on ILearn to input the link of your repository. You will find the [Python logging utility](https://docs.python.org/3/library/logging.html) useful. You don't have to run the code. 


###  (Option-2) Tasks for Non-Python Users    

See the attached Zip file. This is a simple Bluetooth Android application written in Java. You need to add logging code in `app/src/main/java/com/mcuhq/simplebluetooth/` to assist the developer with forensics. Add Java-based logging code for all methods that you think are important to log in all Java files in `app/src/main/java/com/mcuhq/simplebluetooth/`. Use knowledge from the class on what things need to be logged and how.    

A few notes: 
1. No need to run code. 
2. For logging you should use the [Java Logging API](https://www.vogella.com/tutorials/Logging/article.html) 

After writing the code, put in comments to justify your code, save `all modified Java files`, and then push it to your repository. Then, use the `Software Forensics Workshop` on ILearn to input the link of your repository.  

Reff: `https://github.com/bauerjj/Android-Simple-Bluetooth-Example` 

### Sample Input/Output for All:

#### Input: 

> ML.py for Pythonistas and `app/src/main/java/com/mcuhq/simplebluetooth/` for non-Python users 

#### Expected Output for Pythonistas: Logging code with comments, e.g., ML.py will look like: 

```
iris = datasets.load_iris()
// initiated logging 
logging.basicConfig(filename='app.log', filemode='w', format='%(name)s - %(levelname)s - %(message)s')
```  

#### Expected Output for Non-Python Users: Logging code with comments, e.g., a Java file in `app/src/main/java/com/mcuhq/simplebluetooth/` will look like this: 

```
fileHandler.setFormatter(new MyFormatter());
//setting custom filter for FileHandler
fileHandler.setFilter(new MyFilter());
logger.addHandler(fileHandler);

```

Do the same for all Java files that you think is necessary. 

#### Ensure that your logging code (applies for both options) handles the following: 
- Timestamp 
- Name of output file will be `WORKSHOP2.log` 
- Logging level 
