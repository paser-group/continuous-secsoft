# Prompting generative AI tools using zero shot prompts for test case generation

## Dependencies 

- Access to the Internet via a browser 
- Python 3 

## Steps (Within Class)

- Create a virtual environment if you have not already. You can also use the previously created virtual environment. 

> python3 -m venv w1-venv
> source w1-venv/bin/activate

- Open up ChatGPT in incognito mode 
- Type in the following prompt: 
  -  `You are an efficient test case generator. Please develop Python-based test cases for the following implementation:`

```
def addition(x, y):
    return x + y

def subtraction(x, y):
    return x - y    
```
- Use the generated code to run the test cases  



### Tasks For You To Complete

- Install the `pymannkendell` library in your virtual environment for trend identification 
- Open up Google Gemini in incognito mode 
- Type in the following prompt: 
  -  `You are an efficient test case generator. Please develop 10 Python-based test cases for the following implementation.`


```
import pymannkendall as pmk
def understandTrends(data_):
    trend, h, p, z, Tau, s, var_s, slope, intercept = pmk.original_test(data_)
    print('For {} trend is {} and p-value is {}'.format(categ, trend, p))
```

  - Use the generated code to run the test cases



## Deliverables (Rubric)

- Output of the test cases in the forms of screenshots [50%]
- Test code for the 10 test cases [50%] 

## Due 

- Sep 16, 2025, 11:59 PM CST 



