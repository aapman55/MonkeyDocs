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
### Unittest
The `unittest` package is the easiest way to start unit-testing. 
See official documentation: https://docs.python.org/3/library/unittest.html.

Structure-wise it is best to create a folder named `test` in the root of your repository. Then in this `test` folder
you follow the structure of your source folder and create for each module a test file. So if the path to one of 
the modules is `source/your_module.py`, then the corresponding test should be located at `test/source/test_your_module.py`.

It is important to start your file with prefix `test_`. Also the test classes and test methods/functions in that file
should start with `test_`. This is so the test framework can identify the tests, as you might have some helper 
classes or functions.

In your test file start by importing the `unittest` package:

```python
import unittest
```

It is best practise to create a corresponding TestClass for every class in the module you want to test.
If the module contains functions that are outside a class, you could bundle them together in a generic test class.

To initiaite a unittest class you need to inherit from `unittest.TestCase`.

```python
import unittest


class TestYourClass(unittest.TestCase):
    ...
```

By inheriting from the TestCase class you get access to some useful functions to setup before a test and some 
compare functions.

#### Setup
The setup can be defined in a method called setUp(). 
```python
import unittest

class TestYourClass(unittest.TestCase):
    def setUp(self) -> None:
        self.some_test_data = ["data1", "data2", "data3"]
```

The `setUp` method is called everytime an unittest method in that class is called. So you do not need to worry about
the contents when you modify it in one of your tests.

#### The unit test
To define a unittest all you need to do is define a class method with a name starting with `test_`.

```python
import unittest

class TestYourClass(unittest.TestCase):
    def setUp(self) -> None:
        self.some_test_data = ["data1", "data2", "data3"]

    def test_some_method(self):
        output = some_method(self.some_test_data)

        expected_output = "data1"
        self.assertEqual(output, expected_output)
```
In the test method you run the method you want to test and compare that with what you expect. The comparison can be
done by using one of the many assert methods provided by the TestCase class.

#### Mocking imports
For unittests you want to just test the functionality in the method, in a controlled manner. 
If your method or function has external dependencies on for example a database connection, then the outcome of the test
is not deterministic. The database might be down, and thus failing the unittest. To counter this, we can temporarily
replace the dependency on the database in the test. This is called mocking. 
See official [documentation](https://docs.python.org/3/library/unittest.mock.html) to learn more.

With a mock you can redefine a return value of the function or class that you are patching. So in the database case 
you might change the output of the database query to a dataset that you define yourself.

You can mock a testcase by putting a `patch` decorator around the test method or test class. You can also use the 
`patch` in a context manager. The easiest way is to just put it around the test method.

```python
import unittest
from unittest import mock


class TestYourClass(unittest.TestCase):
    @mock.patch("path.to.your.module.import_you_want_to_mock")
    def test_your_method(self, mock_some_import):
        ...
```
For every patch you define, you will get a corresponding mock object as input to your test method. The order of the 
objects are from in to out. So:

```python
import unittest
from unittest import mock


class TestYourClass(unittest.TestCase):
    @mock.patch("path.to.your.module.some_other_import")
    @mock.patch("path.to.your.module.import_you_want_to_mock")
    def test_your_method(self, mock_some_import, mock_some_other_import):
        ...
```

Then in the method itself you can take that mock object and define a different return value.
```python
mock_some_import.return_value = "some_other_output"
```

You can even go deeper in a structure, so:
```python
mock_some_import.return_value.some_other_object.return_value = "some_other_output"
```
In the examples you see `return_value`, this just indicates that a function or method gets called, so just `()`.
So without the `return_value` you are referring to the function or object itself. Meaning that you can replace 
a function or object rather than just the output.

!!! important
    It is important to realise that when you import packages in python, it gets registered to an import table.
    The patching will just replace the original entry of the import with a `MagicMock` object. So you can 
    mock all the things that you import.

##### Mocking built-ins
Built-ins are immutables and therefore can not be patched in the same way. To resolve this we can wrap the built-in
module. See this thread: https://stackoverflow.com/a/55187924/.

An example could be the builtin `datetime.today()`. 

!!! quote "From the stackoverflow answer ([link](https://stackoverflow.com/a/55187924/))"
    ```python linenums="1"
    from unittest import mock, TestCase
    
    import foo_module
    
    class FooTest(TestCase):
    
        @mock.patch(f'{foo_module.__name__}.datetime', wraps=datetime)
        def test_something(self, mock_datetime):
            # mock only datetime.date.today()
            mock_datetime.date.today.return_value = datetime.date(2019, 3, 15)
            # other calls to datetime functions will be forwarded to original datetime
    ```

With wraps you just put a wrapper around the datetime module. All the function calls get forwarded. Thus when you 
do not define another return value, it will just forward the call to the original function and so all the functions
you do not change will just function normally.

#### Running unittests
```commandline
python -m unittest path/to/your/tests/or_test_file.py
```

### Pytest
With the `Pytest` library you can orchestrate and automate your tests in a more sophisticated way. You can run 
tests defined using the `unittest` library with pytest.

I have not worked with pytest in a pytest way yet, with for examples `fixtures`, to be able to say something about
it now. More will follow.

#### Running tests using pytest
```commandline
pytest path/to/your/tests/or_test_file.py
```

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
coverage report --include="./path/to/your/modules/*.py"
```
Create a html reportL
```commandline
coverage html --include="./path/to/your/modules/*.py"
```

By defining `--include`, you can limit the report to a specific part of your code base. This will speed up the 
generation and prevent unwanted codes to be included.