# Exercise: Forensics in Machine Learning Code 

## Setup 


1. run `docker pull akondrahman/sec-soft-edu-materials:latest` (takes 10 minutes on a Mac)
2. run `docker run -it --privileged <IMAGE_ID>   bash `, to find `IMAGE_ID` run `docker images -a`
3. run `cd /WORKSHOPS/WORKSHOP_2` 
4. run `nano ML.py` to see and edit content for `ML.py` 
5. run `python3 ML.py` if you want to execute the code 

## The Work 

Imagine this scenario: Dolly, a data science specialist at Tennessee Tech. University has written machine learning (ML) code in `ML.py`. The output is correct but she just learned about adverserial machine learning, which talks about how ML code can be attacked. She learned that 
ML models are susceptible to security issues:  

1. `poisoning attacks` that are introduced through passing in erroneous dataset files into ML code 
2. `model tricking` that are results of models that are being attacked, which gives erroneous results. Incorrect prediction performance is an indicator of ML models being attacked.  

Assist Dolly by writing logging code in the correct locations in `ML.py` with comments so that the two above-mentioned issues are logged for all provided ML examples. After writing the code, first, make sure it compiles. Second, put in comments to justify your code, save `ML.py`, and then push it to your repository. 