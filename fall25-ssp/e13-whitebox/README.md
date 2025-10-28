## Workshop Name: Simplistic White-box Fuzzing 

## Description 

Develop a simple fuzzer to test an existing implementation of a Python function

## Activities 

### Background 

White-box fuzzing is a fuzzing technique where the source code of a software is leveraged 
to generate test cases. The goal of these test cases is to find bugs in the source code, so that these bugs 
are found and fixed early at the development stage. As part of this workshop we will develop a simple fuzzer 
that fuzzes an existing implementation of a simple calculator.   

### Tasks For You To Do 
- Open `simple.py` 
- Implement the `simpleFuzzer` method so that it can generate alphanumeric values, and these values are plugged into the `simpleCalculator` method. Feel free to use the strings here: https://github.com/minimaxir/big-list-of-naughty-strings/blob/master/blns.json
- Record the crash messages. You should be recording 10 errors as part of your implementation. 
- Submit your code, i.e., the modified `submit.py` file and the 10 collected error messages in a text file. 
- Due: Nov 14, 2025, 11:59 PM CST