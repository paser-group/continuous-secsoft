'''
Akond Rahman 
Sep 04, 2020 
Friday 
'''
import pandas as pd 
from sklearn.model_selection import train_test_split
from sklearn.neighbors import KNeighborsClassifier

def doLoggingInML(file_, nn_ ):

    df_ = pd.read_csv(file_)
    # print(df_.head()) 
    I, D = df_.drop(columns=['ICP_STATUS', 'FILE_PATH']) , df_['ICP_STATUS'].values 

    #split dataset into train and test data
    I_train, I_test, D_train, D_test = train_test_split(I, D, test_size=0.2, random_state=1) 
    knn = KNeighborsClassifier(n_neighbors = nn_ ) 
    knn.fit(I_train, D_train) 
    model_accu = knn.score(I_test, D_test)
    print( model_accu ) 




if __name__=='__main__':
    malicious_dataset , wrong_neighbors  = 'ML_DATASET.csv' , 5
    doLoggingInML(malicious_dataset, wrong_neighbors) 