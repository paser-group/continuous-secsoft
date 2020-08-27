from google.cloud import bigquery
import os
from google.cloud.bigquery.client import Client
import pandas as pd 
import csv 
import subprocess
import numpy as np
import shutil
from git import Repo
from git import exc 
import time 
import pandas as pd 
import numpy as np 
from git import Repo
from git import exc 
from datetime import datetime
import subprocess
from collections import Counter

os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = 'PATH2JSON'

def getBranch(path):
    dict_ = {'eShopOnContainers':'dev', 
             'scality@metalk8s':'development/2.6'
    } 
    if path in dict_:
        return dict_[path] 
    else:
        return 'master' 

def getDurationAndCommits(full_path_to_repo, branchName='master'):
    all_commits = []
    all_time_list = []
    if os.path.exists(full_path_to_repo):
        repo_  = Repo(full_path_to_repo)
        try:
           all_commits = list(repo_.iter_commits(branchName))   
        except exc.GitCommandError:
           print('Skipping this repo ... due to branch name problem', full_path_to_repo )
        for commit_ in all_commits:
                timestamp_commit = commit_.committed_datetime
                str_time_commit  = timestamp_commit.strftime('%Y-%m-%d') ## date with time 
                all_time_list.append( str_time_commit )
    all_day_list   = [datetime(int(x_.split('-')[0]), int(x_.split('-')[1]), int(x_.split('-')[2]), 12, 30) for x_ in all_time_list] + [datetime(int(2019), int(12), int(15), 12, 30)]
    min_day        = min(all_day_list) 
    max_day        = max(all_day_list) 
    ds_life_days   = days_between(min_day, max_day)
    ds_life_months = round(float(ds_life_days)/float(30), 5)

    return  len(all_commits) , ds_life_days, ds_life_months 

def getAllCommits(all_repos):
    total_commits  = 0 
    total_devs     = 0 
    all_days       = []
    for repo_ in all_repos:
        branchName = getBranch(repo_) 
        dev_cnt, com_cnt, _days = getDevDayCount(repo_, branchName)   
        total_commits = total_commits + com_cnt 
        total_devs    = total_devs + dev_cnt 
        all_days      = all_days + _days 
    
    min_day        = min(all_days) 
    max_day        = max(all_days) 

    return min_day, max_day, total_commits, total_devs 


def makeChunks(the_list, size_):
    for i in range(0, len(the_list), size_):
        yield the_list[i:i+size_]

def cloneRepo(repo_name, target_dir):
    cmd_ = "git clone " + repo_name + " " + target_dir 
    try:
       subprocess.check_output(['bash','-c', cmd_])    
    except subprocess.CalledProcessError:
       print('Skipping this repo ... trouble cloning repo:', repo_name )

def dumpContentIntoFile(strP, fileP):
    fileToWrite = open( fileP, 'w')
    fileToWrite.write(strP )
    fileToWrite.close()
    return str(os.stat(fileP).st_size)


def deleteRepo(dirName, type_):
    print(':::' + type_ + ':::Deleting ', dirName)
    try:
        if os.path.exists(dirName):
            shutil.rmtree(dirName)
    except OSError:
        print('Failed deleting, will try manually')             


def getElixirUsage(path2dir): 
    usageCount, elixir_file_list = 0, []
    for root_, dirnames, filenames in os.walk(path2dir):
        for file_ in filenames:
            full_path_file = os.path.join(root_, file_) 
            if(os.path.exists(full_path_file)):
                if (file_.endswith('ex')  or file_.endswith('exs') )  :
                    elixir_file_list.append( file_  )
    usageCount = len( elixir_file_list ) 
    return usageCount , elixir_file_list                         

def cloneRepos(repo_list, elixirThreshold = 0.1): 
    counter = 0     
    str_ = ''
    for repo_batch in repo_list:
        for repo_ in repo_batch:
            counter += 1 
            print('Cloning ', repo_ )
            dirName = '/ELIXIR_REPOS/' + repo_.split('/')[-3] + '@' + repo_.split('/')[-2] ## '/' at the end messes up the index 
            cloneRepo(repo_, dirName ) 
            all_fil_cnt = sum([len(files) for r_, d_, files in os.walk(dirName)])
            all_fil_cnt = all_fil_cnt + 1 
            elixir_cnt, elixir_list = getElixirUsage( dirName )
            elixir_perc = float(elixir_cnt) / float(all_fil_cnt) 
            if (all_fil_cnt <= 0):
               deleteRepo(dirName, 'NO_FILES')
            elif (elixir_perc <= elixirThreshold):
               deleteRepo(dirName, 'LOW_ELIXIR_THRESHOLD')
            print('#'*100 )
            str_ = str_ + str(counter) + ',' +  repo_ + ',' + dirName + ','  + str(elixir_perc) + ',' + str(all_fil_cnt)  + '\n'
            print("So far we have processed {} repos".format(counter) )
            if((counter % 100) == 0):
                dumpContentIntoFile(str_, 'elixir_tracker_completed_repos.csv')
            elif((counter % 1000) == 0):
                print(str_)                
            print('#'*100)

