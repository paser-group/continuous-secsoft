def simpleCalculator(v1, v2, operation):
    res = 0 
    if operation=='*':
        res = v1 + v2 
    elif operation=='/':
        if v2 > 0: 
            res = v1 / v2
        else: 
            res = "Wrong divisor. Please check input" 
    return res 


if __name__=='__main__':
    val1, val2, op = 1000, 1, '/'
    data = simpleCalculator(val1, val2, op)
    print('Value#1:{} \nValue#2:{} \nOperation:{} \nResult:{}'.format( val1, val2,  op, data  ) )