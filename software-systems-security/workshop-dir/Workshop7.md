# Workshop-7: Security Static Analysis for Machine Learning Projects 

## Due date `Oct 27, 2021 (Wed) AoE`

## The Work 

1. Download a ZIP file from this link: https://tennesseetechuniversity-my.sharepoint.com/:u:/g/personal/arahman_tntech_edu/EVvGBAwLjZRMuS6HDvO-AKMBMYFqL3l-vsEDL7fxJctWxg?e=08BnMx
2. Write a program  in BASH or Python or in your favorite programming langauge that automatically applies the `bandit` program on all Python files within the `ML-CODE` directory and collects the output generated from Bandit for each file. You can use `bandit -f json` for convenience.  
3. Write a method that uses the collected output from Step#2 for all analyzed files and generates a JSON file. The JSON file should include the following fields: 
- `FILE`: Full file path 
- `ALERTS`: A list of `ALERT` fields, where each field has the following sub-fields: 
   - `SEVERITY`: Severity of the alert 
   - `CONFIDENCE`: Confidence of the alert 
   - `NAME`: Name of the alert 
   - `LINE_NO`: Line number within the file for which the alert is applicable 

Do not report alerts that have `LOW` severity or `LOW` confidence. 

The output JSON file will look like similar to this: 
```
[
{
  "FILE": "/PATH/TO/SAMPLE/FILE1.py",
  "ALERTS": {
    "SEVERITY": "HIGH",
    "CONFIDENCE": "HIGH", 
    "NAME": "ASSERT_USAGE",    
    "LINE_NO": "50"
  }
}, 
{
  "FILE": "/PATH/TO/SAMPLE/FILE2.py",
  "ALERTS": {
    "SEVERITY": "MEDIUM",
    "CONFIDENCE": "MEDIUM",  
    "NAME": "ASSERT_USAGE",    
    "LINE_NO": "100"
  }
}
]
```
4. Save generated JSON file in your repository along with the source code.
5. Put your repository link on the iLearn assignemnt `Security for ML Software: Workshop`




For questions please let me know. 

