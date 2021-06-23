'''
Akond Rahman 
June 22, 2021 
Practising with Z3 along with applications for conclic fuzzing 
'''
import z3 
from fuzzingbook.Coverage import Coverage
from fuzzingbook.ControlFlow import PyCFG, CFGNode, to_graph, gen_cfg
# from graphviz import Source, Graph
import inspect 
import sys 

'''
For coverage 
'''
line_coverage = [] 

'''
From FuzzingBook 
Not used 
'''
'''
class ArcCoverage(Coverage):
    def traceit(self, frame, event, args):
        if event != 'return':
            f = inspect.getframeinfo(frame)
            self._trace.append((f.function, f.lineno))
        return self.traceit

    def arcs(self):
        t = [i for f, i in self._trace]
        return list(zip(t, t[1:]))
'''


def doFactorial(inp):
    if inp < 0:
        return None 
    elif inp == 0:
        return 0 
    elif inp == 1:
        return 1 
    temp = 1 
    while inp != 0 :
        temp =temp * inp 
        inp = inp -1 
    return temp 

def doZ3ForConcolicFuzzing():
    '''
    first set the Z3 configs 
    '''
    assert z3.get_version() >= (4, 8, 6, 0) #set version 
    z3.set_option('smt.string_solver', 'z3str3') # tell what string solver you will use 
    z3.set_option('timeout', 60 * 1000 ) ### 60 seconds = 1 minute 
    '''
    declare symbolic variables 
    '''
    z_inp = z3.Int('inp')
    '''
    add constraints 
    '''
    z_inp < 0 # correpsonds to one branch of `inp < 0` 
    z3.Not( z_inp < 0 ) # correpsonds to the other branch of `inp < 0` 
    '''
    solve() only gives  a solution 
    '''
    soln = z3.solve( z_inp < 0  )
    print(soln, dir(soln)  ) 
    print('='*50)
    predicates = [ z3.Not( z_inp < 0 ) , z3.Not( z_inp == 0  ), z3.Not( z_inp == 1 ) ]
    '''
    As solve() only gives  a solution , we need more using Solver() 
    '''
    solverObj = z3.Solver()
    # solverObj.add( z3.Not( z_inp < 0 ) , z3.Not( z_inp == 0  ), z3.Not( z_inp == 1 ) )
    solverObj.add( predicates[0:-1] + [z3.Not( predicates[-1] )] )
    print(solverObj.check()) 
    if solverObj.check() == z3.sat and solverObj.check() != z3.unknown   : 
        m_ = solverObj.model() 
        for decl_ in m_.decls():
            print("Constraint variable(%s)=%s" % (decl_.name(), m_[decl_] ) ) 
    else:
        print("Solution not found. Oops!")

def traceFunc(frame_, event_, arg_):
    if event_ == 'line':
        global line_coverage 
        func_name = frame_.f_code.co_name
        line_no_  = frame_.f_lineno 
        line_coverage.append( line_no_ )
    return traceFunc 

def setupCoverage(inp_):
    # with ArcCoverage() as cov: 
    #     val = doFactorial(5) 
    #     print(val)
    # lines = [i[1] for i in cov._trace if i[0] == 'factorial'] 
    # Source(to_graph(gen_cfg(inspect.getsource( doFactorial )), arcs=cov.arcs())) 
    # print(lines) 
    src = { i + 1: s for i, s in enumerate( inspect.getsource( doFactorial  ).split('\n') ) }
    # print(src)
    '''
    setup execution tracing 
    '''
    global line_coverage
    line_coverage = [] 
    sys.settrace( traceFunc ) ## turn tracer on 
    result  = doFactorial(inp_)
    sys.settrace(None)  ## turn tracer off 
    _, func_source_startLine = inspect.getsourcelines (  doFactorial )
    # print(func_source_startLine) 
    func_source     = inspect.getsource( doFactorial )
    func_with_lines = [""] + func_source.splitlines()  
    for lineNo in range( len( func_with_lines ) ):
        orig_lineNo = lineNo + func_source_startLine
        if orig_lineNo not in line_coverage:
            print( func_with_lines[lineNo] , orig_lineNo, lineNo )
    return result 




if __name__=='__main__':
    input_val  = 5 
    # val = doFactorial(input_val)
    res = setupCoverage( input_val )
    print(res)
    print('*'*50)
    print( line_coverage ) 
    doZ3ForConcolicFuzzing(  )
