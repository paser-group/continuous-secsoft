## Workshop 1

## Workshop Name: Requirements Validation with Test-driven Development 

## Description 

We will discuss and implement software requirements for a simple calculator app. 

## Targeted Courses 

Software Quality Assurance 

## Activities 

### Pre-lab Content Dissemination 

Requirements engineering is the process of discovering, analyzing, documenting and validating the requirements of the system. Each software development process goes through the phase of requirements engineering. Engineered requirements are often translated to software features through different software development methodologies, such as test driven development.    


#### Test-driven Development (TDD)

The steps for TDD is:

1. Your test fails 
2. Write code to fix your test 
3. Your test passes 
4. Refactor your test code 


### In-class Hands-on Experience 

- Navigate to `https://github.com/paser-group/continuous-secsoft/tree/master/software-quality-assurance/workshop1/`
- Apply test-driven development (TDD) to implement a subtraction operation for our simple calculator. We will use `unittest`. 
- Demo will be recorded and shared on CANVAS (Panopto Recordings). 



### Assignment 1 (Post Lab Experience) 

- For this part of the workshop you will develop two Python program files to demonstrate that you have practiced test-driven development (TDD). 
- Your code should satisfy the following requirements:
  - The calculator must be able to multiply and divide
  - All methods related to mathematical operations should handle division by zero exceptions
  - Written code has been scanned by a static analysis tool. You will apply static analysis to your Python program files. Use the [Bandit](https://bandit.readthedocs.io/en/latest/) tool to perform static analysis and report any weaknesses that you find in a TEXT file
- Submit your Python program files and  your TEXT file on CANVAS @ `Workshop 1` 
- Complete survey: https://auburn.qualtrics.com/jfe/form/SV_556t0yGLahw3vVA
- Due: Feb 02, 2023


### Commands that you can find useful
- `pip install bandit` to install bandit 
- `bandit -r <FOLDER_PATH_OF_YOUR_CODE>` 