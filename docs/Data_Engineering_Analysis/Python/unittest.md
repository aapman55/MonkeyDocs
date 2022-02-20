# Unit testing
In unit testing the smallest possible unit of a piece of code is tested. This can for example be a function or 
a method in a class. In the test you run the function with predefined input, then you compare that input with 
an output that you expect and define preferably in a hard-coded way. By hard-coding you make sure that the expected
outcome is defined by you alone, and does not depend on some other function.

In python there are some unit testing frameworks, such as the built-in `unittest` and `pytest`. 

Ideally you want every part of your function to be tested. If there are branches created in the function by
for example if statements, you want each branch to be covered by a unit test. In practice this might not be that easy
to achieve. The python library `coverage` can generate a code coverage report for you and point out which parts of 
the code has not been covered by a unit test.

## Testing frameworks
# Unittest
The `unittest` package is the easiest way to start unit-testing.
Structure-wise it is best to create a folder named `test` in the root of your repo. Then in this `test` folder
you follow the structure of your source folder and create for each module a test file. So if the path to one of 
the modules is `source/your_module.py`, then the corresponding test should be located at `test/source/test_your_module.py`.

It is important to start your file with prefix `test_`. Also the test classes and test methods/functions in that file
should start with `test_`. This is so the test framework can identify the tests, as you might have some helper 
classes or functions.

In your test file start by importing the `unittest` package:

```python
import unittest
```



# Pytest

## Coverage Report Generation
For the coverage we are using the coverage package, which can be pip-installed.
```commandline
pip install coverage
```

Then you can run the tests via coverage. In this example we use pytest to run the tests.
```commandline
coverage run -m pytest path/to/your/test_file.py
```

After the tests are run, you can let `coverage` generate a summary in the command line, or output an extensive
report in html. In this html report you not only see the coverage percentage per file, but you can also drill-through
to see the code with the parts not covered highlighted in red.

Create a simple report in the terminal:
```commandline
coverage report --include="./ssis_analyzer/wherescape/*.py"
```
Create a html reportL
```commandline
coverage html --include="./ssis_analyzer/wherescape/*.py"
```

By defining `--include`, you can limit the report to a specific part of your code base. This will speed up the 
generation and prevent unwanted codes to be included.