'''
Akond Rahman 
Oct 06, 2020 
Python variable tracking 
'''
import ast 
import os 


def getBinOpDetails(assiTarget, assiValue ): 
    lhs_var, rhs_var = '', ''

    for target in assiTarget:
        if isinstance(target, ast.Name):
            lhs_var = target.id 
            # print("Variable:" + target.id)  
    if isinstance(assiValue, ast.BinOp):
        operands =  assiValue.left , assiValue.right 
        for op_ in operands:
            if(isinstance( op_ , ast.Name ) ):
                rhs_var = rhs_var + "," + op_.id 
                # print("Operand:" + op_.id ) 
    elif isinstance(assiValue, ast.Num):
        rhs_var = assiValue.n 
    var_assignment_list = [( lhs_var, rhs_var   ) ]
    return var_assignment_list

def getTupAssiDetails(assiTargets, assiValue ): 
    # print('INSIDE TUPLE')
    var_assignment_list = []
    # print(assiTargets, assiValue)
    # print(dir(assiTarget), dir(assiValue) )
    # print(type(assiTarget), type( assiValue)     )
    if  isinstance(assiValue, ast.Tuple) and isinstance(assiTargets, list):
        target_ = assiTargets[0]
        name_var_as_tuple_dict  =  target_.__dict__ 
        value_var_as_tuple_dict =  assiValue.__dict__ 
        
        name_var_ls, value_var_ls = name_var_as_tuple_dict['elts'], value_var_as_tuple_dict['elts']
        if(len(name_var_ls) == len(value_var_ls) ):
            for x_ in range(len(name_var_ls)):
                name, value = name_var_ls[x_] , value_var_ls[x_] 
                var_name, var_value = '', '' 
                if isinstance( value, ast.Num ):
                    var_value =  value.n 
                else:
                    var_value =  value.s 
                if isinstance(name, ast.Name):
                    var_name = name.id 
                var_assignment_list.append( (var_name, var_value) )
    return var_assignment_list     

def getVariables(path2program):
    if os.path.exists(path2program):
        full_tree = ast.parse( open( path2program  ).read() )
        # print( ast.dump( full_tree )  )
        for stmt_ in full_tree.body:
            for node_ in ast.walk(stmt_):
                if isinstance(node_, ast.Assign)  :
                    assignDict = node_.__dict__
                    assignTargets, assignValue = assignDict['targets'], assignDict['value']
                    var_details_bin  = getBinOpDetails( assignTargets, assignValue ) 
                    # print(assignDict) 
                    var_details_tup  = getTupAssiDetails( assignTargets, assignValue ) 
                    # print(var_details_tup) 
                elif isinstance(node_, ast.AugAssign):
                    assignDict = node_.__dict__
                    temp = [] 
                    # print(assignDict)
                    assignTarget, assignValue = assignDict['target'], assignDict['value']
                    temp.append( assignTarget )
                    var_details = getBinOpDetails( temp , assignValue ) 
                    # print( var_details )




def getFunctionAssignments(path2program):
    if os.path.exists(path2program):
        full_tree = ast.parse( open( path2program  ).read() )
        # print( ast.dump( full_tree )  )
        for stmt_ in full_tree.body:
            for node_ in ast.walk(stmt_):
                if isinstance(node_, ast.Assign):
                    lhs = ''
                    assign_dict = node_.__dict__
                    targets, value  =  assign_dict['targets'], assign_dict['value']
                    if isinstance(value, ast.Call):
                        funcDict = value.__dict__ 
                        funcName, funcArgs, funcLineNo =  funcDict['func'], funcDict['args'], funcDict['lineno'] 
                        for target in targets:
                            if( isinstance(target, ast.Name) ):
                                lhs = target.id 
                        for x_ in funcArgs:
                            if( isinstance(x_, ast.Name ) ) and ( isinstance(funcName, ast.Name ) ):
                                print( lhs, "=", funcName.id,  x_.id  ) 

if __name__=='__main__':
    input_program = 'fuzz.py' 
    getVariables(input_program) 
    getFunctionAssignments( input_program ) 