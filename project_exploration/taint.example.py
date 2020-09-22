'''
Taint Exploration 
Akond Rahman 
Sep 21 
'''

import inspect 
from staticfg import CFGBuilder
import astor
import ast  

def generateTriangleCFG():
    cfgObject  = CFGBuilder().build_from_file('TRIANGLE', 'triangle.py') 
    print(dir(cfgObject), type(cfgObject) )
    cfgObject.build_visual('TRIANGLE_CFG', 'pdf')

def generateSaltyCFG():
    cfgObject  = CFGBuilder().build_from_file('SALTY', 'salt.parser.py') 
    print(dir(cfgObject), type(cfgObject) )
    cfgObject.build_visual('SALTY_CFG', 'pdf')


class GetAssignments(ast.NodeVisitor):
    def visit_Name(self, node):
        if isinstance(node, (ast.Store, ast.Expr)):
            print(node.id, node.lineno)

def parse_file(filename):
    with open(filename) as f:
        return ast.parse(f.read(), filename=filename)

def walkAST(fName): 
    pyTree = ast.parse(fName) 
    # pyExprs = pyTree.body
    # for expr_ in pyExprs:
    #     print(dir(expr_.value), type(expr_.value)) 
        # print(dir(expr_), type(expr_))
    # print(dir(pyExpr), type(pyExpr))
    # exec(compile(pyTree, filename="<ast>", mode="exec"))
    # print(type(pyTree), dir(pyTree)) 

    for node_ in ast.walk(parse_file(fName)):
        if isinstance(node_,  (ast.Expr, ast.Expression) ):
            expr_line, expr_val = node_.lineno, node_.value
            print(dir(node_), type(node_), str(node_), expr_line, expr_val )  

    # GetAssignments().visit(pyTree) 


if __name__=='__main__':
    print('Hello taint!')
    # inspectObj = inspect.getsource( check_triangle )
    # print(dir( inspectObj ), type(inspectObj), inspectObj ) 

    # generateSaltyCFG()

    walkAST('elixir.prep.py') 
