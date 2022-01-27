# Install Pyspark on Windows
## Pyspark
Pyspark can be installed from pip:

```commandline
pip install pyspark
```

## Hadoop
Pyspark also relies on Hadoop. The required binaries can be found in the repo 
https://github.com/cdarlint/winutils. 

![cdarlint/winutils](./img/winutils.png)

Download the desired Hadoop version and set the correct environment variables.

```commandline
HADOOP_HOME=<your local hadoop-ver folder>
PATH=%PATH%;%HADOOP_HOME%\bin
```

## Python
At this stage pyspark might work, but there is a big chance that it is complaining about not
finding `python3.exe`. There are 2 things you need to do:

1. Check whether Windows has registered any aliases for the keywords `Python` and `Python3`

      1. Open the start menu and search for `Manage app execution aliases`
   
          ![manage app execution aliases](./img/manage_app_execution_aliases.png)

      2. Then for `Python` and `Python3` turn the toggles off
   
          ![Python aliases](img/python_aliases.png)
   
3. Check whether there is an executable `python3.exe` in your python installation directory
      1. Find the directories by typing
         1. `cmd`: `where python`
         2. `Powershell`: `Get-Command python` or `gcm python` 
      2. If there is no `python3.exe` present. Copy paste `python.exe` and rename it to `python3.exe`

After performing these 2 steps, restart the command window. After that pyspark should be working.