## Workshop - Greybox Fuzzing with AFL++

AFL++ is a very popular fuzzing [tool](https://aflplus.plus/).
Initially it originated from the American Fuzzy Lop fuzzer created by Michal Zalewski. 
It includes:

- A fuzzer with many mutators and configurations: afl-fuzz.
- Different source code instrumentation modules: LLVM mode, afl-as, GCC plugin.
- Different binary code instrumentation modules: QEMU mode, Unicorn mode, QBDI mode.
- Utilities for testcase/corpus minimization: afl-tmin, afl-cmin.

### How To Get Started 

Execute the following commands on the terminal: 

- docker pull docker pull akondrahman/fuzz4life
- docker run --rm -it 10862cc87cd3 bash
- cd WORKSHOP/greybox/
- nano fuzzing-inputs/head
- cd AFLplusplus/
- afl-clang-fast -g -w ../simple.c  -o simple
- afl-fuzz -i ../fuzzing-inputs -t 10000  -o simple-output ./simple
- Keep an eye on `state` and the output in general 
- ls -al `ls -al  simple-output/default/`


### Tasks For You To Do 

- Repeat the steps shown in class for `w11.c`
- Save and submit the screenshot of your AFL++ execution screen
- Save and submit the output folder generated as part of the exercise
- Report the number of crashes and hangs by the tool for the program  in a text file 
- Due: Nov 14, 2025, 11:59 PM CST

