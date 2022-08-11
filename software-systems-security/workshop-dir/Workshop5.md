# Workshop-5: Dangerous Android Permissions That May Leak Personally Identifiable Information (PII) 


## Due date: `Oct 08, Friday AoE`

## Setup 

1. Download this file: https://tennesseetechuniversity-my.sharepoint.com/:u:/g/personal/arahman_tntech_edu/EcY6wY2i2R1OnPmsWTZsWBEBtB-bgOyb2bi_D1-Rw1zMqQ?e=a6YF26


## The Work 

1. Unzip the file. Your first task is to identify sub-directories in `FARMING_ANDROID_REPOS/` that include at least one `AndroidManifest.xml` file using a program in your favorite programming language. 

2. Find and separate permissions that are perceived as **Dangerous**. Find all dangerous Android permissions from column `Dangerous Android Permissions` of Table 4 in the paper: `https://www.mdpi.com/2076-3417/9/19/3997`.

3. Write a program that identifies Android permissions requestes in each of the `AndroidManifest.xml` files. If you are using Python then you will find the `xml.etree.ElementTree` library useful. If you are using Java, then you can use the `Java DOM Parser` utility useful (https://www.javatpoint.com/how-to-read-xml-file-in-java). Simple _case sensitive_ pattern matching would suffice. Here is an example how permissions are specified in AndroidManifest.xml files: 


```
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.java2blog.helloworldapp">
    <uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.INTERNET" />     

```

4. Write a program that automatically identifies the dangerous permissions in all methods in all Java programs in the directory `FARMING_ANDROID_REPOS/`. Check `https://developer.android.com/training/permissions/requesting` on how Android permissions are specified in Java programs. 
You will need traverse the AST of Java programs. If you are using Python then you will find the `https://github.com/c2nes/javalang` library helpful. If you are using Java, then you can use `javac` (http://openjdk.java.net/groups/compiler/) or `Antlr` (https://dzone.com/articles/parsing-any-language-in-java-in-5-minutes-using-an). Simple _case sensitive_ pattern matching would suffice to detect permissions within methods. Here is an example how permissions are specified in Java methods: 

> Manifest.permission.WRITE_CALENDAR   

6. Calculate the lines of code for all Java and AndroidManifest.xml files in `FARMING_ANDROID_REPOS/`
7. Create a comma separated value (CSV) file called `Workshop#5.Output.csv`, which will have the following columns: 

```
Directory,Full_Path_To_File,Lines_Of_Code,Dangerous_Permission_Name
Dir_A,/Users/users/arahman/Dir_A/java_a.java,100,read_calendar
Dir_B,/Users/users/arahman/Dir_B/java_b.java,150,write_calendar
Dir_A,/Users/users/arahman/Dir_A/AndroidManifest.xml,200,read_calendar
Dir_B,/Users/users/arahman/Dir_B/AndroidManifest.xml,50,write_calendar
```

## Submission items 
1. All source code files in your repo 
2. The CSV file in your repo  
3. Your repo link on iLearn ``(Assignments/Privacy Workshop)``


For questions please let me know. 

