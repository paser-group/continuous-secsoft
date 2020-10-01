import pandas as pd 
import numpy as np 


def compareStuff(shamim, alex):
    one_way = np.unique( list(set(shamim) - set(alex)) )
    print('Shamim first:' + str(len(one_way) ) )
    print('*'*50)
    two_way = np.unique( list(set(alex) - set(shamim)) )
    print( 'Alex first:' + str( len(two_way) ) )
    print('*'*50)
    common = [y_ for y_ in alex if y_ not in shamim] 
    print( 'Common:' + str( len(common) ) )
    print('*'*50)
    intersection = np.unique( [x_ for x_ in shamim if x_ not in alex] )
    more_ = np.unique([ z_ for z_ in intersection if z_ not in two_way ])
    print(len(one_way)) 
    for z_ in common :
        print(z_) 

if __name__=='__main__':
    full_csv = '/Users/arahman/Documents/OneDriveWingUp/OneDrive-TennesseeTechUniversity/Research/Kubernetes/Kubernetes_SLR_Disagreements.csv'
    full_df  = pd.read_csv(full_csv) 

    paper_shamim = np.unique(full_df['SHAMIM_ACADEMIC'].tolist() )
    paper_alex   = np.unique(full_df['ALEX_ACADEMIC'].tolist() ) 

    artifact_shamim = np.unique(full_df['SHAMIM_ARTIFACTS'].tolist() )
    artifact_alex   = np.unique(full_df['ALEX_ARTIFACTS'].tolist() )        

    # compareStuff(paper_shamim, paper_alex) 		
    # compareStuff(artifact_shamim, artifact_alex) 	