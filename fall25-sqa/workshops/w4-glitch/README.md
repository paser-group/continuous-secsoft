## COnfiguration Script Scanning with GLITCH 

### Installation 

- Visit https://github.com/sr-lab/GLITCH
- Create a virtual environment 
- Install the tool within the virtual environment using `python -m pip install -e .`
- Test out installation with `glitch --help`

### Execution 
- Run the tool for security analysis using `glitch --tech puppet --dataset   /Users/akondrahman/ostk-pupp/ `
- Inspect the output

### Tasks For You to Complete 

- Run the tool on `w4-puppet-scripts.zip` in a manner so that a CSV file is generated.  You can use `w4-scripts.tar.gz` if the zip file is creating problems. You may also download the files in `https://github.com/paser-group/continuous-secsoft/tree/master/fall25-sqa/workshops/w4-glitch/w4-puppet-scripts` if you are facing extraction problems.  
- Report the names and occurrences of the detected security-related issues in `weakness.txt` 
- Save the console output in `console.txt`
- Submit weakness.txt, the generated CSV file, and test.txt


- Deadline: Sep 30 2025, 11:59 PM CST 


### Rubric 

- Necessary content in `weakness.txt` [35%]
- Necessary content in `console.txt` [35%]
- The generated CSV file [30%]

 