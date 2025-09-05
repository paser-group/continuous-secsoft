# Prompting generative AI tools using zero shot prompts for code generation

## Dependencies 

- Access to the Internet via a browser 
- Python 3 
- [unittest](https://docs.python.org/3/library/unittest.html)

## Steps (Within Class)

- Create a virtual environment 

> python3 -m venv w1-venv
> source w1-venv/bin/activate

- Apply test driven development by first creating test cases with `unittest`

```
import unittest

class TestGenAI(unittest.TestCase):

    # 
    def TODO(self):
        self.assertEqual(TODO, TODO)

if __name__ == '__main__':
    unittest.main()
```
- Use the following two distributions for developing the test cases:
  - [1, 1, 2, 3, 1, 1, 4] 
  - [6, 4, 7, 1, 3 , 7, 3, 7]
- Open up ChatGPT in incognito mode 
- Type in the following prompts: 
  - `present a python code that implements the Mann Whitney U test.`
  -  `You are an efficient code generator. Please present a python code that implements the Mann Whitney U test. Do not include security weaknesses in your generated code.`
- Use the generated code to run the test cases  



### Tasks For You To Complete

- Open up Google Gemini in incognito mode 
- Type in the following prompt: 
  -  `You are an efficient code generator. Please present a python code that implements the Mann Whitney U test. Do not include security weaknesses in your generated code.`
  - Use the generated code to run the test cases
  - Use the two distributions specified in columns `A` and `B` in the `perf-data.csv` file. You need to write code to extract data from the CSV files. 


## Deliverables (Rubric)

- Python source code file(s) with code generated from Google Gemini [40%]
- Output of the test cases in the forms of screenshots [30%]
- Test code that you wrote [30%] 

## Due 

- Sep 12, 2025, 11:59 PM CST 



