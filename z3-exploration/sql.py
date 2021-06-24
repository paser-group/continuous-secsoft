'''
Akond Rahman 
June 24, 2021 
Use Z3 to generate SQL injection templates 
'''

import z3 
import sqlite3 
from sqlite3 import Error 

def initZ3():
    '''
    first set the Z3 configs 
    '''
    assert z3.get_version() >= (4, 8, 6, 0) #set version 
    z3.set_option('smt.string_solver', 'z3str3') # tell what string solver you will use 
    z3.set_option('timeout', 120 * 1000 ) ### 120 seconds = 2 minutes     

def createConn(path): 
    conn_ = None
    try:
        conn_ = sqlite3.connect( path )
    except Error as e_:
        print("Error connecting: {}".format( e_ )  )
    return conn_

def execQuery( query ):
    path_   = "student.db"
    conn_   = createConn( path_  )
    cursor_ = conn_.cursor() 
    try:
        cursor_.execute( query )
        conn_.commit() 
        record = cursor_.fetchall()
        print(record)
        cursor_.close()
    except Error as err_ :
        print("Error executing query: {}".format( err_ )  )
    finally:
        conn_.close() 

def solveConstraintsWithZ3( ls_ ):
    solutions = [] 
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
            the_sol = m_[decl_]
            # print("Constraint variable={%s}, value={%s}" % (decl_.name(), the_sol ) ) 
            solutions.append( the_sol.as_string() )
            # print( type(the_sol), dir(the_sol) )
    else:
        print("Solution not found. Oops!")     
    return solutions 

def generateSelectTemplates():
    initZ3() 
    qry_str = "SELECT * FROM student WHERE name='" 
    qry_int = "SELECT * FROM student WHERE id=" 
    # qry = "select sqlite_version(); "

    z3_name = z3.String( "NAME" ) 
    z3_id   = z3.Int("ID")


    

    str_constraints = [  z3.Contains( z3_name, ";" ), z3.Contains( z3_name, " drop" ), z3.Contains( z3_name, " table" )  ]
    int_constraints = [ z3_id < 1000, z3_id > 25  ]
    all_constraints = str_constraints + int_constraints 

    solutions = solveConstraintsWithZ3(all_constraints) 
    for solve in solutions:
        if solve.isnumeric():
            the_qry = qry_int + solve  + ";"
        else: 
            the_qry = qry_str + solve + "';"            
        print("The query:" + the_qry )
        execQuery( the_qry ) 


if __name__=="__main__":
    generateSelectTemplates()