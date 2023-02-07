## Workshop 3

## Workshop Name: Automated Information Flow Analysis with Taint Tracking

## Description 

Use existing code to track a susceptible data value across a program 

## Targeted Courses 

Software Quality Assurance 

## Activities 

### Pre-lab Content Dissemination 

In our class lectures we learned the importance on why bugs and security vulnerabilities need to be discovered pro-actively. Even though there are a wide a range of tools, without tracking the flow of data we might not be find a bug or a vulnerability accurately. One approach to find a bug or a vulnerability accurately is taint tracking, where we first designate a taint, and then track the taint across a program. In this workshop we will develop a program that uses existing code provided by the instructor (Akond Rahman) to track a taint, i.e., a data value.  

### In-class Hands-on Experience 

- Go to announcements on CANVAS. See the announcement on `Workshop 2`
- Check the code out in `https://github.com/paser-group/continuous-secsoft/tree/master/software-quality-assurance/workshops/workshop3/calc.py` and `https://github.com/paser-group/continuous-secsoft/tree/master/software-quality-assurance/workshops/workshop3/analysis.py`
- Understand the code in `workshop3/calc.py` to see manually how simpleCalculator() works
- Write the flow of execution for `workshop3/calc.py` 
- Understand the code in `workshop3/analysis.py` to understand how parse tree and relevant components from `workshop3/calc.py` have been extracted

### Post Lab Experience 
- Complete the `checkFlow` function in `workshop3/analysis.py` so that the flow of execution for `workshop3/calc.py` is captured i.e., I get `100->val1->v1->res`
- Upload your code, i.e., the updated `analysis.py` file on Assignment 3 @ CANVAS  
- Complete the [survey](https://auburn.qualtrics.com/jfe/form/SV_0chh9rpr4X9Prfg)
- Due: Feb 22, 2023