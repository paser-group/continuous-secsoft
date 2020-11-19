# Workshop-8: Security Static Analysis for Machine Learning 

## Setup 


1. run `docker pull akondrahman/sec-soft-edu-materials:latest` (takes 13 minutes on a Mac)
2. run `docker run -it --privileged <IMAGE_ID>   bash `, to find `IMAGE_ID` run `docker images -a`
3. run `cd /WORKSHOPS/WORKSHOP_8/` 
4. Familiarize yourself with `Bandit` from this blog: https://docs.rackspace.com/blog/getting-started-with-bandit/ 



## The Work 

1. In `/WORKSHOPS/WORKSHOP_8/` you will see a TAR.GZ file. First you need to extract it using the `TAR` command. 
2. Write a program in Python or in your favorite programming langauge that automatically applies the `bandit` program on all Python files within the `/WORKSHOPS/WORKSHOP_8` directory and collects the output generated from Bandit for each file. 
3. Write a method that uses the collected output from Step#2 for all analyzed files and generates a JSON file. The JSON file should include the following fields: 
- `FILE`: Full file path 
- `REPOSITORY`: Full path of the repository being analyzed 
- `ALERTS`: A list of `ALERT` fields, where each field has the following sub-fields: 
   - `SEVERITY`: Severity of the alert 
   - `CONFIDENCE`: Confidence of the alert 
   - `NAME`: Name of the alert 
   - `LINE_NO`: Line number within the file for which the alert is applicable 

Do not report alerts that have `LOW` severity or `LOW` confidence. The output JSON file will look like similar to this: 
```
[
{
  "FILE": "/PATH/TO/SAMPLE/FILE1.txt",
  "REPOSITORY": "/PATH/TO/REPOSITORY1",
  "ALERTS": {
    "SEVERITY": "HIGH",
    "CONFIDENCE": "HIGH", 
    "NAME": "ASSERT_USAGE",    
    "LINE_NO": "50"
  }
}, 
{
  "FILE": "/PATH/TO/SAMPLE/FILE2.txt",
  "REPOSITORY": "/PATH/TO/REPOSITORY2",
  "ALERTS": {
    "SEVERITY": "MEDIUM",
    "CONFIDENCE": "MEDIUM",  
    "NAME": "ASSERT_USAGE",    
    "LINE_NO": "100"
  }
}
]
```
4. Save generated JSON file in your repository along with the source code. Complete Workshop#8 on iLearn. 

#### If you are using Python you can find libraries like `subprocess` and `os` helpful. 


## Breakdown of Points 

1. Program: 70% 
2. Output file: 20% 
3. Saving and iLearn activities: 10% 


For questions please let me know. 

