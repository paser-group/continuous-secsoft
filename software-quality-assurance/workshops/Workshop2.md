## Workshop 2 

## Workshop Name: Automated Program Analysis with Taint Tracking

## Description 

Use existing code to track a susceptible data value across a program 

## Targeted Courses 

Software Quality Assurance 

## Activities 

### Pre-lab Content Dissemination 

In our class lectures we learned the importance on why bugs and secuirty vulnerbailities need to be discovered pro-actively. Even though there are a wide a range of tools, without tracking the flow of data we might not be find a bug or a vulnerability accurately. One approach to find a bug or a vulnerability accrately is taint tracking, where we first designate a taint, and then track the taint across a program. In this workshop we will develop a program that uses exisiting code provided by the instructor (Akond Rahman) to track a taint, i.e., a data value.  

### In-class Hands-on Experience 

- Go to announcements on CANVAS. See the announcemnent on `Workshop 2`
- Check the code out in `workshops/workshop2-calc.py` and `workshops/workshop2-analysis.py`
- Understand the code in `workshops/workshop2-calc.py` to see manually how simpleCalculator() works
- Write the flow of execution for `workshops/workshop2-calc.py` 
- Understand the code in `workshops/workshop2-analysis.py` to udnerstand how parse tree and relevant components from `workshops/workshop2-calc.py` have been extracted

### Assignment 2 (Post Lab Experience) 
- Complete the `checkFlow` function in `workshops/workshop2-analysis.py` so that the flow of execution for `workshops/workshop2-calc.py` is captured i.e., I get `100->val1->v1->res`
- Upload your code, i.e., the updated `workshop2-analysis.py` file on Assignment 2 @ CANVAS  
- Complete the [survey](https://auburn.qualtrics.com/jfe/form/SV_0chh9rpr4X9Prfg)
- Due: Sep 12, 2022