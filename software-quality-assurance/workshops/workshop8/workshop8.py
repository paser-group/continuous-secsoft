'''
Author: Akond Rahman 
Code needed for Workshop 8
'''

from ast import operator
import random 

def divide(v1, v2):
    temp = 0 
    if (isinstance(v1, int))  and (isinstance(v2, int)): 
       if v2 >  0:
          temp =  v1 / v2
       elif v2 < 0:
          temp = v1 / v2 
       else:
          print("Divisor is zero. Provide non-zero values.")
    else: 
       temp = "Invalid input. Please provide numeric values."    
    return temp 

def fuzzValues():
    # positive or expected software testing 
    #res = divide(2, 1)
    # negative software testing: > 0 divisor test 
    #res = divide(2, 0)
    # negative software testing: <0 divisor test 
    #res = divide(2, -1)
    # negative software testing: check types: example 1  
    res = divide(2, '1')  
    # negative software testing: check types: example 2 
    res = divide('2', '1') 
    print(res)   
    print('='*100)

def simpleFuzzer(): 
    fuzzValues()


if __name__=='__main__':
    simpleFuzzer()
