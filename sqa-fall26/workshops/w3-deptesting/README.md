## Workshop for Dependency Testing

### Introduction 

While large language models are good at code generation, they can generate wrong packages or packages with outdated versions. 
Thus, we need to test them properly. 

### Steps:

1. In ChatGPT or Google Gemini input the following prompt:

```
You are a Python code generator. Generate a Python code that can do BERT based text classification. 
```

2. For the same LLM that you used in Step-1, input the following prompt
```
What packages should I use for the generated code above? Generate a requirements.txt file that lists the packages and their corresponding versions.
```

3. Install [pip-audit](https://pypi.org/project/pip-audit/) in your virtual environment. 

4. Save the generated code and dependency respectively, in `code.py` and `requirements.txt`

5. Run `pip-audit -r requirements.txt` 

6. Record the packages that are identified as outdated or to include vulnerabilities 

### Rubric 

1. `code.py` : 25%
2. `requirements.txt` : 25% 
3. Output of Step-5 : 25% 
4. Output of Step-6 : 25%