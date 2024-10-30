'''
Author: Akond Rahman 
'''

import random 

def divide(v1, v2):
   if v1.isnumeric() and v2.isnumeric():
      v1 = float(v1)
      # print('Before conversion:', v2)
      v2 = float(v2) 
      # print('After conversion:', v2)
      if v2 != 0:
         return v1 / v2 
      else: 
         # pass 
         return "Division by zero error."
   else: 
      return "One of the input is invalid."

def fuzzValues(val1, val2):
   res = divide(val1, val2)
   return res  

def simpleFuzzer(): 
   # resFromMethod = fuzzValues(1, 0)
   resFromMethod = fuzzValues('1', '0')
   resFromMethod = fuzzValues('1234', '2')
   # resFromMethod = fuzzValues(-2, -1) 
   resFromMethod = fuzzValues('-2', '-1')
   # resFromMethod = fuzzValues(0.75, 0.25)
   resFromMethod = fuzzValues('66', '22')
   print(resFromMethod) 



if __name__=='__main__':
    simpleFuzzer()
