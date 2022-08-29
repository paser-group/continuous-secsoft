'''
Akond Rahman 
Oct 06, 2020 
Python variable tracking 
Source: https://docs.python.org/3/library/ast.html
'''
import ast 
import os 
import pandas as pd 


def getBinOpDetails(assiTarget, assiValue, element_type = 'SINGLE_ASSIGNMENT' ): 
    lhs_var, rhs_var = '', '' 
    var_assignment_list = []

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
    if len(lhs_var) > 0:
        var_assignment_list = [( lhs_var, rhs_var , element_type  ) ]
    return var_assignment_list

def getTupAssiDetails(assiTargets, assiValue, element_type = 'TUPLE_ASSIGNMENT' ): 
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
                var_assignment_list.append( (var_name, var_value, element_type) )
    return var_assignment_list     

def getCommonAssiDetails(assignDict, elemType):
    assignTargets, assignValue = assignDict['targets'], assignDict['value']
    var_details_bin  = getBinOpDetails( assignTargets, assignValue , elemType ) 
    var_details_tup  = getTupAssiDetails( assignTargets, assignValue , elemType ) 
    return var_details_bin, var_details_tup 

def getVariables(tree_, elemTypeParam):
    '''
    Input: Python parse tree object 
    Output: All expressions as list of tuples 
    '''
    final_list  = [] 
    for stmt_ in tree_.body:
        for node_ in ast.walk(stmt_):
            assignDict = node_.__dict__
            if isinstance(node_, ast.Assign)  :
                bin_res, tup_res = getCommonAssiDetails( assignDict, elemTypeParam )
                if len(bin_res) > 0:
                    final_list = final_list + bin_res
                if len(tup_res) > 0: 
                    final_list = final_list + tup_res 
            elif isinstance(node_, ast.AugAssign):
                temp = [] 
                assignTarget, assignValue = assignDict['target'], assignDict['value']
                temp.append( assignTarget )
                var_details = getBinOpDetails( temp , assignValue ) 
                final_list = final_list + var_details 
    return final_list 

def getFunctionAssignments(full_tree):
    call_list = []
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
                    for x_ in range(len(funcArgs)):
                        funcArg = funcArgs[x_] 
                        if( isinstance(funcArg, ast.Name ) ) and ( isinstance(funcName, ast.Name ) ):
                            call_list.append( ( lhs, funcName.id, funcArg.id, 'FUNC_CALL_ARG:' + str(x_ + 1) )  )
    return call_list 

def giveVarsInIf(body_):
    var_list = [] 
    assign_dict = body_.__dict__ 
    # print(assign_dict)
    if (isinstance( body_, ast.IfExp )  or isinstance( body_, ast.If )):
        if 'body' in assign_dict:
            ifbody  = assign_dict['body'] 
            for bod_elem in ifbody:
                if isinstance(bod_elem, ast.Assign ):
                    assignDict = bod_elem.__dict__ 
                    bin_res, tup_res = getCommonAssiDetails( assignDict, 'FUNC_VAR_ASSIGNMENT' )
                    if len(bin_res) > 0:
                        var_list = var_list + bin_res
                    if len(tup_res) > 0: 
                        var_list = var_list + tup_res 
        elif 'orelse' in assign_dict:
            orlesebody  = assign_dict['orelse'] 
            # print(orlesebody) 
            var_list =  giveVarsInIf( orlesebody ) 
        return var_list 
    else: 
        return var_list 

    


