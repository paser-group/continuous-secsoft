'''
Akond Rahman 
Mar 30, 2021 
Practising Symbolic Execution 
https://z3prover.github.io/api/html/namespacez3py.html
'''
from z3 import * 
import dis 


def test(a):
    x = 0 
    if a > 0 and a < 5:
        x = 1 
    b =  a + 1 
    if x ==  1 and b > 6: 
        print("Hello!")

def intro2z3():
    # https://secretlab.institute/2019/08/09/symbolic-analysis-with-python-and-z3/
    solverObj = Solver() 
    pie_price = Real('pie_price')
    num_pies  = Int('num_pies') 
    pies_owning = pie_price * num_pies

    solverObj.add( pie_price == 3.14 )
    solverObj.add( pies_owning > 10 )

    s = solverObj.check() 
    print(s, s.r) ## s= sat, s.r =1 , indicating TRUE 
    print(solverObj.model()   )  ## provides solutions as a list ... also tells what values can be used to satisfy constriants 

def getByteCode():
    #https://docs.python.org/3.7/library/dis.html#analysis-functions
    dis.dis( test ) 
    print('-'*25)
    dis.code_info( test )
    print('-'*25)
    dis.show_code( test )
    print('-'*25)    
    # dis.disco( test )
    print('-'*25)    
    dis.get_instructions( test )

def work1WithZ3():
    # https://secretlab.institute/2019/08/09/symbolic-analysis-with-python-and-z3/
    solverObj = Solver() 
    
    var_x = Int('var_x')
    solverObj.add( var_x == 0 )

    var_a = Int('var_a')
    solverObj.add( var_a > 0  )
    solverObj.add( var_a < 5  )

    var_b = Int('var_b')
    var_b = var_a + 1
    solverObj.add( var_b > 6  )

    s_obj = solverObj.check()
    print(s_obj, s_obj.r)  

def work2WithZ3():
    solverObj = Solver()  

    var_a = Int('var_a')
    solverObj.add( var_a > 0  )   
    solverObj.add( var_a < 0  )   
    res = solverObj.check()

    print(res, res.r)    

def work3WithZ3():
    solverObj = Solver()  

    var_a = Int('var_a')
    var_b = Int('var_b')

    res   = var_a / var_b 

    solverObj.add( var_a > 0  )   
    res = solverObj.check()

    print(res, res.r)    

def work4WithZ3():
    solverObj = Solver()  

    var_a = BitVec('a', 16)   
    x = String('x')

    solverObj.add( var_a > 0b1101000 )

    solverObj.add( var_a < 0b01111010 )

    # solverObj.add( x == '10' )
    # res = solverObj.check() 
    # find all possible solutions , reff: https://stackoverflow.com/questions/13395391/z3-finding-all-satisfying-models
    while solverObj.check().r == 1:
        soln = solverObj.model()[var_a].as_long()
        # print(res, res.r, soln, chr(soln) ) 
        print( soln, chr(soln) ) 
        solverObj.add( var_a != solverObj.model()[var_a]  ) # prevent next model from using the same assignment as a previous model



if __name__ == '__main__': 
    # intro2z3() 
    # getByteCode()
    # print('='*50)
    # work1WithZ3()
    # print('='*50)
    # work2WithZ3()
    print('='*50)
    work3WithZ3()
    print('='*50)
    work4WithZ3()    