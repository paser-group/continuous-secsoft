# Workshop-3: Random Fuzzer for Configuration Management

## Setup 


1. run `docker pull akondrahman/sec-soft-edu-materials:latest` (takes 10 minutes on a Mac)
2. run `docker run -it --privileged <IMAGE_ID>   bash`, to find `IMAGE_ID` run `docker images -a`
3. run `cd /WORKSHOPS/WORKSHOP_3` 
4. run `nano sklearn-install.yaml` to see and edit content for `sklearn-install.yaml` 
5. run `ansible-playbook -vvv sklearn-install.yaml --check` if you want to execute the code using Ansible 

## Background

Ansible is a configuration management tool that can execute a set of commands at scale. For example if you want to 
install Apache Tomcat server on 1,000 AWS instances then you can do it using a few lines of YAML code. 

In Ansible YAML files are specified using key value pairs ... for example in `sklearn-install.yaml`, `name` is a key and `numpy` and `scikit-learn` are values for the key `name` 

The YAML file specifies how to execute the `pip3` command using Ansible. Instead of manually doing `pip3` to install Python libraries, just run the YAMl script with Ansible and it will install everything you specify under `name`. For example, the script should install the following pip3 packages: *numpy*, *scikit-learn*, *scipy*, and *ZZZ*.  

## The Tasks 

You need to create a fuzzer in your favorite programming language. The fuzzer will generate unexpected strings that will be passed to the YAML script as configuration values. Then, once you are done generating unexpected strings run `ansible-playbook -vvv sklearn-install.yaml --check` to see if unexpected output are obtained. 

1. Write a program in your favorite programming langauge that 
 - 1.1 Loads the YAMl script in a suitable data structure ...  I prefer dictionaries ... pyyaml is a good library for loading YAML files in Python 
 - 1.2 Get the following keys (i) *name* under *pip*, (ii) *hosts*, and (iii) *become* 
 - 1.3 For each key get associated configuration value 
 - 1.4 Assign fuzzed value generated from your fuzzer for each key 
 - 1.5 Save the new key, value pair as a new YAML file and name the new YAML files as `sklearn-install.yaml`  
 - 1.6 Execute the new script with the following command  `ansible-playbook -vvv sklearn-install.yaml --check` 
2. Record the input and corresponding output for an unexpected behavior in `Workshop3-Answers.md`
3. Save your code and `Workshop3-Answers.md` in your course repository 
4. Complete `Mini-Workshop#3` on iLearn. Due Sep 17, 2020 8 PM CST 

## Tips  
1. Before jumping into coding try to understand the problem clearly. Not a lot of code to write but involves some thinking. 
2. To check unexpected behavior for *name* under *pip* you can do `pip3 install ABCDE12345`, where `ABCDE12345` is the fuzzed value from your fuzzer 
3. You can use the following simple fuzzer written in Python to get fuzzing data. No points will be deducted. 

```
def simpleRandomFuzzer(max_length=500, char_start=32, char_range=10):
    string_length = random.randrange(0, max_length + 1)
    out_ = ""
    for _ in range(0, string_length):
        out_ += chr(random.randrange(char_start, char_start + char_range))
    return out_
```

4. You can do Step#1 semi-automatically by plugging in random values manually and executing the YAMl file manually. However, 
you will lose 30% of your total points for the workshop.   


For questions please let me know. 