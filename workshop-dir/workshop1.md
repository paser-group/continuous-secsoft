# Workshop#1: Concolic Testing 

## Aug 27, 2021


### Due date: Upon discussion with class, Tuesday, 31st August 2021, AOE (Any Where on Earth) 

### Tasks 

- Your task is to apply what you learned in the class on Aug 25, and apply it to the following program to generate ALL possible path constraints, and use a SAT solver of your choice to generate solutions. You will generate the path cosntraints manually. 

The program: 

```
def buggyFunc(float_var, int_var):
    res      = []
    temp_var = int( float_var )
    if (temp_var == 3 * int_var):
       if( int_var > temp_var - 50   ):
          print(res[5])
``` 
- First spend 2-3 minutes to see if you understand the problem, then give me an estimated time to complete. 
- Use Markdown files to report all path constraints and the concrete values are using for each round. Save the markdown file in your repository  
- For using SAT solvers you need to write code: save the code in your repository 
- If you are using Python and using Z3 as a SAT solver, see this to get familiar with: https://ericpony.github.io/z3py-tutorial/guide-examples.htm 
- On iLearn, under `Assesments/Assignments/` there is an assignment called `Software Testing Workshop` where you will write in the link to the GitLab repo that you will save your code in. 
- Report the path constraints for which execution will yield `print(res[5])`. 
- No restrictions on langauge usage 
- Time to complete will be determined based on the class's feedback 
- Submit your work in a repoo: either `gitlab.csc.tntech.edu` or `private repos on GitHub, and add me to give read access`. 



Example output: 
```
1. 
p + q > 10 
....
2. 
c + d < 11 , c < -1 , z3 => c = ? , d =? 
3. 
...
5. 
c1 + c2 < 10, c1 = 3, c2 =5, will get the program execution to stop at print(res[5]) 

```