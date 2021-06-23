'''
Akond Rahman 
Example for concolic execution 
June 23, 2021 
'''
import z3 


def taomao(str_inp):
    path_ = "/home/ftp/bin"
    sp = path_.index("ftp")
    j = 0 
    if(sp == -1):
        j = str_inp.index("/")
    else:
        j = str_inp.count("/")
    r = str_inp[j] 
    l = len( r ) + len( path_ )
    if ( l > 32 ): 
        print("`l` is greater than 32")
    buf = path_ + r 
    if ( "%n" in buf ):
        print("FOUND A THREAT !!!")
    print("NO THREAT FOUND ... ")


def initZ3():
    '''
    first set the Z3 configs 
    '''
    assert z3.get_version() >= (4, 8, 6, 0) #set version 
    z3.set_option('smt.string_solver', 'z3str3') # tell what string solver you will use 
    z3.set_option('timeout', 120 * 1000 ) ### 120 seconds = 2 minutes     

def solveConstraintsWithZ3( ls_ ):
    initZ3()     
    '''
    start the solver 
    '''
    solverObj = z3.Solver() 

    for constr_ in ls_:
        solverObj.add( constr_  )
    '''
    check solvability and get solutions 
    '''
    if solverObj.check() == z3.sat and solverObj.check() != z3.unknown   : 
        m_ = solverObj.model() 
        for decl_ in m_.decls():
            print("Constraint variable={%s}, value={%s}" % (decl_.name(), m_[decl_] ) ) 
    else:
        print("Solution not found. Oops!")        


def execCosntraintManually():
    initZ3() 
    '''
    initialize variables
    '''
    z_sp  = z3.Int('sp')
    z_l   = z3.Int('l')
    z_buf = z3.String('buf')
    '''
    this one is not solvable as contradicting predicates exist 
    '''
    all_constraints  = [ 
                        z3.And( z3.Not( z_sp == -1 ) , z_l > 32 , z3.Contains( z_buf, "%n" )  )  , 
                        z3.And( z3.Not( z_sp == -1 ) , z_l > 32 , z3.Not( z3.Contains( z_buf, "%n" ) )), 
                        z3.And( z3.Not( z_sp == -1 ) , z_l <= 32 , z3.Contains( z_buf, "%n" )  )  ,    
                        z3.And( z3.Not( z_sp == -1 ) , z_l <= 32 , z3.Not( z3.Contains( z_buf, "%n" ) )) , 
                        z3.And( z_sp == -1  , z_l > 32 , z3.Contains( z_buf, "%n" )  )  , 
                        z3.And( z_sp == -1  , z_l > 32 , z3.Not( z3.Contains( z_buf, "%n" ) )) , 
                        z3.And( z_sp == -1  , z_l <= 32 , z3.Contains( z_buf, "%n" )  )  ,    
                        z3.And( z_sp == -1  , z_l <= 32 , z3.Not( z3.Contains( z_buf, "%n" ) ))                        
    ] 
    '''
    this one is solvable
    '''
    all_constraints  = [ 
                    z3.And( z3.Not( z_sp == -1 ) , z_l > 32 , z3.Contains( z_buf, "%n" )  ) , 
                    z3.And( z3.Not( z_sp == -1 ) , z_l < 132 , z3.Contains( z_buf, "lol" )  )  
    ]
    solveConstraintsWithZ3( all_constraints  )




if __name__=="__main__":
    taomao("lol%ntao...mao")
    execCosntraintManually(  )
