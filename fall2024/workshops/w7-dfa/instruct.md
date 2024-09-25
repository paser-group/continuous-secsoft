## Workshop 7

## Workshop Name: Automated Data Flow Analysis 

## Description 

Use existing code to track a data value across a program 

## Targeted Courses 

Software Quality Assurance 

## Activities 

### Pre-lab Content Dissemination 

In our class lecture we learned the importance on why bugs and security vulnerabilities need to be discovered pro-actively. Even though there are a wide a range of tools, without tracking the flow of data we might not be find a bug or a vulnerability accurately. One approach to find a bug or a vulnerability accurately is taint tracking, where we first designate a taint, and then track the taint across a program. In this workshop we will develop a program that uses existing code provided by the instructor (Akond Rahman) to track a taint, i.e., a data value.  

### In-class Hands-on Experience 

- Check the code out in `calc.py` and `analysis.py`
- Understand the code in `calc.py` to see manually how simpleCalculator() works
- Write the flow of execution for `calc.py` 
- Understand the code in `analysis.py` to understand how parse tree and relevant components from `calc.py` have been extracted

### Post Lab Experience 
- Complete the `checkFlow` function in `analysis.py` so that the flow of execution for `calc.py` is captured i.e., I get `1000->val1->v1->res`
- Feel free to use the `Pandas` dataframe [selection operators](https://pandas.pydata.org/docs/user_guide/10min.html#selection)
- Upload your code, i.e., the updated `analysis.py` file on Workshop 7 @ CANVAS  
- Due: Oct 16, 2024

### Rubric 

- Code for `analysis.py` : 60%
- Screenshot demonstrating output, i.e., `1000->val1->v1->res`: 40%