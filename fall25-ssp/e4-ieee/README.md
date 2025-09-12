## A Mini Implementation of IEEE Secure Design Principle 

We will be targeting the IEEE design principle of **Use cryptography correctly**

## Tasks for You to Complete 

The following is a YAML describing a user story. Write a code to identify the violations of the following principles. You can use nay programming language and any generative AI tool for completing this task. Your code must: 
(T1) include a method/function to parse the YAML content 
(T2) include at least one method/function that performs content extraction related to policy violations 
(T3) include at least one method/function that performs a key-value based lookup operation to determine violations of the principles 
(T4) include 5 test cases each for (i), (ii), and (iii)


### YAML code snippet 

```
- ALL:"This user story focuses on specifying clearly specifying crypo-related requirements"
  R1:"We will use MD5 for encrypting all passwords and GitHUb API keys."
  R2:"For generating random numbers we will use a fixed range between 39 and 51."
  R3:"We will be using our own implementation of SHA512 to protect API keys used for GPT-o4."
  R4:"Keys for vault will be rotated."
  R5:"If a new cryptography algorithm comes with better strength, then we will use it instead of SHA512." 
```


### Principles related to `use cryptography correctly` 

- Do not use your own cryptographic algorithms or implementations 
– Misuse of libraries and algorithms 
– Poor key management
– Randomness that is not random
– Failure to allow for algorithm adaptation and evolution


## Deliverables and Rubric
- Code for (T1) [15%]
- Code for (T2) [20%]
- Code for (T3) [20%]
- Code for (T4) [25%] 
- Output of test cases in the forms of screenshots [10%] 
- Output of the program in the forms of screenshots [10%] 

## Deadline 
- Sep 26 2025 , 11:59 PM CST 