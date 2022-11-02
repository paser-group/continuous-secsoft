import logging


def getLOggerObj():
    logging.basicConfig(filename='EXAMPLE.LOG', level=logging.INFO, format='%(asctime)s:::%(name)s:::%(levelname)s:::%(message)s', datefmt='%d-%b-%y %H:%M:%S') 
    loggerObj = logging.getLogger('example-logger') 
    return loggerObj 

def getSQALogger():
    logging.basicConfig(filename='SQA.TEST.LOG', level=logging.DEBUG, format='%(asctime)s:%(name)s:%(levelname)s:%(message)s', datefmt='%d-%b-%y %H-%M-%S')
    logObj = logging.getLogger('sqa-logger')
    return logObj 