def getFunctionDefinitions(path2program):
    call_sequence_ls = [] 
    func_var_list = []
    if os.path.exists(path2program):
        full_tree = ast.parse( open( path2program  ).read() )
        # print( ast.dump( full_tree )  )
        for stmt_ in full_tree.body:
            for node_ in ast.walk(stmt_):
                if isinstance(node_, ast.FunctionDef):
                    func_def_dict = node_.__dict__
                    # print(func_def_dict) 
                    func_name, func_args, func_body_parts = func_def_dict['name'], func_def_dict['args'], func_def_dict['body']
                    if(isinstance( func_args, ast.arguments )):
                        arg_index = 1
                        args = func_args.__dict__['args']
                        for arg_ in args:
                            call_sequence_ls.append( (func_name, arg_.__dict__['arg'], 'FUNC_DEFI:' + str(arg_index) ) )
                            arg_index = arg_index + 1
                    # print(func_body_parts)
                    for body_ in func_body_parts:
                        assign_dict = body_.__dict__ 
                        if (isinstance( body_, ast.Assign )):
                            func_var_list = func_var_list + getBinOpDetails( assign_dict['targets'], assign_dict['value'], 'FUNC_SINGLE_ASSIGNMENT' )
                        elif (isinstance( body_, ast.IfExp )  or isinstance( body_, ast.If )):
                            func_var_list = func_var_list + giveVarsInIf(  body_ )


                 
    return call_sequence_ls, func_var_list 


def trackTaint(val2track, df_list_param): 
    var_, call_, func_def, func_var = df_list_param[0], df_list_param[1], df_list_param[2], df_list_param[3]
    
    try:
            track_val_df = var_[var_['RHS']==val2track]
            var2track    = track_val_df['LHS'].tolist()[0]
            # print(var2track, val2track) 

            var_in_call_df = call_[call_['ARG_NAME']==var2track]
            call_lhs , call_arg_type = var_in_call_df['LHS'].tolist()[0], var_in_call_df['TYPE'].tolist()[0] 
            call_arg_index = call_arg_type.split(':')[-1]
            call_func      = var_in_call_df['FUNC_NAME'].tolist()[0]
            # print( val2track, var2track ) 
            # print( call_lhs, call_func, call_arg_index ) 

            var_in_func_def_df = func_def[(func_def['FUNC_NAME']==call_func)  & (func_def['TYPE']=='FUNC_DEFI:'+str(call_arg_index) )]
            func_param2track   = var_in_func_def_df['ARG_NAME'].tolist()[0] 

            # print( val2track, var2track ) 
            # print( call_lhs, call_func, call_arg_index ) 
            # print( func_param2track )

            # print(func_var) 
            needed_func_var_df = func_var[  ( func_var['TYPE']=='FUNC_VAR_ASSIGNMENT' ) & ( func_var['RHS'].str.contains( func_param2track ) ) ]
            lhs_ = needed_func_var_df['LHS'].tolist()[0] 

            # print( val2track, var2track ) 
            # print( call_lhs, call_func, call_arg_index ) 
            # print( func_param2track )
            # print( lhs_  )

            list_ = [ val2track, var2track, call_func, func_param2track, lhs_, call_lhs ] 
            track_str = ""
            for i_ in range(len(list_)):
                elem = list_[i_]
                if (i_ < len(list_) - 1  ):
                    track_str = track_str + str(elem) + "---------->" 
                else:
                    track_str = track_str + str(elem) 
            print(track_str )
    except IndexError as err_: 
        print( 'Your data is not available in the parse tree'  )


def checkFlow(data, code):
    full_tree = None 
    if os.path.exists( code ):
       full_tree = ast.parse( open( code  ).read() )    
       # First let us obtain the variables in forms of expressions 
       fullVarList = getVariables(full_tree, 'VAR_ASSIGNMENT') 
       # Next let us get function invocations by looking into function calls
       call_list = getFunctionAssignments( full_tree ) 
       # Now let us look into the body of the function and see of the paramter is used
       funcDefList, funcvarList = getFunctionDefinitions( code  )         
       #For the workshop please use fullVarList, call_list, funcDefList, funcvarList
       # Then print a path like the following: 
       # 100->val1->v1->res  

       


if __name__=='__main__':
    input_program = 'workshop2-calc.py' 
    data2track    = 1000
    checkFlow( data2track, input_program )

    '''
        # print(fullVarList) 
        # print('*'*25)

        info_df_list = [var_df, call_df, func_def_df, func_var_df]
        trackTaint( 100000000000 , info_df_list )
    '''