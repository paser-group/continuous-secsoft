'''
Akond Rahman 
Sep 14, 2020 
Monday 
'''
import random 

def fuzzer(max_length=100, char_start=32, char_range=32):
    string_length = random.randrange(0, max_length + 1)
    out_ = ""
    for _ in range(0, string_length):
        out_ += chr(random.randrange(char_start, char_start + char_range))
    return out_

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


if __name__=='__main__':
    # val1, val2, op = 2, 1, '+'
    # val1, val2, op = 1, 0, '/' 
    val1, val2, op = fuzzer(), fuzzer(), fuzzer()     

    data = simpleCalculator(val1, val2, op)
    print('Operation:{} \nresults:{}'.format(  op, data  ) )