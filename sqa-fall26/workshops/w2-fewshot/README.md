## Workshop: Use Few Shot Prompting for Code Translation 

### Background 

Few shot is a prompting technique where examples are provided in regards to expected output from the large language model (LLM). 
Unlike, zero shot prompting, where only instructions are provided, in few shot prompting, the expected output is also provided. 
Few shot prompting has shown for code translation. You are expected to gain some hands-on experience on few shot prompting. 

### Steps:

Use the following prompt to familiarize yourself on few shot prompting. This is an example of few show prompting, as it provides the expected input and output pairs.

#### Step-1: Few Shot Prompt Practice

You are an efficient code translator. Please use the following examples as input-output combinations to familiarize yourself.

###### Example-1
Input:
```
#include <stdio.h>

int doDiv(a, b) {
    int int_result;
    int_result = a / b;
    return int_result;
}
```
Output:
```
def doDiv(x, y):
    return x / y 
```
###### Example-2
Input:
```
#include <stdio.h>
int doMul(a, b) {
    int int_result;
    int_result = a * b;
    return int_result;
}
```
Output:
```
def doMul(x, y):
    return x * y 
```
###### Example-3
Input:
```
#include <stdio.h>

int doAdd(a, b) {
    int int_result;

    int_result = a + b;

    return int_result;
}
```
Output:
```
def doAdd(x, y):
    return x + y 
```

Once you are familiar, please generate the Python version of the following code snippet written in C:

```
#include <stdio.h>
int doSub(a, b) {
    int int_result;

    int_result = a - b;

    return int_result;
}
```

#### Step-2: Few Shot Prompt Exercise

1. Develop a few shot prompt to translate the following C code into Python:

```
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX_LINE_SIZE 10

int main() {
    FILE *file = fopen("data.csv", "r");
    
    if (file == NULL) {
        perror("Unable to open file");
        return 1;
    }

    char line[MAX_LINE_SIZE];
    while (fgets(line, sizeof(line), file)) {
        
        line[strcspn(line, "\n")] = 0;
        char *token = strtok(line, ",");
        int column = 0;

        while (token != NULL) {
            printf("Row %d, Col %d: %s\n", column / 3, column % 3, token);
            token = strtok(NULL, ",");
            column++;
        }
    }
    fclose(file);
    return 0;
}
```
2. Use ChatGPT or Google Gemini to execute the developed few shot prompt. 
3. Compare the output of the C code above and the generated Python code. Provide the comparison in a table. 

#### Rubric

- Few shot prompt used: 25% 
- Output of C code: 25%
- Output of generated Python code: 25%
- The table that demonstrates the comparison: 25%