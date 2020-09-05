'''
Kubernetes Data Prep 
Akond Rahman 
Aug 26 2020 
'''

import os 
import csv 
import numpy as np
import sys
from git import Repo
import  subprocess
import time 
import  datetime 
import _pickle as pickle 
import pandas as pd 


def getBranch(proj_):
    branch_name = ''
    proj_branch = {'~/K8S_REPOS/GITLAB_REPOS/basic-microservice-for-learning':'Development', 
                   '~/K8S_REPOS/GITLAB_REPOS/koris':'dev', 
                   '~/K8S_REPOS/GITLAB_REPOS/stackgres':'development' 
                  } 
    if proj_ in proj_branch:
        branch_name = proj_branch[proj_]
    else:
        branch_name = 'master'
    return branch_name
def getYAMLFilesOfRepo(repo_dir_absolute_path):
    yaml_list =  []
    for root_, dirs, files_ in os.walk(repo_dir_absolute_path):
       for file_ in files_:
           full_p_file = os.path.join(root_, file_)
           if (os.path.exists(full_p_file)) :
             if (full_p_file.endswith('yml') or full_p_file.endswith('yaml')):
               yaml_list.append(full_p_file)
    return yaml_list 


def getRelPathOfFiles(all_yaml_param, repo_dir_absolute_path):
  common_path = repo_dir_absolute_path
  files_relative_paths = [os.path.relpath(path, common_path) for path in all_yaml_param]
  return files_relative_paths 

def getYAMLRelatedCommits(repo_dir_absolute_path, yamlListInRepo, branchName='master'):
  mappedList=[]
  track_exec_cnt = 0
  repo_  = Repo(repo_dir_absolute_path)
  all_commits = list(repo_.iter_commits(branchName))
  for each_commit in all_commits:
    track_exec_cnt = track_exec_cnt + 1

    cmd_of_interrest1  = 'cd ' + repo_dir_absolute_path + " ; "
    cmd_of_interrest2  = "git show --name-status " + str(each_commit)  +  "  | awk '/.yaml/ {print $2}'" + " ; "
    cmd_of_interrest3  = "git show --name-status " + str(each_commit)  +  "  | awk '/.yml/ {print $2}'" 
    cmd_of_interrest   = cmd_of_interrest1 + cmd_of_interrest2 + cmd_of_interrest3 
    commit_of_interest = str(subprocess.check_output(['bash', '-c', cmd_of_interrest])) #in Python 3 subprocess.check_output returns byte


    for yamlFile in yamlListInRepo:
      #   print(yamlFile, commit_of_interest)
      if yamlFile in commit_of_interest:

       file_with_path = os.path.join(repo_dir_absolute_path, yamlFile)
       mapped_tuple = (file_with_path, each_commit)
       mappedList.append(mapped_tuple)

  return mappedList  

def buildYAMLDataset(repo_path, mapping_tuple):
    full_tuple_list = []
    for tuple_ in mapping_tuple:

        file_ = tuple_[0]
        commit_ = tuple_[1]
        msg_commit =  commit_.message 

        msg_commit = msg_commit.replace('\r', ' ')
        msg_commit = msg_commit.replace('\n', ' ')
        msg_commit = msg_commit.replace(',',  ';')    
        msg_commit = msg_commit.replace('\t', ' ')
        msg_commit = msg_commit.replace('&',  ';')  
        msg_commit = msg_commit.replace('#',  ' ')
        msg_commit = msg_commit.replace('=',  ' ')      

        commit_hash = commit_.hexsha

        timestamp_commit = commit_.committed_datetime
        str_time_commit  = timestamp_commit.strftime("%Y-%m-%dT%H-%M-%S") 

        temp_tup = (repo_path, commit_hash, str_time_commit, file_, msg_commit  )
        # print(temp_tup) 
        full_tuple_list.append(temp_tup)
    return full_tuple_list 




def runMiner(repo_list, root_repo ):
    all_dataset_list = []
    for repo_dir in repo_list: 
        repo_path = root_repo + repo_dir 
        print(repo_path) 
        repoBranch = getBranch(repo_path) 
        all_yaml_files_in_repo = getYAMLFilesOfRepo(repo_path)  
        rel_path_yaml_files    = getRelPathOfFiles(all_yaml_files_in_repo, repo_path)
        yaml_commits_in_repo   = getYAMLRelatedCommits(repo_path, rel_path_yaml_files, repoBranch)
        dataset_yaml_list      = buildYAMLDataset( repo_path, yaml_commits_in_repo  )
        all_dataset_list       = all_dataset_list + dataset_yaml_list 
    df_ = pd.DataFrame( all_dataset_list ) 
    # print(df_.head())
    df_.to_csv('FULL_KUBERNETES_MANIFEST_COMMIT_DATASET.csv', header=['REPO', 'HASH', 'TIMESTAMP', 'FILE_PATH', 'MESSAGE_TEXT'], index=False, encoding='UTF-8')     




if __name__=='__main__':
    root_repo = ''
    gitlab_repos = 'gitlab.k8s.repos.csv' 

    df_ = pd.read_csv(gitlab_repos)
    repo_list = np.unique( df_['NAME'].tolist() )
    runMiner( repo_list, root_repo ) 
