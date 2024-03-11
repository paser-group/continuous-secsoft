'''
Akond Rahman
Simple Python file to demonstrate logging 
'''
import myLogger


def simpleDiv(a, b):
    return a/b 


if __name__=='__main__': 
   print('Welcome to the simple division calculator!')
   logObj  = myLogger.giveMeLoggingObject()
   logObj.info("Simple application started.")
   a = input('Type in first number: ') 
   logObj.info('First number is: %s', a) 
   b = input('Type in second number: ')
   logObj.info('Second number is: %s', b) 
   a , b = int(a), int(b)
   simpleDiv(a, b) 
