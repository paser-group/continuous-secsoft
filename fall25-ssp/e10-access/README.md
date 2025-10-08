## Access control assignment 

### Overview of the Data

The spreadsheet `data.xlsx` contains data for access control for 250 users across 7 files. The format of storing data is in the `access control matrix` format. Any cell with no entries means that the user has NO permissions for the file. For example, `u249` has no permissions for any of the mentioned files in the spreadsheet. 

### Tasks for you to do 

- 1. Write a function/method to read the data in `data.xlsx` using a standard library 
- 2. Using the data answer the following queries: 
  - 2.i. The number of users who has `777` permission for all files
  - 2.ii. The number of users who has `777` permission for at least with one file   
  - 2.iii. The number of users who has `444` permission for all files
  - 2.iv. The number of users who has `444` permission for at least with one file    
  - 2.v. The number of users who has read permission for at least one file
  - 2.vi. The number of users who has NO permission for all files      
- 3. Construct a hashmap to store the users' and their access control permissions for users who have permission for at least 2 files. 
- 4. Export the hashmap to a YAML file.  


### Rubric and Deliverables 

- Function/method to read the data in the spreadsheet [10%]
- 6 separate functions/methods to answer the 6 queries [60%]
- Code to implement hashmap [20%]
- Generated YAML file [2%]
- Code to generate YAML file [8%]