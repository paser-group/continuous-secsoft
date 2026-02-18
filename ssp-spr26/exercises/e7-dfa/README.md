## Data Flow Analysis (DFA)


### Background 

In our class lecture we learned the importance on why bugs and security vulnerabilities need to be discovered pro-actively. Even though there are a wide a range of tools, without tracking the flow of data we might not be find a bug or a vulnerability accurately. One approach to find a bug or a vulnerability accurately is taint tracking, where we first designate a taint, and then track the taint across a program. 

### Getting Familiar  

- Check the code out in `calc.py` 
- Understand the code in `calc.py` to see manually how simpleCalculator() works
- Write the flow of execution for `calc.py` 

### Tasks for You To Do 
- Develop a Python program called `analysis.py` so that the flow of execution for `calc.py` is captured i.e., I get `-100->val2->v2->res->900`
- Feel free to use the `Pandas` dataframe [selection operators](https://pandas.pydata.org/docs/user_guide/10min.html#selection)
- Feel free to use generative AI tools 


### Your implementation should: 

- Contain a method/class to extract the parse tree for `calc.py`
- Contain a method to parse assignments for the parse tree 
- Contain a method to extract assignment operations 
- Contain a method to generate the flow 
- Contain usage of data structures 

### Rubric 

- Usage of data structures: 25%
- Code for `analysis.py` : 70%
- Screenshot demonstrating output, i.e., `-100->val2->v2->res->900`: 5%