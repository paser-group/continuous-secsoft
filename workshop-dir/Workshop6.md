## Workshop #6: System Calls 

**Due date: `, AoE`**


### Tasks 

1. Install Docker 
2. On your terminal type 


> docker pull akondrahman/ansi.trace.miner # taked 6 minutes on my computer 
> docker images -a # to get image ID
> docker run --cap-add=SYS_PTRACE  -it <IMAGE_ID>   bash
> cd /WORKSHOP_STRACE/ 
> ls -al 
> strace -h 
> strace -tT python3 buggy.py 2> buggy-python.txt 
> strace -tT python3 neutral.py 2> neutral-python.txt 	





3. Write a program that will parse the two text files, and for both text files report 

> Each of the unique system call names, their count, and time spent in each system call, on average 

### Expected Output

> output-buggy-python.txt 
```
read,100,50
write,5.1,10
...
```

> output-neutral-python.txt 
```
read,150,1
read,15,25
...
```

### Deliverables 

1. Code in your repository 
2. Output of your program in two separate CSV files for both `.txt` files. 
3. Put your repository on iLearn (`Assignments/System Calls Workshop`). 

### References: 

1. Strace manual, https://man7.org/linux/man-pages/man1/strace.1.html 