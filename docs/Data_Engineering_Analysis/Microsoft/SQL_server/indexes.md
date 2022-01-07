# Indexes
Indexes can be very useful to speedup queries. However, overdoing them could cause the opposite.
This page describes what indexes are, which types of indexes are present and when to use which.
But first of all, we need to understand how data is stored in SQL server.

## How is data stored?


## What are indexes?
In essence an index is nothing more than an ordered list. By knowing which columns are sorted it makes
looking up the correct records much faster as you "know" where that record is.

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

