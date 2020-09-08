'''
Akond Rahman 
Sep 08, 2020 
Tuesday  
'''
import pandas as pd 
from sklearn.model_selection import train_test_split
from sklearn.neighbors import KNeighborsClassifier
import logging 
ML_LOG_FORMAT = "%(asctime)s:::%(levelname)s:::%(message)s"

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




if __name__=='__main__':
    malicious_dataset , wrong_neighbors  = 'ML_DATASET.csv' , 5
    doLoggingInML(malicious_dataset, wrong_neighbors) 