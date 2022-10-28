#reff: https://medium.com/@ruchibaheti86/behavior-driven-development-bdd-in-python-218021e815a8 
# from software-quality-assurance.bdd-calc.features.steps.calculator import subtract
from behave import given, when, then 
from calculator import add, subtract 

@given(u'Calculator program is running')
def step_impl(context):
    print(u'Step: Calculator program is running') 

@when(u'I input "{a}" and "{b}" to calculator')
def step_impl(context, a, b): 
    print(u'Step: When I input "{}" and "{}" to calculator'.format(a, b)) 
    context.result = add(a, b) 
    print(u'Stored result "{}" in context'.format( context.result ) ) 

@then(u'I get result "{out}"') 
def step_impl(context, out): 
    if(context.result == int(out)): 
        print(u'Step: Then I get result "{}", "{}"'.format( context.result, out  ) )
        pass 
    else: 
        raise Exception("Invalid calculation. Please check implementation.")


@given(u'Calculator program has executed')
def step_impl(context):
    print('Step: Calculator program has executed')

@when(u'I provide "{x}" and "{y}" to the calculator')
def step_impl(context, x ,y): 
    print(u'Step: When I provide "{}" and "{}" to the calculator '.format(x, y))
    context.result1 = subtract(x, y) 
    print('Stored result "{}" in the context'.format( context.result1 ) )

@then(u'I get the result "{out}"')
def step_impl(context, out): 
    if(context.result1 == int(out) ):
        print(u'Step: Then I get result "{}", "{}" '.format(context.result1, out))
        pass 
    else: 
        raise Exception(u'Wrong calculation. Bug in code.')