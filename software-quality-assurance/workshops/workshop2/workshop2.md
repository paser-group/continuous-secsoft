## Workshop 2

## Workshop Name: Security Weakness Identification with Automation 

## Description 

Use an automated tool to automatically identify security weaknesses in source code 

## Targeted Courses 

Software Quality Assurance 

## Activities 

### Pre-lab Content Dissemination 

In this pre-lab activity we will understand what security weaknesses are, and how they can be identified using a 
static analysis tool called [Bandit](https://bandit.readthedocs.io/en/latest/) 

A security weakness is also referred to as a security vulnerability. It is a coding pattern that violates the property 
of confidentiality, integrity, or availability. A security vulnerability is a kind of software bug. 

Security weaknesses can be identified using two ways: manual inspection by an expert and automated tools. Today, we will use an automated tool called Bandit. A lot of static analysis tools do exist as listed on the [OWASP webpage](https://owasp.org/www-community/Source_Code_Analysis_Tools). 

### In-class Hands-on Experience 

- Install Bandit [Instructions to Install Bandit](https://bandit.readthedocs.io/en/latest/start.html#installation)
- Check installation via `bandit -h` by going to the terminal 
- Run `bandit simple.py` 

### Post Lab Experience 
- Run Bandit against all Python files in the `workshop2.zip` file 
  - Extract `workshop2.zip` that is located here: https://github.com/paser-group/continuous-secsoft/tree/master/software-quality-assurance/workshops/workshop2/
  - Run Bandit by specifying the extracted directory. You might need the `-a`, `-f`, `-r`, and the `-o` flag 
  - Observe the security weaknesses 
- Report the name of the three most frequent security weaknesses detected by Bandit in a document 
- Upload the document on Assignment 2 @ CANVAS  
- Complete the [survey](https://auburn.qualtrics.com/jfe/form/SV_3C2YB8CeV2IWlN4)
- Due: Feb 08, 2023
