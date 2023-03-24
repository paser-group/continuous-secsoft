import logging_example


def simpleDiv(a, b):
    return a/b 


if __name__=='__main__': 
   print('Welcome to the simple division calculator!')
   logObj = logging_example.giveMeLoggingObject()
   logObj.info('Executing simple.py') 
   print('*'*50)
   a=input('Provide first input:')
   logObj.info('Collected first input') 
   print('Thanks') 
   b=input('Provide second input:')
   logObj.info('Collected second input') 
   a, b = int(a), int(b)
   res=simpleDiv(a, b) 
   print('The answer is:', res)
   logObj.info('Finished executing simple.py') 
