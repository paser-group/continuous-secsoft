# Workshop-6: Android Permissions That May Leak Personally Identifiable Information (PII) 

## Setup 


1. run `docker pull akondrahman/sec-soft-edu-materials:latest` (takes 10 minutes on a Mac)
2. run `docker run -it --privileged <IMAGE_ID>   bash `, to find `IMAGE_ID` run `docker images -a`
3. run `cd /WORKSHOPS/WORKSHOP_6/` 


## The Work 

1. Your first task is to identify directories in `FARMING_ANDROID_REPOS/` that include at least one `AndroidManifest.xml` file using a program in your favorite programming language. 
2. Write a program that identifies Android permissions requestes in each of the `AndroidManifest.xml` files you gathered from Step 1. Print it out in a text file called `Android.Permissions.Farming.txt`. Only print out unique permissions. If you are using Python then you will find the `xml.etree.ElementTree` library useful.   
3. From the identified permissions in Step 2, find and separate permnissions that can leak personally identifiable information (PII). Save it in a TEXT file called `PII.Android.Farming.Permissions.txt`. For this step you don't have to write any programs. To get an idea of what Android permissions are related with PII, see column `Permission` in Table 1 of `https://www.ftc.gov/system/files/documents/public_events/1415032/privacycon2019_serge_egelman.pdf`. 
4. From the identified permissions in Step 2, find and separate permissions that are perceived as **Dangerous**. Save it in a TEXT file called `Dangerous.Android.Farming.Permissions.txt`. For this step you don't have to write any programs. To get an idea of what the dangerous Android permissions are see column `Dangerous Android Permissions` of Table 4 in the paper: `https://www.mdpi.com/2076-3417/9/19/3997`.  
5. Write a program that automatically identifies the permissions listed in  `Dangerous.Android.Farming.Permissions.txt (from Step-4)` and `PII.Android.Farming.Permissions.txt` in Java methods. Check `https://developer.android.com/training/permissions/requesting (from Step-3)` on how Android permissions are specified in Java programs. You will need traverse the AST of Java programs. If you are using Python then you will find the `https://github.com/c2nes/javalang` library helpful. Report the Java methods, Java files and the corresponding directories in `Workshop6.md`.   
6. Save your code from Steps 1, 2, 5 in your repository. Save your markdown and text files in your repository as well. Complete the mini workshop on iLearn.   

## Breakdown of Points 

1. Programs: 60% 
2. Markdown: 30% 
3. Saving activities: 10% 


For questions please let me know. 