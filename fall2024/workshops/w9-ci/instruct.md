## Workshop 9

## Workshop Name: Integrating QA for Continuous Integration with Codacy

## Description 

Develop a simple continuous integration (CI) pipeline to automatically scan code. 
 
## Targeted Courses 

Software Quality Assurance 

## Activities 

### Pre-lab Content Dissemination 

Pioneered by [Martin Fowler](https://martinfowler.com/), CI is the practice of automatically integrating code changes. A few key principles of CI are: 
- maintain a single source repository
- automate the build
- every commit should build mainline on an integration machine
- keep the build fast
- make it easy for anyone to get the latest executable
- everyone can see what's happening 

As part of this workshop we will see how we can use an existing CI tool called [GitHub Actions](https://github.com/features/actions) and [Codacy](https://github.com/marketplace/actions/codacy-analysis-cli) to not only integrate code changes with CI but also check for quality concerns with static analysis. 

### In-class Hands-on Experience 

- This portion of the workshop will be recorded and later uploaded to CANVAS
   - Create an account on GitHub if you haven't already 
   - Fork the repository `https://github.com/paser-group/COVID19` 
   - After forking, clone the repository 
   - Add Codacy with GitHub Actions using the instructions [here](https://github.com/marketplace/actions/codacy-analysis-cli) 
   - Create a minor change in any file 
   - Commit and push the file on your forked repository. Keep track of the commit message 
   - See the changes in the `Actions` tab within your repository 
   - Find the build by the commit message you used while commiting 
   - See the changes 

### Post Lab Exercise 
- Repeat all the steps from the in-class exercise for the repository `https://github.com/akondrahman/IaCTesting`. This will include forking `https://github.com/akondrahman/IaCTesting`, forking, adding codacy with GitHub Actions, making changes in a  file, commiting and pushing, and finding the build in the `Actions` tab of your repository   
- Find the URL to your CI run and record it in a TEXT file. Also capture 5 screenshots of the CI run 
- Submit your text file and screenshots @ Workshop 9 on CANVAS. 
- Complete the [survey](https://auburn.qualtrics.com/jfe/form/SV_cAOhdjfti78MVls)
- Due: Oct 28, 2024

### Rubric 

- URL of CI: 40%
- Screenshots: 40%
- Survey: 20% 


