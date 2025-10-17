## Workshop Name: Software Forensics Through Application of Logging  

## Description 

Apply forensics using a Python library 

## Tasks For You To Do  

- Familiarize yourself with the [logging library](https://docs.python.org/3/library/logging.html)
- Create a logger that will generate logs automatically for the following code snippet:

```
def simpleDiv(a, b):
    return a/b 

def mul(a, b):
    return a*b 

def add(a, b):
    return a + b 

def sub(a, b):
    return a - b 
```

- Your logger should generate logs in a manner so that will include the following information are captured:
  - Timestamp
  - Name of the method
  - Value of the two input parameters 
  - Exception-related data

- Please see SAMPLE.log for the expected output. The SAMPLE.log file is an example, not the exact output that is expected. 

### Rubric 

- Code to implement the logger: 60%
- Generated log output: 40% 

### Deadline

Nov 03, 11:59 PM CST 