# Workshop-8: Security Scanning of Docker Images

## Due date `Nov 08, 2021 (Monday) AoE`

## The Work 

1. Create an account on `https://hub.docker.com/`, and use your credientials to sign in. 
2. `docker pull akondrahman/slic_ansible`
3. `docker scan --json <IMAGEID>`. Run `docker images -a` to get `IMAGEID`
4. Write a program in your favorite language that uses the collected output from Step#2 and creates a CSV file with the following fields: 
 - `CVE-ID`: CVE ID of a vulnerability 
 - `DESCRIPTION`: Description of the vulnerability 
 - `SEVERITY`: Severity of the vulnerability 


The output CSV file will look like similar to this: 
```
CVE-ID,DESCRIPTION,SEVERITY
CVE-2020-1350,"Wormable vulnerabilities have the potential to spread via malware between vulnerable computers without user interaction. Windows DNS Server is a core networking component. While this vulnerability is not currently known to be used in active attacks, it is essential that customers apply Windows updates to address this vulnerability as soon as possible.", HIGH
```
5. Save generated CSV file in your repository along with the source code.
6. Put your repository link on the iLearn assignemnt `Docker Security: Workshop`




For questions please let me know. 

