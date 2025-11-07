# Workshop 13 - Functional Testing with RESTful Services 

## Introduction 

REST stands for `Representational State Transfer`. RESTful software services is a software design methodology so that different types of software-based systems can interact with each other using a common set of rules. RESTful services have become very common for web-based software system interaction. 

### Example 

GitHub'a API service: https://api.github.com/

## Steps in Class 

- source ../w1-req/w1-venv/bin/activate
- Install the Flask tool via `pip3 install Flask`
- python3 simpleApp.py
- python3 testSimpleApp.py

### Task for You To Do 

- Use test-driven development to create the following endpoints:
  - *ssp*: visiting this endpoint will display the text `Secure Software Process`
  - *vanity*: visiting this endpoint will display your full name  
  - *mypython*: this will display the Python version installed on your computer 
  - *csse*: this will display `Department of Computer Science and Software Engineering`

### Deliverables 
- Code for the endpoints: 60% (Please submit *your simpleApp.py* file)
- Test cases for the endpoints: 20% (Please submit *your testSimpleApp.py* file)
- Test case results: 20%

### Deadline: 

Dec 02, 2025, 11:59 PM CST 