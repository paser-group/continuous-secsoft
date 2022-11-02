## Workshop 8

## Workshop Name: Requirements Validation with Test-driven Development 

## Description 

We will discuss and implement software requirements for our simple calculator app. 

## Targeted Courses 

Software Quality Assurance 

## Activities 

### Pre-lab Content Dissemination 

Requirements engineering is the process of discovering, analyzing, documenting and validating the requirements of the system. Each software development process goes through the phase of requirements engineering. Engineered requirements are often translated to software features through different software development methodologies, such as test driven development and behavior development. We will use both, test driven development and behavior driven development in this workshop.   


#### Test-driven Development (TDD)

The steps for TDD is:

1. Your test fails 
2. Write code to fix your test 
3. Your test passes 
4. Refactor your test code 

#### Behavior-driven Development (BDD)

The steps for BDD is:

1. Specify a feature file that describes the requirements in natural language 
2. Specify a steps file that executes what needs to be done to satisfy the requirements 
3. Implement the development file to satisfy the steps  

### In-class Hands-on Experience 

- Navigate to `https://github.com/paser-group/continuous-secsoft/tree/master/software-quality-assurance/bdd-calc`
- Apply test-driven development (TDD) to implement a subtraction operation for our simple calculator. We will use `unittest`. 
- Apply behavior-driven development (BDD) to implement a subtraction operation for our simple calculator. We will use `behave`.  
- Demo will be recorded and shared on CANVAS 



### Assignment 3 (Post Lab Experience) 

- For this part of the workshop you will develop two Python program files to demonstrate that you have practiced test-driven development (TDD). 
- Your code should satisfy the following requirements:
  - The calculator must be able to multiply and divide
  - All methods related to mathematical operations should sanitize input
  - All methods related to mathematical operations should handle division by zero exceptions
  - All methods related to mathematical operations should be fast

- You have applied static analysis to your Python program files. Use the [Bandit](https://bandit.readthedocs.io/en/latest/) tool to perform static analysis and report any weaknesses that you find in a TEXT file
- Submit your Python program files and  your TEXT file on CANVAS @ `Workshop 8` 
- Complete survey: https://auburn.qualtrics.com/jfe/form/SV_556t0yGLahw3vVA
- Due: Nov 07, 2022 