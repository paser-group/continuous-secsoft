'''
Author: Akond Rahman 
Code needed for Workshop 10
'''

import random 

def divide(v1, v2):
   return v1 / v2 

def fuzzValues(val1, val2):
   res = divide(val1, val2)
   return res  

def simpleFuzzer(): 
    ls_ = ['123', 123, 3, 4 , 5, 'hello', '2e34r']
    for x in ls_:
      if isinstance(x, str):
         mod_x = x + str( random.randint(1, 10) )
      elif isinstance(x, int): 
         mod_x = x + random.random()  
      fuzzValues( x, mod_x )  

if __name__=='__main__':
    simpleFuzzer()
