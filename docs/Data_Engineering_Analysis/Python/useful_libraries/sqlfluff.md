# SQLFluff
[SQLFluff](https://sqlfluff.com/) is a tool to lint your SQL code. It can detect improvements
in the SQL and you can also let it change the SQL code. In order for SQLFluff to detect
improvements, it first needs to disect the SQL queries and classify each of the elements in the
query. This will result in a abstract syntax tree for all the sql nodes.
Because SQLFluff first does that, we can make use of that for our own use-cases as well.

To install sqlfluff we can just use pip:
```commandline
pip install slqlfuff
```

## Intended use
This is just using the command line to tell sqlfluff to check or correct one or more sql files.
We will not go into detail (for now). The documentation should give enough handles to start
using the tool.

## Use SQLFluff to our advantage
The standard simple API of SQLFluff return dictionaries of the tree structure. This is not
practical, as we can not make use of the built-in helper functions. So what we want is to have
the native SQLFluff objects.

First let's import the Linter:
```python
from sqlfluff.core import Linter
```

Then we need to initialise the linter. The simplest configuration we can pass is which dialect
we want to parse. So for example:

```python
linter = Linter(dialect="databricks")
```

Then we can use the `parse_string` method to parse a query.

```python
parsed_string = linter.parse_string("SELECT * FROM some_schema.some_table as t WHERE t.id = 1")
```

The output is a `ParsedString` object, which contains info on whether there were errors encountered
while parsing the query, how long t took and most importantly, the parsed SQL tree. The tree
can be accessed by:

```python
parsed_tree = parsed_string.tree
```

### Manually navigating the tree

You can then navigate the tree manually by requesting the segments with:
```python
parsed_tree.segments[0].segments[0].segments
```

This will result in the following output:
```commandline
Out[8]: (<SelectClauseSegment: ([L:  1, P:  1])>,
 <WhitespaceSegment: ([L:  1, P:  9]) ' '>,
 <Dedent: (None) ''>,
 <FromClauseSegment: ([L:  1, P: 10])>,
 <WhitespaceSegment: ([L:  1, P: 42]) ' '>,
 <WhereClauseSegment: ([L:  1, P: 43])>)
```

### Select deeper segment based on type

Instead of getting the segment by passing an index, we can also use the `get_child` or 
`get_children` methods.

```python
parsed_tree.segments[0].segments[0].get_child("from_clause")
```

Output:
```commandline
Out[12]: <FromClauseSegment: ([L:  1, P: 10])>
```

To check what the contents are of a segment, we can use `raw`:
```python
parsed_tree.segments[0].segments[0].get_child("from_clause").raw
```

Output:
```commandline
Out[13]: 'FROM some_schema.some_table as t'
```

### Automatic crawl for a segment type

Instead of manually going through the tree to access the desired segment, we can also make 
use of the `recursive_crawl` method to do that for you. So to get to the from clause we can
also use:

```python
list(parsed_tree.recursive_crawl("from_clause"))
```
We use list here because the crawler returns a generator. The `recursive_crawl` method 
can be tweaked to not recurse into a certain segment type by specifying `no_recursive_seg_type`.
This can be useful if you don't want to go into selects inside of a join for example. Another
useful parameter is the `recurse_into`, this is a boolean and when set to `False` it will not
recurse deeper when it has found the segment you were looking for.

### Get referenced database objects

If you just want to know which databa se objects are used in the query there is even
a simpler method. You don't need to recursively crawl for all the elements of a 
`FROM` or `JOIN`, because there is a built-in method for it.

```python
parsed_tree.get_table_references()
```

Output:
```commandline
Out[17]: {'some_schema.some_table'}
```

Please note that the output is a set, so the contents are unique. However, if 
the same table is called in the query with different upper or lower casing, then
they will be handled as not the same.