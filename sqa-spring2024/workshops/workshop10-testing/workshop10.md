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

- Go to announcements on CANVAS. See the announcement on `Workshop 10`
- We will use a loop to generate alphanumeric values and pass it into `divide` 
- Recording of this hands-on experience is available on CANVAS 

### Workshop 10 (Post Lab Experience) 
- Open `workshop10.py` 
- Implement the `simpleFuzzer` method so that it can generate alphanumeric values, and these values are plugged into the `simpleCalculator` method. Feel free to use the strings here: https://github.com/minimaxir/big-list-of-naughty-strings/blob/master/blns.json
- Record the crash messages. You should be recording seven (7) errors as part of your implementation. 
- Submit your code, i.e., the `workshop10.py` file and the error messages @ Workshop 10 on CANVAS. (70%)
- Finish the quiz at https://aub.ie/learn-with-paser:  (30%). If you face any issues accessing the quiz website please contact my REU intern Cameron at `cjk0072@auburn.edu`. Instructions on how to use the website is available [here](instruct.md).
- Due: April 18, 2024