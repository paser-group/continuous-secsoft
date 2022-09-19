'''
Author: Akond Rahman 
Sep 09, 2022 
Code needed for Workshop 5 
'''

def simpleCalculator(v1, v2, operation):
    res = 0 
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
    return res 


def simpleFuzzer(): 
    # Complete the following methods 
    # fuzzValues()
    # checkNonPermissiveOerations() 


if __name__=='__main__':
    val1, val2, op = 100, 1, '+'

    data = simpleCalculator(val1, val2, op)
    print('Operation:{}\nResult:{}'.format(  op, data  ) )