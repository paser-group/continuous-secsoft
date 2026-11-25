## Workshop for Predictive Security Testing 

Predictive security testing uses AI techniques, such as decision trees to predict the location of vulnerabilities in source code. One example of predictive security testing is construction of vulnerability prediction models (VPMs), where source code metrics are used to develop a model that can identify if a source code file includes a vulnerability. As part of this workshop, you will develop a prediction model for vulnerabilities in Solidity files. Solidity  is used for Ethereum-based smart contracts. 

### Steps

1. Extract all vulnerability entries reported in each JSON file located in `dataset.zip`. Each vulnerability entry is identified with `id`
2. For each identified vulnerability identified from Step-1, identify the number of files and the number of CWEs respectively, using the `category` and `files` fields. 
3. For each identified vulnerability identified from Step-1, identify the severity of the vulnerability using the `severity` field. 
4. Create a CSV file using the output from Step-1, 2, 3. The format of the file is:

```
ID,SEVERITY,CWECOUNT,FILECOUNT,JSONFILENAME
0,HIGH,2,3,2024.12.09 - Final - Oku's New Order Types Contract Contest Audit Report.json
8,MEDIUM,3,2,2024.12.09 - Final - Oku's New Order Types Contract Contest Audit Report.json
11,LOW,11,3,1,Across Audit.json
0,CRITICAL,0,3,1,Across Audit.json
```
Save the file as `solidity.csv`. The CSV file should include data from all vulnerability data files saved as JSON files in `dataset`. 

5. Develop two 10 x 10 cross fold prediction models using the dataset created in Step-4. Use [decision tree](https://scikit-learn.org/stable/modules/generated/sklearn.tree.DecisionTreeClassifier.html#sklearn.tree.DecisionTreeClassifier) and [support vector machine](https://scikit-learn.org/stable/modules/generated/sklearn.svm.SVC.html#sklearn.svm.SVC) for building the models. The dependent variable for the model is `SEVERITY` and the independent variables are `CWECOUNT` and `FILECOUNT`. 

6. Evaluate the developed models using precision, recall, and F-measure. Report them in `accuracy.txt` 

### Rubric 

- Code for Step-1: 10%
- Code for Step-2: 20%
- Code for Step-3: 10%
- Code for Step-4: 10%
- Code for Step-5: 20%
- Code for Step-6: 10%
- `solidity.csv`: 10%
- `accuracy.txt`: 10%

### References

[A report from the FORGE-Curated Dataset](https://github.com/shenyimings/FORGE-Curated/blob/8b89c6f0176aaeba35631cc803292645008cb9ba/dataset-curated/findings/2024.12.09%20-%20Final%20-%20Oku's%20New%20Order%20Types%20Contract%20Contest%20Audit%20Report.json)