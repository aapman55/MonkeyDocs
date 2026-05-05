# Timeline Matching

This case is somewhat similar to the overlapping timelines. The difference there is that in the 
overlapping timelines we are looking at 1 timeline. In this matching timelines case we have 2
separate timelines and want to know which segments of timeline A coincides with that of timelines B.

## Logic

```text
Timeline A               |-----------------------------------|
====================================================================================
Timeline B cases
-----------
1 No Match         |---|
2 Match                |-----|
3 Match                            |---------------------|
4 Match                                               |---------------|
5 Match            |----------------------------------------------------|
6 No Match                                                          |-----|
```

* Case 1 and 6 have no overlap.
* Case 3 and 5 are actually the same, A and B are just reversed. One timeline entirely
  wraps around the other.
* Case 2 and 4 have partial overlap.

We only need 2 conditions to check whether there is a match.
* The start of B should be smaller than the end of A
  * This remove case 6
* The end of B should be larger than the start of A
  * This removes case 1

All other cases satisfy these 2 conditions, you can check yourself.

## Code example

Let's say we have 2 tables. Table A and Table B. Both having the following schema.

| Column name | datatype   |
|-------------|------------|
| id          | int        |
| start_date  | timestamp  |
| end_date    | timestamp  | 

This results in the following query:

```sql linenums="1"
SELECT *
FROM table_a AS a
    INNER JOIN table_b AS b
        ON b.id = a.id
        AND b.start_date <= a.end_date
        AND b.end_date >= a.start_date
```

In this query, both edge cases are included. Depending on the use-case you can tweak the
operators.