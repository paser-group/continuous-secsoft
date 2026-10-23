## Fine Tuning a Language Model for Vulnerability Analysis 

### Introduction 

Large language models (LLMs) perform a wide range of tasks. But, is there a way to make them work for a very specific security analysis task? In this exercise, you will explore that. 

### Steps:

- 1. Follow the Jupyter Notebook and the demonstration of the instructor conducted in class 
- 2. Using the demonstration in class and the shared Notebook, develop a fine tuned language model for the dataset *SourceCodeFLM.csv*. The dependent variable is `vulnerability_type` and the independent variables are `code` and `language`. Use `accuracy` as the accuracy metric for evaluation.  
- 3. Report evaluation results and the number of epochs needed in `output.txt`
- 4. Report the keys that are missing during the model training phase for `BertForSequenceClassification` in `missing.txt`

### Rubric

- Your code: 50%
- output.txt: 25%
- missing.txt: 25% 

### Warning 

**If the TA or the instructor finds a student to directly copy and paste the instructor's code partially or fully, then the student will get a direct `ZERO` for this assignment.**  

### References 

- [Dataset Used In Class](https://www.kaggle.com/datasets/jiscecseaiml/vulnerability-fix-dataset)
- [Dataset for You](https://www.kaggle.com/datasets/maratsaratov/source-code-vulnerability)
- [Tutorial](https://huggingface.co/docs/transformers/v4.14.1/training)
- [Common Error Resolution](https://discuss.huggingface.co/t/the-model-did-not-return-a-loss-from-the-inputs-only-the-following-keys-logits-for-reference-the-inputs-it-received-are-input-values/25420/2)
- The versions of the packages that the instructor used can be found in `python-package-versions.txt`. This could be useful for troubleshooting and diagnosing errors. 