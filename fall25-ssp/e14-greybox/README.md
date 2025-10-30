## Workshop - Greybox Fuzzing with AFL++

AFL++ is a very popular fuzzing [tool](https://aflplus.plus/).
Initially it originated from the American Fuzzy Lop fuzzer created by Michal Zalewski. 
It includes:

- A fuzzer with many mutators and configurations: afl-fuzz.
- Different source code instrumentation modules: LLVM mode, afl-as, GCC plugin.
- Different binary code instrumentation modules: QEMU mode, Unicorn mode, QBDI mode.
- Utilities for testcase/corpus minimization: afl-tmin, afl-cmin.

### If You Want to Install AFL++ On Your Ubuntu Machine/Container 

- apt-get update
- apt-get install -y build-essential python3-dev automake cmake git flex bison libglib2.0-dev libpixman-1-dev python3-setuptools cargo libgtk-3-dev
- apt-get install -y lld-14 llvm-14 llvm-14-dev clang-14 || sudo apt-get install -y lld llvm llvm-dev clang
- apt-get install -y gcc-$(gcc --version|head -n1|sed 's/\..*//'|sed 's/.* //')-plugin-dev libstdc++-$(gcc --version|head -n1|sed 's/\..*//'|sed 's/.* //')-dev
- apt-get install -y ninja-build
- apt-get install -y cpio libcapstone-dev
- apt-get install -y wget curl 
- apt-get install -y python3-pip
- git clone https://github.com/AFLplusplus/AFLplusplus
- cd AFLplusplus
- make distrib
- make install
- CC=afl-clang-fast AFL_HARDEN=1 make

### How To Get Started (Demonstration in Class)

Execute the following commands on the terminal: 

- `docker pull akondrahman/fuzz4life`
- `docker run --rm -it <IMAGEID> bash`
- `cd WORKSHOP/greybox/`
- `nano fuzzing-inputs/head`
- `cd AFLplusplus/`
- `afl-clang-fast -g -w ../simple.c  -o simple`
- `afl-fuzz -i ../fuzzing-inputs -t 10000  -o simple-output ./simple`
- Keep an eye on `state` and the output in general 
- `ls -al simple-output/default/`


### Tasks For You To Do 

- Repeat the steps shown in class for `e14.c`
- Save and submit the screenshot of your AFL++ execution screen
- Save and submit the output folder generated as part of the exercise
- Report the number of crashes and hangs by the tool for the program  in a text file 
- Due: Nov 20, 2025, 11:59 PM CST