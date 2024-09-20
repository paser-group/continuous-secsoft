## Workshop 5

## Workshop Name: Configuration Validation with CUE

## Description 

We will discuss and validate configuration files with a tool called [CUE](https://cuelang.org/). 

## Targeted Courses 

Software Quality Assurance 

## Activities 

### Pre-lab Content Dissemination 

Similar to software source code configuration files need to be validated. We will use a tool called `CUE` that automatically find violations of checks. We will observe that by using simple commands and two source code files we can automatically check for violations. We will start by two files: `sample-check.cue` and `sample.yaml`. The `.cue` file provides the checks that need to be specified. The `.yaml` file is the configuration file that needs to be inspected. 


#### Content in `sample-check.cue` file

We are inspecting two checks: 

- if minimum is not defined then assign zero 

```
min?: *0 | number
```

- must be greater than the minimum number if minimum is defined 
```
max?: number & >min
```

#### Content in `sample.yaml` file 

```
# sample.yaml
min: 5
max: 10
---
min: 10
max: 5
```

#### Content in `sample-check.cue` 

```
min?: *0 | number    // 0 if undefined
max?: number & >min  // must be strictly greater than min if defined.
```


### In-class Hands-on Experience 

- [Install CUE](https://cuelang.org/docs/install/) 
- run `cue vet sample.yaml  sample-check.cue`
- Demo will be recorded and shared on CANVAS (Zoom). 

### Workshop 5 (Post Lab Experience) 

- For this part of the workshop you will use the `check.cue` file and report:
  - the violations reported by CUE for `w5.yaml`
  - fix the values within `w5.yaml` to get rid of the errors detected by CUE 
- Submit your modified YAML file and a screenshot showcasing the output generates from the CUE tool on CANVAS @ `Workshop 5` 
- Complete survey: https://auburn.qualtrics.com/jfe/form/SV_1MFYBbmspTQKibA
- Due: Sep 30, 2024

#### Rubric 

- YAML file : 50%
- Screenshot: 40%
- Survey: 10%

### References
- https://cuelang.org/docs/integrations/yaml/