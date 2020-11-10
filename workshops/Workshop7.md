# Workshop-7: Hint of DevSecOps:: Trigger Static Analysis Upon Code Commit 

## Goal 

In DevSecOps, practitioners prefer automated pipelines for secuirty analysis. Instead of asking practitioners to look for security problems themseleves, tools should do that for them. 

In that spirit, you will build a mini tool that automatically runs static secuirty analysis for `ompi`, a popular framework used in parallel computing and developed in C. For this you will use `cppcheck` and `git hooks`. The idea is your mini tool will help in idnetifying secuirty problems automatically for practitioners who develop and use `ompi`.  

## Setup 


1. Install `http://cppcheck.sourceforge.net/`  on your computer 
2. Clone `https://github.com/open-mpi/ompi.git` on your computer 
3. Familiarize yourself with `git hooks` using any or all of the following links: 
   - https://www.digitalocean.com/community/tutorials/how-to-use-git-hooks-to-automate-development-and-deployment-tasks
   - https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks 
   - https://githooks.com/ 
4. Familiarize yourself with `cppcheck` using any or all of the following links: 
   - https://linux.die.net/man/1/cppcheck 
   - http://cppcheck.sourceforge.net/manual.pdf 
   - https://www.mankier.com/1/cppcheck 


## The Work 

1. First identify the file that needs to be modified so that upon performing a `git commit` a static analysis run is triggered. No need to take care of `git push`, just focus on `git commit`. 

2. In that file write some bash code so that upon commit of any file within the repsoitory (`ompi`), `cppcheck` should analyze the entire `ompi` repository and report the results in a file called `ALL_ERRORS.txt`. You can modify and commit any file inside `ompi`. For example, if there is a hypothetical file called `NEED2MODIFY.md`. After you modify it and try to commit it, nothing will happen when you do `git add NEED2MODIFY.md`. However, when you do `git commit -m 'some modification'`, `cppcheck` must start scanning the `ompi` repository, and eventually complete scanning and dump all results in `ALL_ERRORS.txt`. 

3. Save your code from Steps 1, and 2 in your repository. Save `ALL_ERRORS.txt` in your repository as well. Complete the mini workshop on iLearn.   

## Breakdown of Points 

1. Programs: 90% 
2. Saving and iLearn activities: 10% 


For questions please let me know. 