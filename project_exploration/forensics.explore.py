'''
Akond Rahman 
Sep 04, 2020 
Friday 
'''
import logging 
LOGFORMAT = '%(asctime)s:::%(levelname)s:::%(message)s'
# logging.basicConfig(filename='practice.log') 

# logging.basicConfig(format='%(asctime)s %(message)s') ## this will not work to get time stamp 

ML_LOG_FORMAT  = '%(asctime)s:::%(levelname)s:::%(message)s'

'''
def doLoggingInML(file_, nn_ ):
    loggerObj = logging.getLogger('ML_LOGGER')
    loggerObj.setLevel(logging.INFO) 

    log_handler = logging.FileHandler('ML_LOG_FILE.LOG') 
    formatter   = logging.Formatter(ML_LOG_FORMAT) 
    log_handler.setFormatter(formatter) 
    loggerObj.addHandler( log_handler ) 


    df_ = pd.read_csv(file_)
    # print(df_.head()) 
    I, D = df_.drop(columns=['ICP_STATUS', 'FILE_PATH']) , df_['ICP_STATUS'].values 

    #split dataset into train and test data
    I_train, I_test, D_train, D_test = train_test_split(I, D, test_size=0.2, random_state=1) 
    knn = KNeighborsClassifier(n_neighbors = nn_ ) 
    loggerObj.info('Training with dataset started. Filename:' + file_ ) 
    knn.fit(I_train, D_train) 
    loggerObj.info('Training with dataset ended. Filename:' + file_ ) 
    model_accu = knn.score(I_test, D_test)
    print( model_accu ) 
    loggerObj.info('Training model accuracy: ' + str(model_accu) )
'''

def doLogging():
    # logging.basicConfig(filename='practice.log', level=logging.DEBUG, format=LOGFORMAT) :: working 
    logging.info('Before variables ... datetime not enabled ' )
    fName  = 'init.sls' 
    logging.debug('After variable ... datetime not enabled ' +  fName) 
    logging.warning('Now we have date time')   

def getLogging():
    ## logging with log object 
    loggerObj = logging.getLogger('EXAMPLE')
    # print(loggerObj.__dict__) 
    loggerObj.setLevel(logging.DEBUG) 

    file_handler = logging.FileHandler('practice.log') 
    formatter = logging.Formatter(LOGFORMAT) 
    file_handler.setFormatter(formatter) 
    loggerObj.addHandler(file_handler) 

    loggerObj.debug('Got the logger (debug) ... ')
    loggerObj.info('Got the logger (info) ... ')    
 

if __name__=='__main__':
    # doLogging() 
    getLogging() 