# Indexes
Indexes can be very useful to speedup queries. However, overdoing them could cause the opposite.
This page describes what indexes are, which types of indexes are present and when to use which.
But first of all, we need to understand how data is stored in SQL server.

## How is data stored?
Data in SQL server is stored in pages, pages that are 8 KB big. A row is stored in such a page and cannot span
multiple pages. What can be done is that if some columns are too large to make the row fit, instead of saving the
contents directly on the same page, a pointer will be saved. This pointer will refer to other pages that contain the 
data.

For more information see: https://docs.microsoft.com/en-us/sql/relational-databases/pages-and-extents-architecture-guide

## What are indexes?
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

## What types of indexes are there?
So now we have a rough idea what indexes are and why they are handy, we can have a look what types of indexes there are.
We can distinguish the following index types:

* Heap (no index)
* Row-store indexes
    * Clustered indexes
    * Non-clustered indexes
* Column-store indexes  
    - Clustered
    - Non-clustered

### The heap (no index)
A table that had index type heap, means that it does not have an index. It just piles the rows in the order it 
receives. Having no index means that 
