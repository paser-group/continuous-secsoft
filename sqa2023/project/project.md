## Project for Software Quality Assurance (CSC 5710/6710) 

### Objective 

The objective of this project is to integrate software quality assurance activities into an existing Python project. Whatever we learned from our workshops will be integrated in the project. 

### Activities 

##### Group Activities 

1. Unpack the project `KubeSec.zip`. (1%)
2. Upload project as a GitHub repo on `github.com`. Format of the repo name is `TEAMNAME-SQA2023-AUBURN`  (2%)
3. In your project repo create `README.md` listing your team name and team members. (2%)
4. Apply the following activities related to software quality assurance:

   - 4.a. Create a Git Hook that will run and report all security weaknesses in the project in a CSV file whenever a Python file is changed and committed. (10%)

   - 4.b. Create a `fuzz.py` file that will automatically fuzz 5 Python methods of your choice. Report any bugs you discovered by the `fuzz.py` file. `fuzz.py` will be automatically executed from GitHub actions. (20%)

   - 4.c. Integrate forensics by modifying 5 Python methods of your choice. (20%)

5. Report your activities and lessons learned. Put the report in your repo as `REPO.md` (3%)   

##### Individual Activities 

1. Use `vault4paper.py` to remove hard-coded secrets in all YAML files and Puppet files respectively, in the `Ansible` and `Puppet` directories. (40%)

2. Complete the survey related to secrets: https://forms.office.com/r/94Cjxirm1f (2%)

### Deliverables 

##### Group 

1. A repo hosted on GitHub. Name of the repo will be `TEAMNAME-SQA2023-AUBURN` 
2. Full completion of all activities as recorded on the GitHub repository 
3. Report describing what activities your performed and what you have learned 
4. Logs/screenshots that show execution of forensics, fuzzing, and static analysis 

##### 

1. Upload Ansible and Puppet scripts after removal of secrets on CANVAS (`Individual-Project-Task`)

### Deadline to Complete All Activities 

December 01, 2023 