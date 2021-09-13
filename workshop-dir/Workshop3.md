# Workshop-3: Miniature Security Static Analysis for Ansible Manifests

`Due: TODO (AoE) `



### Tasks 

1. Open up the `Workshop3.values.yaml` file to find out security weaknesses. To understand what security weakness you only need to look at Section 3.2 of this paper: https://arxiv.org/pdf/1907.07159.pdf 
2. After determining what types of security weaknesses occur for what variables in `Workshop3.values.yaml`, inspect where the variables appear in `Workshop3.play1.yaml` and `Workshop3.play2.yaml`. 
3. Write an automated program that can first find all security weaknesses in `Workshop3.values.yaml` , then also report which code elements in `Workshop3.play1.yaml` and `Workshop3.play2.yaml` use these security weaknesses. You program should report both variables for which security weaknesses appear, and variables in `Workshop3.play1.yaml` and `Workshop3.play2.yaml` that use these security weaknesses. Pythonistas can use [PyYAML](https://pypi.org/project/PyYAML/). Non-Python users can use [SnakeYAML](https://bitbucket.org/asomov/snakeyaml/src/master/) for parsing YAML files. Use your knowledge of def-chain relationships to understand what code elements use the security weaknesses in `Workshop3.values.yaml`. 
4. Once completed please fill out this survey: https://forms.office.com/r/17Bd18T2xs. This counts 5% of the total grade for the workshop. 


### Expected Output 
1. A Markdown file that lists all security weaknesses in `Workshop3.values.yaml` file. 
2. Source code files that can perform Step#3 automatically without syntax errors. Do not embed code into your Markdown files. The generated output should look like this:
```
Security weakness name: AAA
Security weakness location: Variable 'X' in line# '100'
Security weakness usage: Play name 'ABC' in `Workshop3.play1.yaml` 
```