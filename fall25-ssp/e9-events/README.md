## Event-driven Static Analysis with Git Hooks

## Description 

Use an existing tool and Git Hooks to activate a static analysis tool for a popular repository 

## Activities 

### Background 

One negative perception about software quality assurance (SQA) is that it prohibits rapid deployment of software. That is why practitioners advocate SQA activities to be integrated into the software development and deployment process. To that end, in modern software engineering, practitioners prefer automated pipelines for security analysis. Instead of asking practitioners to look for security problems themselves, tools should do that for them. 

In that spirit, we as a class  will build a mini tool that automatically runs static security analysis for [FastJM](https://github.com/shanpengli/FastJM), a popular library developed in C/C++. For this workshop you will use [cppcheck](https://cppcheck.sourceforge.io/) and `git hooks`. You will build a Git Hook that will help in identifying known security weaknesses automatically for practitioners who develop and use `FastJM`.  


### In-class Work

- Create a GitHub account if you haven't yet 
- Install CPPCheck on your computer 
- Clone the `FastJM` repository on your computer  
- Go to `.git/hooks/` in the cloned repository 
- Run `cp pre-commit.sample pre-commit` 
- Open `pre-commit` 
- Edit `pre-commit` to run `cppcheck -h`
- Familiarize yourself with `cppcheck` using any or all of the following links: 
   - https://linux.die.net/man/1/cppcheck 
   - http://cppcheck.sourceforge.net/manual.pdf 
   - https://www.mankier.com/1/cppcheck 
- Modify any `.c` or `.cpp` file 
- Commit the modified file to see the effects of the modified `pre-commit` hook   
- Recording of this hands-on experience is available on CANVAS 

### Tasks for you to do 
- Modify your `pre-commit` file so that it can scan the [scikit-ollama](https://github.com/AndreasKarasenko/scikit-ollama/tree/main) repository whenever you commit any file
- Apply [bandit](https://github.com/PyCQA/bandit) to conduct the scanning  
- Grab your output by capturing the screenshots 
- Modify any Python file in the `scikit-ollama` repository 
- Upload your `pre-commit` file and your screenshots on CANVAS 
- Due: Oct 22, 2025


### Rubric 
- `pre-commit` file: 70%
- screenshots: 30%