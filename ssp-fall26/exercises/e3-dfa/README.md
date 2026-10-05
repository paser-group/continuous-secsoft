## Automated Data Flow Analysis 


### Background 

In our class lecture we learned the importance on why bugs and security vulnerabilities need to be discovered pro-actively. Even though there are a wide a range of tools, without tracking the flow of data we might not be find a bug or a vulnerability accurately. One approach to find a bug or a vulnerability accurately is taint tracking, where we first designate a taint, and then track the taint across a program. 

### Getting Familiar  

- Check the code out in `repeat.py` 
- Understand the code in `repeat.py` to see manually how simpleCalculator() works
- Write the flow of execution for `repeat.py` 

### Tasks for You To Do 
- Develop a Python program called `code.py` so that the flow of execution for `repeat.py` is captured i.e., I get `3->op->res->data`


### Your implementation should: 

- Contain a method/class to extract the parse tree for `repeat.py`
- Contain a method to parse assignments for the parse tree 
- Contain a method to extract assignment operations 
- Contain a method to generate the flow 
- Contain usage of data structures 

### Rubric 

- Usage of data structures: 10%
- Code for `code.py` : 80%
- Screenshot demonstrating output, i.e., `3->op->res->data` : 10%