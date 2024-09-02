## Workshop 1

## Workshop Name: Integrating LLM Local Deployment for Source Code Generation and Troubleshooting into Intellij and VSCode IDEA

## Description 
We will learn how to use opensource LLM model to generate code for a simple python FizzBuzz app.

## Targeted Courses 

Software Quality Assurance 

## Activities 

### Pre-lab Content Dissemination 
The objective of this pre-lab content dissemination is to introduce participants to the concept of integrating LLM local deployment for source code generation and troubleshooting. By the end of this session, participants will have a better understanding of the benefits and potential challenges of using LLM local deployment in their software development workflows.

#### Test-driven Development (TDD)

The steps for LLM integration is:

1. Install and set up the required LLM local deployment tools (`ollama`,`llama-CPI`, `LM-Studio`)
2. Install and set up the `Continue` plugin for Intellij and VSCode IDEA 
3. Refactor your test code with LLM for better design, debug and explainability.


### In-class Hands-on Experience 

- Navigate to `https://github.com/paser-group/continuous-secsoft/blob/master/fall2024/workshops/w1-req/`
- Use `ollama`, `Llama-CPI` and `LM-Studio` to start the LLM server locally
- Download and Deploy the LLM models `starcoder2-15b-instruct-v0.1-GGUF` and `Meta-Llama-3.1-8B-Claude-iMat-GGUF` locally
- Use `Continue` plugin in the `Intellij` and `VSCode` IDEA to integrate the LLM models deployed through `ollama/LM studio/llama-cpi` into your code.
- Apply `/explain-code`, `/test-code` features of the `Continue` plugin to interact with your source code.
- Demo will be recorded and shared on CANVAS. 



### Assignment After Class (Post Lab Experience) 

- For this part of the workshop you will update two Python program files (source.py and test.py as per the instructions) to demonstrate that you have practiced LLM integration with the IDEA. 
- Your code should satisfy the following requirements:
  - write the `isMultiple(value,mod)` in the <source.py> function using LLM integration.
  - write the test cases for the `fizzbuzz(value)` function using LLMs integrated into your IDEA.
    - `test_returns1With1PassedIn()`
    - `test_returns2With2PassedIn()`
    - `test_returnsFizzWith3PassedIn()`
    - `test_returnsBuzzWith5PassedIn()`
    - `test_returnsFizzWith6PassedIn()`
    - `test_returnsBuzzWith10PassedIn()`
    - `test_returnsFizzBuzzWith15PassedIn()`
- The TEXT file should contain explanation of the LLMs for your generated code in the format of 
  - Objective
  - Potential Enhancement of the code written
  - Output of your code for the inputs  [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15].
- List 10 Potential LLMs other than the those mentioned in the class for better assessment of your code into the TEXT file.
- Submit your Python program files and  your TEXT file on CANVAS @ `Workshop1` .
- Due: Sep 17, 2024, 11:59 PM CST 

### Rubric 

- Python source code [20%]
- Python test code [20%]
- Examples of test case failures [20%]
- Examples of test case successes [20%]
- Listing 10 potential LLMs for Code Generation Tasks [20%]