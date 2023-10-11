'''
Akond Rahman
Simple Python file to demonstrate logging 
'''
import myLogger


def simpleDiv(a, b):
    return a/b 


if __name__=='__main__': 
   print('Welcome to the simple division calculator!')
   a=input('Provide first input:')
   simpleLogger  = myLogger.createLoggerObj()
   simpleLogger.info("Initiating") 
   simpleLogger.info('Generic information: taking input: %s', str(a)) 
   print('Thanks') 
   b=input('Provide second input:')
   simpleLogger.info('Generic information: taking input: %s', str(b))    
   a, b = int(a), int(b)
   res=simpleDiv(a, b) 
   simpleLogger.info('Generic information: getting results: %s', str(res))       
   print('The answer is:', res)
