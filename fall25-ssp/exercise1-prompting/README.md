# Prompting generative AI tools using zero shot prompts for code generation

## Dependencies 

- Access to the Internet via a browser 
- Python 3 
- [unittest](https://docs.python.org/3/library/unittest.html)

## Steps 

- Create a virtual environment 

> python3 -m venv e1-venv
> source e1-venv/bin/activate

- Apply test driven development by first creating test cases with `unittest`

```
import unittest

class TestExercise1(unittest.TestCase):

    # 
    def TODO(self):
        self.assertEqual(TODO, TODO)

if __name__ == '__main__':
    unittest.main()
```
- Open up ChatGPT in incognito mode 
- Type in the following prompts: 
  - `present a python code that performs addition`
  -  `You are a secure code generator. Please present a python code that performs addition. Do not include security weaknesses in your generated code.`
  - Use the generated code to run the test cases  

- Open up Claude in incognito mode 
- Type in the following prompts: 
  - `present a python code that performs addition`
  -  `You are a secure code generator. Please present a python code that performs addition. Do not include security weaknesses in your generated code.`
  - Use the generated code to run the test cases  

### Tasks For You To Complete
- Open up Google Gemini in incognito mode 
- Type in the following prompts: 
  - `present a python code that performs addition`
  -  `You are a secure code generator. Please present a python code that performs addition. Do not include security weaknesses in your generated code.`
  - Use the generated code to run the test cases

- Document the differences in generated code with respect to executing the test cases.
- Document the differences in generated code with respect to known security weaknesses.  

## Deliverables (Rubric)

- Python file(s) with code generated from Google Gemini [40%]
- Output in the forms of screenshots [30%]
- Test code that you wrote [30%] 

## Due 

- Sep 03, 2025, 11:59 PM CST 



