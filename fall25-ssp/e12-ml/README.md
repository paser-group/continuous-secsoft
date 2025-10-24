## Security Analysis with Machine Learning Algorithms 

Machine learning (ML) algorithms provide a lot of capabilities with respect to predictive power. Using these predictive powers we can classify what elements are vulnerable. Here, we will use a machine algorithm called decision tress to classify which websites are malicious and which websites are benign. In the dataset the column `type` is dependent variable or class that needs to be classified. 



### Tasks For You To Do 

- Create a Python program that has the following functions/methods:
  - Item-1: Loading the dataset into a data structure
  - Item-2: Using the `Decision Tree` implementation in [scikit-learn](https://scikit-learn.org/stable/modules/tree.html)
  - Item-3: Reporting accuracy, precision, recall, and F-measure for the predicted classes. 
  - Item-4: Reporting the importance of each feature using the constructed decision tree. Consider using the [scikit-learn documentation](https://scikit-learn.org/stable/modules/feature_selection.html). 
  - Item-5: Use entropy to determine the quality of a split    
- For classification do not include the column `URL` as a feature 

### Rubric 

- Code: 80% (16% for each of the five items mentioned above)
- Output of the classification result in a text file. The file must include data for accuracy, precision, recall, and F1: 10%
- Output of the feature importance in a text file: 10% 