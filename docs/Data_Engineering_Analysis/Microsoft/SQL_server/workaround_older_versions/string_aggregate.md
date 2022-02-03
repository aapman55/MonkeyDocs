# String aggregate
In SQL server versions 2017 and later, there exist the function [STRING_AGG](https://docs.microsoft.com/en-us/sql/t-sql/functions/string-agg-transact-sql)
to combine the contents of multiple rows with a delimiter. 

## The workaround
The trick is to create XML from your query result. The XML output needs to be configured in such a 
way that it does not contain tags, or at least contain just 1 tag which has no nesting. 
By doing so the contents of all the rows will be concatenated.

Let's walk through it step by step. Beginning with creating a simple table to perform the query on.
And let's say we want to aggregate the table based on the `CATEGORY` while concatenating the `FRUIT`
names with a comma.

```t-sql linenums="1"
DECLARE @table TABLE(
	ID INT IDENTITY
,	CATEGORY INT
,	FRUIT VARCHAR(50)
)

INSERT INTO @table
(CATEGORY, FRUIT)
VALUES
(1,		'Apple'),
(1,		'Banana'),
(1,		'Orange'),
(2,		'Watermelon'),
(2,		'Pineapple')
```

If we query this table and simply apply the `FOR XML PATH`

```t-sql linenums="1"
SELECT FRUIT
FROM @table
FOR XML PATH
```
we get:

```xml
<row>
  <FRUIT>Apple</FRUIT>
</row>
<row>
  <FRUIT>Banana</FRUIT>
</row>
<row>
  <FRUIT>Orange</FRUIT>
</row>
<row>
  <FRUIT>Watermelon</FRUIT>
</row>
<row>
  <FRUIT>Pineapple</FRUIT>
</row>
```

To remove the layer with the `<row>` tags we pass an empty string to the `PATH`. We also add the
`TYPE` directive.
If you do not convert it to XML type using the `TYPE` directive, then special characters will be 
HTML encoded. See this post on stackoverflow: https://stackoverflow.com/questions/15643683/how-do-i-avoid-character-encoding-when-using-for-xml-path.
The greater than sign `>` for example will then become `&lt;`.

```t-sql linenums="1"
SELECT FRUIT
FROM @table
FOR XML PATH(''), TYPE
```

Then we have:
```xml
<FRUIT>Apple</FRUIT>
<FRUIT>Banana</FRUIT>
<FRUIT>Orange</FRUIT>
<FRUIT>Watermelon</FRUIT>
<FRUIT>Pineapple</FRUIT>
```

Adding the `TYPE` directive in our example has no visible effect.

In order to turn the generated XML into a string we use the `value` function. That takes as inputs
the path to the nodes we want to get the value from and the data type of that node.

As we have no nested structure we can just pass `'.'` as the path, which just means the root node.
As datatype we pass `nvarchar(max)` just to be sure it fits. You can of course put something smaller.

```t-sql linenums="1"
SELECT(
	SELECT ', '+FRUIT
	FROM @table
	FOR XML PATH(''), TYPE
).value('.','nvarchar(max)')
```
Resulting in 
```text
, Apple, Banana, Orange, Watermelon, Pineapple
```

We have put the delimiter in the front, because that makes it easier to remove. If we would have put it at 
the end, we would need to know how long the string is. To remove characters at a certain location
we use the [STUFF](https://docs.microsoft.com/en-us/sql/t-sql/functions/stuff-transact-sql) function.

Finally we need to write the outer query that contains the list of categories. We use 
an `APPLY` to concatenate the string for each category.

```t-sql linenums="1"
SELECT 
	CATEGORY
,	RES.AGG
FROM @table AS A
OUTER APPLY
(
	SELECT	
		[AGG] = STUFF(
						(
							SELECT ', '+FRUIT
							FROM @table AS B
							WHERE 1=1
								AND A.CATEGORY = B.CATEGORY
							FOR XML PATH(''), TYPE
						).value('.','nvarchar(max)')
				,1,2,'')
) AS RES
GROUP BY
	CATEGORY
,	RES.AGG
```

| CATEGORY  | AGG                   |
|-----------|-----------------------|
| 1	     | Apple, Banana, Orange |
| 2	     | Watermelon, Pineapple |