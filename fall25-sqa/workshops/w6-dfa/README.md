## Automated Data Flow Analysis 

## Description 


### Background 

In our class lecture we learned the importance on why bugs and security vulnerabilities need to be discovered pro-actively. Even though there are a wide a range of tools, without tracking the flow of data we might not be find a bug or a vulnerability accurately. One approach to find a bug or a vulnerability accurately is taint tracking, where we first designate a taint, and then track the taint across a program. 

### Getting Familiar 

- Check the code out in `calc.py` 
- Understand the code in `calc.py` to see manually how simpleCalculator() works
- Write the flow of execution for `calc.py` 

### Tasks for you to do 
- Develop a Python program called `analysis.py` so that the flow of execution for `calc.py` is captured i.e., I get 

> 0->val2->v2->"Wrong divisor. Please check input"->res
- Feel free to use the `Pandas` dataframe [selection operators](https://pandas.pydata.org/docs/user_guide/10min.html#selection)
- Feel free to use generative AI tools 
- Due: Oct 14, 2025

### Your implementation should: 

- Contain a method/class to extract the parse tree for `calc.py`
- Contain a method to parse assignments for the parse tree 
- Contain a method to extract assignment operations 
- Contain a method to generate the flow 
- Use data structures 

### Rubric 

- Locations of data structure usage in your code: 10%
- Code for `analysis.py` : 80%
- Screenshot demonstrating output, i.e., `1000->val1->v1->res`: 10%