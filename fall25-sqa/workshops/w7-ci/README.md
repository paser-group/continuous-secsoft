## Integrating QA for Continuous Integration with Codacy

## Description 

Develop a simple continuous integration (CI) pipeline to automatically scan code. 

## Activities 

### Pre-lab Content Dissemination 

Pioneered by [Martin Fowler](https://martinfowler.com/), CI is the practice of automatically integrating code changes. A few key principles of CI are: 
- maintain a single source repository
- automate the build
- every commit should build mainline on an integration machine
- keep the build fast
- make it easy for anyone to get the latest executable
- everyone can see what's happening 

As part of this exercise we will see how we can use an existing CI tool called [GitHub Actions](https://github.com/features/actions) and [Codacy](https://github.com/marketplace/actions/codacy-analysis-cli) to not only integrate code changes with CI but also check for quality concerns with static analysis. 

### Tasks for You  
- Repeat all the steps from the in-class exercise for the repository `https://github.com/akondrahman/IaCTesting`. This will include forking `https://github.com/akondrahman/IaCTesting`, forking, adding codacy with GitHub Actions, making changes in a  file, commiting and pushing, and finding the build in the `Actions` tab of your repository   
- Find the URL to your CI run and record it in a TEXT file. Also capture 5 screenshots of the CI run 
- Submit your text file and screenshots 
- Due: Oct 22, 2025

### Rubric 

- URL of CI: 50%
- Screenshots: 50%


