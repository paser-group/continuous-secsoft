'''
Akond Rahman 
Example for concolic execution 
June 23, 2021 
'''
import z3 
import taomao 
import ast 
import operator 

'''
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
''' 

def generateZ3InitStr():
    str_ = "import z3\nassert z3.get_version() >= (4, 8, 6, 0)\nz3.set_option('smt.string_solver', 'z3str3')\nz3.set_option('timeout', 120 * 1000 ) "
    return str_ 


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


def generateSolverString():

    fullStr = 'solverObj = z3.Solver()\nfor constr_ in ls_:\n\tsolverObj.add( constr_  )\nif solverObj.check() == z3.sat and solverObj.check() != z3.unknown:\n\tm_ = solverObj.model()\n\tfor decl_ in m_.decls():\n\t\tprint("Constraint variable={%s}, value={%s}" % (decl_.name(), m_[decl_] ) )\n\telse:\n\t\tprint("Solution not found. Oops!")\n'
    fullStr = "\n" + fullStr 
    return fullStr

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



def parse_file(filename_):
    with open(filename_) as f_:
        return ast.parse(f_.read(), filename=filename_) 


def getOpNodeMapping( opObj ):
    str2ret = ""
    if isinstance( opObj, ast.Eq ):
        str2ret = "=="
    elif isinstance( opObj, ast.Gt ):
        str2ret = ">"        
    elif isinstance( opObj, ast.GtE ):
        str2ret = ">="                
    elif isinstance( opObj, ast.Lt ):
        str2ret = "<"        
    elif isinstance( opObj, ast.GtE ):
        str2ret = "=<"                
    elif isinstance( opObj, ast.In ):
        str2ret = "IN"                
    return str2ret

def mineTaomaoConstraints( py_file ):
    ls2ret = []
    for node_ in ast.walk(parse_file( py_file  )):
        if isinstance(node_,  (ast.If ) ):
            test_stmt_node =  node_.test 
            if ( isinstance( test_stmt_node, ast.Compare )  ):
                left_node , op_list, operand    = None ,  [] , None 
                left_node = test_stmt_node.left
                ops_nodes = test_stmt_node.ops 
                comps     = test_stmt_node.comparators 
                if isinstance( left_node , ast.Name ):
                    left_node = left_node.id 
                elif isinstance( left_node , ast.Str ):
                    left_node = left_node.s 
                    # print(dir(left_node), left_node) 
                for op_node in ops_nodes:
                    op_list.append( getOpNodeMapping( op_node ) )
                for compa in comps:
                    if isinstance( compa, ast.UnaryOp ):
                        if isinstance( compa.operand, ast.Num ):
                            operand =  compa.operand.n 
                    elif isinstance( compa, ast.Num ):
                        operand =  compa.n 
                    elif isinstance( compa, ast.Name ):                        
                        operand =  compa.id  
                        # print(compa, dir(compa), type(compa) )
                ls2ret.append( (  left_node, op_list, operand ) )
                # print( test_stmt_node.left , test_stmt_node.ops, test_stmt_node.comparators )
            # print( node_.test, node_.body, node_.orelse )

    return ls2ret 


def getZ3String(ls_):
    z3_full_str    = ""
    z3_init_str    = ""
    temp_const_str = []
    z3_const_str   = ""
    for tup_ in ls_:
        '''
        first generate string for initiliazation 
        '''
        var_    = tup_[0]
        op_     = tup_[1][0]
        operand = tup_[2]
        if op_ == "IN":
            create_var_ = operand 
        else: 
            create_var_ = var_ 
        if isinstance(var_, int):
            z3_var_ = "z_" + str( create_var_ ) + " = z3.Int('" + create_var_ + "')" + "\n"
        elif isinstance(var_, str):
            z3_var_ = "z_" + str( create_var_ ) + " = z3.String('" + create_var_ + "')"  + "\n"
        z3_init_str = z3_init_str + z3_var_ + "\n"
        '''
        then generate constraints 
        '''
        const_str   = ""
        if op_ == "IN":
            const_str = "z3.Contains(" + "z_" + create_var_ + ", '" + var_ + "')" 
        else:        
            const_str = "z_" + create_var_ + " " + op_+ " " + str( operand ) 
        temp_const_str.append( const_str )
    and_str1 = "z3.And("
    and_str2 = ")"
    for const_str in temp_const_str:
        z3_const_str = z3_const_str + const_str + " ," 
    z3_const_str = z3_const_str[0:len(z3_const_str) - 1 ] 
    z3_const_str = and_str1 + z3_const_str + and_str2 
    ls_str       = "ls_=[]\nls_.append("+ z3_const_str +")"
    z3_full_str  =  generateZ3InitStr() + "\n" * 2 + z3_init_str   + ls_str + generateSolverString()
    print( z3_full_str ) 
    return z3_full_str  

        




if __name__=="__main__":
    # taomao.taomao("lol%ntao...mao")
    # execCosntraintManually( ) 
    taomao_constraint_ls = mineTaomaoConstraints( '/Users/arahman/Documents/OneDriveWingUp/OneDrive-TennesseeTechUniversity/Teaching/Fall2021/code/continuous-secsoft/z3-exploration/taomao.py' )
    z3_str = getZ3String( taomao_constraint_ls )
