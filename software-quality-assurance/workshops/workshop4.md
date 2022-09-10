## Workshop 4

## Workshop Name: Event-driven Static Analysis with GitHooks

## Description 

Use an existing tool and Git Hooks to activate a static analysis tool for a popular repository 

## Targeted Courses 

Software Quality Assurance 

## Activities 

### Pre-lab Content Dissemination 

One negative perception about software quality assurance (SQA) is that it prohibits rapid deployment of software. That is why practitioners advocate SQA activities to be integrated into the software development and deployment process. To that end, in modern software engineering, practitioners prefer automated pipelines for security analysis. Instead of asking practitioners to look for security problems themselves, tools should do that for them. 

In that spirit, we as a class  will build a mini tool that automatically runs static security analysis for [NumCPP](https://github.com/dpilger26/NumCpp), a popular library developed in C++ that contains a lot of data structure-related implementations. For this workshop you will use [cppcheck](https://cppcheck.sourceforge.io/) and `git hooks`. You will build a Git Hook that will help in identifying known security weaknesses automatically for practitioners who develop and use `NumCPP`.  




### In-class Hands-on Experience 

- Go to announcements on CANVAS. See the announcement on `Workshop 4`
- Create a GitHub account if you haven't yet 
- Install CPPCheck on your computer 
- Fork the `NumCPP` repository with your GitHub account
- Clone the forked repository on your computer  
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

### Assignment 4 (Post Lab Experience) 
- Modify your `pre-commit` file so that it can scan your `NumCPP` repository whenever you commit any file (60%)
  - Grab your output by capturing the screenshots 
  - Modify any CPP file in the `NumCPP` repository 
  - Upload your `pre-commit` file and your screenshots on CANVAS 
- Complete the [survey](https://auburn.qualtrics.com/jfe/form/SV_bryx8vonSvVmW5o)  (40%)
- Due: Sep 26, 2022