def giveTimeStamp():
  tsObj = time.time()
  strToret = datetime.datetime.fromtimestamp(tsObj).strftime('%Y-%m-%d %H:%M:%S')
  return strToret


def fetchElixirFromBigQuery():
    ls_ = []
    client = Client()
    query = """
        SELECT * FROM LOL.ELIXIR_BIGQUERY ; 
    """
    query_job = client.query(query)  
    for row in query_job:
        print("repo_name:{}".format(row[0]))
        ls_.append( (row[0] , "https://github.com/"  + row[0] + "/" )  )
    df_ = pd.DataFrame(ls_) 
    df_.to_csv('PRELIM_ELIXIR_REPOS.csv', header=['REPO_ID', 'GITHUB_URL' ], index=False, encoding='utf-8')        


def getRedactedRepoList(list_param):
    already_df    = pd.read_csv('../../../ProjectExploration/DONE_ALREADY_REPOS.csv')
    already_done  = list( np.unique( already_df['URL']  ) )
    list_output   = [x_ for x_ in list_param if x_ not in already_done] 
    return list_output 

def getDevEmailForCommit(repo_path_param, hash_):
    author_emails = []

    cdCommand     = "cd " + repo_path_param + " ; "
    commitCountCmd= " git log --format='%ae'" + hash_ + "^!"
    command2Run   = cdCommand + commitCountCmd

    author_emails = str(subprocess.check_output(['bash','-c', command2Run]))
    author_emails = author_emails.split('\n')
    author_emails = [x_.replace(hash_, '') for x_ in author_emails if x_ != '\n' and '@' in x_ ] 
    author_emails = [x_.replace('^', '') for x_ in author_emails if x_ != '\n' and '@' in x_ ] 
    author_emails = [x_.replace('!', '') for x_ in author_emails if x_ != '\n' and '@' in x_ ] 
    author_emails = [x_.replace('\\n', ',') for x_ in author_emails if x_ != '\n' and '@' in x_ ] 
    try:
        author_emails = author_emails[0].split(',')
        author_emails = [x_ for x_ in author_emails if len(x_) > 3 ] 
        author_emails = list(np.unique(author_emails) )
    except IndexError as e_:
        pass
    return author_emails  

def days_between(d1_, d2_): ## pass in date time objects, if string see commented code 
    # d1_ = datetime.strptime(d1_, "%Y-%m-%d")
    # d2_ = datetime.strptime(d2_, "%Y-%m-%d")
    return abs((d2_ - d1_).days)


def getDevDayCount(full_path_to_repo, branchName='master', explore=1000):
    repo_emails = []
    all_commits = []
    repo_emails = []
    all_time_list = []
    if os.path.exists(full_path_to_repo):
        repo_  = Repo(full_path_to_repo)
        try:
           all_commits = list(repo_.iter_commits(branchName))   
        except exc.GitCommandError:
           print('Skipping this repo ... due to branch name problem', full_path_to_repo )
        for commit_ in all_commits:
                commit_hash = commit_.hexsha

                emails = getDevEmailForCommit(full_path_to_repo, commit_hash)
                repo_emails = repo_emails + emails

                timestamp_commit = commit_.committed_datetime
                str_time_commit  = timestamp_commit.strftime('%Y-%m-%d') ## date with time 
                all_time_list.append( str_time_commit )

    else:
        repo_emails = [ str(x_) for x_ in range(10) ]
    all_day_list   = [datetime(int(x_.split('-')[0]), int(x_.split('-')[1]), int(x_.split('-')[2]), 12, 30) for x_ in all_time_list] + [datetime(int(2019), int(12), int(15), 12, 30)]
    min_day        = min(all_day_list) 
    max_day        = max(all_day_list) 
    ds_life_days   = days_between(min_day, max_day)
    ds_life_months = round(float(ds_life_days)/float(30), 5)
    repo_emails = np.unique(repo_emails) 
    return len(repo_emails) , len(all_commits) , ds_life_days, ds_life_months 


