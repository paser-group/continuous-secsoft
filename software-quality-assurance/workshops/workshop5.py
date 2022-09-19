'''
Author: Akond Rahman 
Sep 09, 2022 
Code needed for Workshop 5 
'''

from ast import operator
import random 


def simpleCalculator(v1, v2, operation):
    print('The operation is:', operation)
    valid_ops = ['+', '-', '*', '/']
    res = 0 
    if operation in valid_ops:
        if operation=='+':
            res = v1 + v2 
        elif operation=='-':
            res = v1 - v2 
        elif operation=='*':
            res = v1 * v2 
        elif operation=='/':                
            res = v1 / v2 
        elif operation=='%':                
            res = v1 % v2 
        print('After calculation the result is:' , res) 
    else: 
        print('Operation not allowed. Allowable operations are: +, -, *, /, %')
        print('No calculation was done.') 
    return res 


def checkNonPermissiveOperations(): 
    # operation_ = '=' 
    # op_list = [ x for x in range(100) ]
    # for op_ in op_list:
    operation_ = "../../../../../../../../../../../etc/passwd%00"
    simpleCalculator( 100, 1,  operation_  ) 
    print('='*100)

def simpleFuzzer(): 
    # Complete the following methods 
    # fuzzValues()
    checkNonPermissiveOperations() 


if __name__=='__main__':
    # val1, val2, op = 100, 1, '+'

    # data = simpleCalculator(val1, val2, op)
    # print('Operation:{}\nResult:{}'.format(  op, data  ) )

    simpleFuzzer()