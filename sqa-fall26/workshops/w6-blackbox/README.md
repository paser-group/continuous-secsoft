# Blackbox Testing With A Binary


### Tasks in Class


- docker pull akondrahman/fuzz4life
- docker run --rm -it <IMAGEID> bash
- cd /WORKSHOP/blackbox
- ls -al dist/
- ./dist/FileOpener <PATH2THEFILE> , we will use `simple.txt`


### Tasks For You To Do 

- Generate five test inputs using a computer program that will lead to crashes for the binary `FileOpener`. A crash is defined as an abrupt termination of a computer program in response to an input.


### Deliverables 
- Your test cases as one or multiple files : 40% 
- Your program that generates the test cases : 30%
- Your crashes : 30% 