def checkFilteringStatus(file_path_elixir_status):
    all_list = []
    count    = 0 
    df_   = pd.read_csv(file_path_elixir_status)
    repos = np.unique( df_['PATH'].tolist()  )
    for dirName in repos:
      if os.path.exists(dirName):
        count += 1
        print(dirName)  
        dev_count, all_file_count, elixir_count  = 0 , 0 , 0 
        all_file_count                                 = sum([len(files) for r_, d_, files in os.walk(dirName)]) 
        elixir_count, elixir_file_list                 = getElixirUsage(dirName) 
        dev_count, commit_count, age_days, age_months  = getDevDayCount( dirName )
        # commit_count, age_days, age_months  = getDurationAndCommits( dirName )
        tup = ( count,  dirName, elixir_count, dev_count, all_file_count, commit_count, age_months)
        print(tup) 
        all_list.append( tup ) 
        if dev_count < 5: 
            deleteRepo(dirName, 'LOW_DEV_THRESHOLD')
        print('*'*10)
        temp_df = pd.DataFrame( all_list )
        temp_df.to_csv('TEMP_DEVS_THRESHOLD_BREAKDOWN.csv', header=['INDEX', 'DIR', 'ELIXIR_COUNT', 'DEV_COUNT', 'ALL_FILE_COUNT', 'COMMITS', 'DURA_MONTHS'], index=False, encoding='utf-8') 
    full_df = pd.DataFrame( all_list ) 
    full_df.to_csv('DEVS_THRESHOLD_BREAKDOWN.csv', header=['INDEX', 'DIR', 'ELIXIR_COUNT', 'DEV_COUNT', 'ALL_FILE_COUNT', 'COMMITS', 'DURA_MONTHS'], index=False, encoding='utf-8') 



def checkForkStatus(file_path_elixir_status):
    count    = 0 
    df_   = pd.read_csv(file_path_elixir_status)
    repos = np.unique( df_['PATH'].tolist()  )
    for dirName in repos:
      json_content  = '' 
      if os.path.exists(dirName):
        repo_df  = df_[df_['PATH']==dirName] 
        repo_url = repo_df['URL'].tolist()[0]
        repo_json = repo_url.replace('https://github.com/', '').replace('/', '@')
        repo_json = '/Users/arahman/Documents/OneDriveWingUp/OneDrive-TennesseeTechUniversity/Teaching/Fall2020/course-repo/continuous-secsoft/project_exploration/JSONS/' + repo_json[:-1] + '.json'
        if os.path.exists(repo_json):
            with open(repo_json, 'r') as file_:
                json_content = file_.read()
                if '"fork": false,' in json_content:
                    print("{} is a non-clone repository".format(dirName)) 
                    count += 1
                else:
                    deleteRepo(dirName, 'CLONED_REPOSITORY')
        print('*'*10)
    print('Total non-cloned repos are:', count) 


def checkCIStatus(file_path_elixir_status):
    count    = 0 
    df_   = pd.read_csv(file_path_elixir_status)
    repos = np.unique( df_['PATH'].tolist()  )
    for dirName in repos:
      if os.path.exists(dirName):
        print(dirName)  
        ci_list = []
        for root_, dirnames, filenames in os.walk(dirName): 
            for file_ in filenames:
                full_path_file = os.path.join(root_, file_) 
                if( '.travis.yml' in full_path_file   ):        
                            ci_list.append(full_path_file)
        if (len(ci_list) > 0):
            count += 1 
        else: 
            deleteRepo(dirName, 'NO_TRAVIS_CI')                         
    print('Repos with CI:', count) 



if __name__=='__main__':
    # fetchElixirFromBigQuery() 
    # 
    # repos_df = pd.read_csv('../../../ProjectExploration/PRELIM_ELIXIR_REPOS.csv')
    # list_    = repos_df['GITHUB_URL'].tolist()
    # list_ = np.unique(list_)
    # list_ = getRedactedRepoList( list_ ) 
    # print('Repos to download:', len(list_)) 
    # ## need to create chunks as too many repos 
    # chunked_list = list(makeChunks(list_, 1000))  ### list of lists, at each batch download 1000 repos 
    # cloneRepos(chunked_list)

    # checkFilteringStatus('/Users/arahman/Documents/OneDriveWingUp/OneDrive-TennesseeTechUniversity/Teaching/Fall2020/ProjectExploration/Elixir/FULL_ELIXIR_THRESHOLD_BREAKDOWN.csv') 

    # checkForkStatus('/Users/arahman/Documents/OneDriveWingUp/OneDrive-TennesseeTechUniversity/Teaching/Fall2020/ProjectExploration/Elixir/FULL_ELIXIR_THRESHOLD_BREAKDOWN.csv') 


    checkCIStatus('/Users/arahman/Documents/OneDriveWingUp/OneDrive-TennesseeTechUniversity/Teaching/Fall2020/ProjectExploration/Elixir/FULL_ELIXIR_THRESHOLD_BREAKDOWN.csv') 

    '''
    All: 7,858
    At least 10% Elixir: 4,885
    Nuthan : 1,151
    Devs >= 5: 806   
    Non-cloned repos: 696 
    With Travis CI: 513
    '''