## Security Weakness Identification with Automation 

## Description 

Use an automated tool to automatically identify security weaknesses in source code 


### Background

We will understand what security weaknesses are, and how they can be identified using a 
static analysis tool called [Bandit](https://bandit.readthedocs.io/en/latest/) 

A security weakness is also referred to as a security vulnerability. It is a coding pattern that violates the property 
of confidentiality, integrity, or availability. A security vulnerability is a kind of software bug. 

Security weaknesses can be identified using two ways: manual inspection by an expert and automated tools. Today, we will use an automated tool called Bandit. A lot of static analysis tools do exist as listed on the [OWASP Webpage](https://owasp.org/www-community/Source_Code_Analysis_Tools). 

### In-class Activities 

- Install Bandit [Instructions to Install Bandit](https://bandit.readthedocs.io/en/latest/start.html#installation)
- Check installation via `bandit -h` by going to the terminal 
- Run `bandit simple.py` 

### Task For You To Do 
- Run Bandit against all Python files in the `w5.zip` file 
  - Extract `w5.zip`. 
  - Run Bandit by specifying the extracted directory. You might need the `-a`, `-f`, `-r`, and the `-o` flag 
  - Observe the security weaknesses 
- Report the name of the three most frequent bugs detected by Bandit in a document 

### Rubric 

- Names of the three frequent bugs in the text file: 100% 


### Due 

October 06, 2025 