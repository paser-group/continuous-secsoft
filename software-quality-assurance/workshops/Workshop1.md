## Workshop 1 

## Workshop Name: Automated Security Weakness Identification 

## Description 

Use an automated tool to automatically idnetify security weaknesses in source code 

## Targeted Courses 

Software Quality Assurance 

## Activities 

### Pre-lab Content Dissemination 

In this pre-lab acitivty we will understand what security weaknesses are, and how they can be identified using a 
static analysis tool called [Bandit](https://bandit.readthedocs.io/en/latest/) 

A secuirty weakness is also referred to as a security vulnerability. It is a coding pattern that violates the property 
of confidentiality, integrity, or availability. A security vulnerability is a kind of software bug. 

Security weaknesses can be indentified using two ways: manual inspection by an expert and automated tools. Today, we will use an automated tool called Bandit. 

### In-class Hands-on Experience 

- Install Bandit [Instructions to Install Bandit](https://bandit.readthedocs.io/en/latest/start.html#installation)
- Check instalaltion via `bandit -h` by going to the terminal 
- Run `bandit workshop1.py` 

### Assignment 1 (Post Lab Experience) 
- Run Bandit against all Python files in the `workshop1.zip` file 
  - Extract `workshop1.zip` 
  - Run Bandit by specifying the extracted directory. You will need the `-a`, `-f`, `-r`, and the `-o` flag 
  - Observe the security weaknesses 
- Report the name of the three most frequent security weaknesses detected by Bandit in a document 
- Upload the document on Assignment 1 @ CANVAS  
- Complete the [survey](https://auburn.qualtrics.com/jfe/form/SV_3C2YB8CeV2IWlN4)
- Due: 