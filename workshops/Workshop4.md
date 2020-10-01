# Workshop-4: Taint Tracking in Data Analytics

## Setup 


1. run `docker pull akondrahman/sec-soft-edu-materials:latest` (takes 10 minutes on a Mac)
2. run `docker run -it --privileged <IMAGE_ID>   bash `, to find `IMAGE_ID` run `docker images -a`
3. run `cd /WORKSHOPS/WORKSHOP_4/` 
4. run `nano miner.py` to see and edit content for `miner.py` 
5. run `python3 miner.py` if you want to execute the code 

## The Work 

As showed in class taint tracking refers to tracking the flow of untrusted data. In this workshop you will track the flow of tainted data in `miner.py`. You will focus on three things:  

Step#1: manually explore the taint tracking flow of `/COVID19/REPOS/` and `/COVID19/FINAL_ISSUES.csv` in `miner.py`. Report and save your answers in `Workshop4-Answers.md`. 
Report full flow. Reporting of incompelte flow will result in reduction of points.   
Step#2: Write a Python program called `taint_tracker.py` that can automatically derive the taint tracking flow that you have derived manually in Step#1. The program must report the taint tracking flow automatically for both `/COVID19/REPOS/` and `/COVID19/FINAL_ISSUES.csv`. You are allowed to use libraries like `ast` or `astor`.     
Step#3: Write output generated from your `taint_tracker.py` program into `Workshop4-Answers.md`. 
Step#4: Save `taint_tracker.py` and `Workshop4-Answers.md` and push them in your repository. Complete Workshop#4 on iLearn. 

Point distribution: 
Step#1: 25% 
Step#2: 70% 
Step#3:  4% 
Step#4:  1% 

For questions please let me know. 