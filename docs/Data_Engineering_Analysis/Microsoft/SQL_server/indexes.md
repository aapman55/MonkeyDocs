# Indexes
Indexes can be very useful to speedup queries. However, overdoing them could cause the opposite.
This page describes what indexes are, which types of indexes are present and when to use which.
But first of all, we need to understand how data is stored in SQL server.

## How data is stored
Data in SQL server is stored in pages, pages that are 8 KB big. A row is stored in such a page and cannot span
multiple pages. What can be done is that if some columns are too large to make the row fit, instead of saving the
contents directly on the same page, a pointer will be saved. This pointer will refer to other pages that contain the 
data.

For more information see: https://docs.microsoft.com/en-us/sql/relational-databases/pages-and-extents-architecture-guide

## Indexes in a nutshell
In essence an index is nothing more than an ordered list. By knowing which columns are sorted it makes
looking up the correct records much faster as you "know" where that record is.

### Table example
Let's look at following simple example of an unordered list:

| fruit_id  | fruit_name      |
|-----------|-----------------|
| 7         | Lychee          |
| 2         | Blueberry       |
| 4         | Orange          |
| 3         | Banana          |
| 8         | Pineapple       |
| 5         | Mango           |
| 1         | Apple           |
| 9         | Strawberry      |
| 10        | Melon           |
| 6         | Avocado         |

If you want to get the fruit with `id = 1`, then you can't just pick the first one, because it is unsorted. 
You would need go through the list until you find the correct record. This is a small table and thus the record
can be found relatively easily, however, it still takes more time than when you know you can just pick the first one.

So in case the `id` is used often in queries, it would make it simpler to have the records sorted on that column.

### Book example
Let's also take a book as analogy. Consider each page to be a row, a row consisting of 3 columns:

* The page number
* The chapter name/number
* The contents

In the case of a book the pages are sorted ordered by the page number. If you look at the chapter numbers you
will see that they are also sorted. This makes it very easy to jump to a certain page or chapter.

In the next sections we will expand on this book example to explain the concepts of indexes.

## Index seeks and index scans
As seen from the examples in the previous section, when there is an index (when the list is ordered) you can
relatively quickly get to the correct row, in case the column you are looking in is part of the index. This 
action of going through an index is called index seek.

When there is no index present, you would have to go row by row and page by page to ge to the correct row. This 
takes considerably longer. This action of going through the rows is called index scan. Most of the time you want
to avoid index scans.

## Types of indexes
So now we have a rough idea what indexes are and why they are handy, we can have a look what types of indexes there are.
We can distinguish the following index types:

* Heap (no index)
* Row-store indexes
    * Clustered
    * Non-clustered
* Column-store indexes  
    - Clustered
    - Non-clustered

### The heap (no index)
A table that has index type heap, means that it does not have an index. It just piles the rows in the order it 
receives. Having no index means that getting to a row might be slower. However, because the row is just written
at the end, there is no need to put the row between existing rows and existing indexes do not need to be rewritten.
This means that writing will be a lot faster.

When inserted lots of rows, it might be beneficial to remove the index, then insert the rows and finally redo the
indexes. For staging tables you should opt for this strategy.

### Clustered vs non-clustered
A clustered index is sorting the data itself, while a non-clustered index is keeping a separate ordered list.
Clustered and non-clustered indexes can be easily explained by revisiting the book example. The pages are physically
ordered, the text from those pages also move around when ordering the pages by page number. It IS your data, so when
building a clustered index, it takes longer, as all the data needs to be moved with it.

An example of a non-clustered index is the table of contents, it is a separate (much shorter) list that points
to the page number where that chapter starts.Non-clustered indexes always will point to the clustered index. So you look 
up the page number and then using that page number you seek through the clustered index to get to your page.

#### Includes
As discussed earlier, the clustered index IS your entire row and thus consists of all the columns. This means that
if you get to the row, you will have access to all data. With a non-clustered index, you only have the columns that
were part of the index (that were used to sort). This means that you need to make an extra step to get to that data.
However, there is a way to include extra columns in the clustered index.

Example:
```t-sql
CREATE NONCLUSTERED INDEX IX_Address_PostalCode  
ON Person.Address (PostalCode)  
INCLUDE (AddressLine1, AddressLine2, City, StateProvinceID);  
```

This should only be used for smaller columns and when that column is really needed often, otherwise avoid includes
as it will increase the size of your storage.

For more information: https://docs.microsoft.com/en-us/sql/relational-databases/indexes/create-indexes-with-included-columns

### Row vs column store
As the names imply row-store stores the rows row by row and a column-store stores the data in a column-wise fashion.
The advantage of a column-store is that it can be compressed very well. The reason that compression can be done
much better is that contents belonging to the same row look more alike. They have the same datatype, follow the 
same pattern and/or are part of en enumeration (which limits the set of possibilities). 

So let's say we have a column that contains the status (for example: started, closed, in progress etc.). There is 
a finite number of statuses. So if we sort on the status, then it might be the case that on 1 8KB page there is only
1 status present. In that case you could just say that all records on this page have status "started" for example,
which will sae a lot in terms of storage. 

However, there are also drawback. The data will only be columnar compressed when it reaches a threshold of 1,048,576 rows.
Everything else will be stored in a delta row group.

For more information see: https://docs.microsoft.com/en-us/sql/relational-databases/indexes/columnstore-indexes-overview?view=sql-server-ver15