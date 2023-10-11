import logging

'''
def giveMeLoggingObject():
    format_str = '%(asctime)s %(message)s'
    file_name  = 'SIMPLE-LOGGER.log'
    logging.basicConfig(format=format_str, filename=file_name, level=logging.INFO)
    loggerObj = logging.getLogger('simple-logger')
    return loggerObj
'''

def createLoggerObj(): 
    fileName  = '2023-10-11.log' 
    formatStr = '%(asctime)s %(message)s'
    logging.basicConfig(format=formatStr, filename=fileName, level=logging.INFO)
    myLogObj = logging.getLogger('sqa2023-logger') 
    return myLogObj
