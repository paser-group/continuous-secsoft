## Workshop Name: Simplistic White-box Fuzzing 

## Description 

Develop a simple fuzzer to test an existing implementation of a simple calculator 

## Targeted Courses 

Software Quality Assurance 

## Activities 

### Pre-lab Content Dissemination 

White-box fuzzing is a fuzzing technique where the source code of a software is leveraged 
to generate test cases. The goal of these test cases is to find bugs in the source code, so that these bugs 
are found and fixed early at the development stage. As part of this workshop we will develop a simple fuzzer 
that fuzzes an existing implementation of a simple calculator.   

### In-class Hands-on Experience 

- Go to announcements on CANVAS. See the announcement on `Workshop 5`
- Implement the `checkNonPermissiveOerations()` method 
  - We will write a code snippet so that we can test all types of corner cases with respect valid operations are handled 
  - We will use a loop to generate alphanumeric values and pass it into `simpleCalculator` 
- Recording of this hands-on experience is available on CANVAS 

### Assignment 5 (Post Lab Experience) 
- Open `workshop5.py` 
- Implement the `fuzzValues` method so that it can generate alphanumeric values, and these values are plugged into the `simpleCalculator` method. 
- Record the error messages. You should be recording seven (7) errors as part of your implementation. 
- Submit your code, i.e., the `workshop5.py` file and the error messages @ Workshop 5 on CANVAS. (70%)
- Complete the [survey](https://auburn.qualtrics.com/jfe/form/SV_e3Bxdy5U3uOPtSC):  (30%)
- Due: Oct 03, 2022 