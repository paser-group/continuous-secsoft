## Configuration Validation with CUE 

We will discuss and validate configuration files with a tool called [CUE](https://cuelang.org/). 

### Background 

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


#### In-class Activity

- [Install CUE](https://cuelang.org/docs/install/) 
- run `cue vet sample.yaml  sample-check.cue`

### Tasks For You to Complete 

- You will use the `check.cue` file and report:
  - the violations reported by CUE for `e5.yaml`
  - fix the values within `e5.yaml` to get rid of the errors detected by CUE 
- Submit your modified YAML file and a screenshot showcasing the output generated from the CUE tool 

#### Rubric 

- The updated YAML file `e5.yaml` : 55%
- Screenshots for executing CUE: 45%

### References
- https://cuelang.org/docs/integrations/yaml/