CREATE DATABASE IF NOT EXISTS Timelines;
USE DATABASE Timelines;

CREATE OR REPLACE TEMPORARY TABLE A AS
SELECT COLUMN1 AS id, COLUMN2 AS start_id, COLUMN3 AS end_id
FROM
    VALUES
        (1,0,2)
    ,   (1,2,5)
    ,   (1,5,6)
    ,   (1,6,10)
    ,   (2,0,10)
    ,   (2,10,10);

CREATE OR REPLACE TEMPORARY TABLE B AS
SELECT COLUMN1 AS id, COLUMN2 AS start_id, COLUMN3 AS end_id
FROM
    VALUES
        (1,0,2)
    ,   (1,2,4)
    ,   (1,4,7)
    ,   (1,7,10)
    ,   (2,0,8)
    ,   (2,8,10)
    ,   (2,10,10);


WITH CTE_nodes AS
(
    SELECT DISTINCT id, start_id            FROM A
    UNION
    SELECT DISTINCT id, end_id AS start_id  FROM A
    UNION
    SELECT DISTINCT id, start_id            FROM B
    UNION
    SELECT DISTINCT id, end_id AS start_id  FROM B
),CTE_timelines AS
(
    SELECT
        id
    ,   start_id
    ,   LEAD(start_id) OVER (PARTITION BY id ORDER BY start_id) AS end_id
    FROM CTE_nodes
    QUALIFY end_id IS NOT NULL

    UNION

    SELECT id, start_id, end_id FROM A WHERE start_id = end_id

    UNION

    SELECT id, start_id, end_id FROM B WHERE start_id = end_id
)
SELECT
    CTE.ID, CTE.START_ID, CTE.END_ID
,   A.ID AS A_ID, A.START_ID AS A_START, A.END_ID AS A_END
,   B.ID AS B_ID, B.START_ID AS B_START, B.END_ID AS B_END
FROM CTE_timelines AS CTE
    LEFT JOIN A
        ON CTE.id = A.id
        AND
        (
                (CTE.start_id >= A.start_id   AND CTE.start_id < A.end_id)
            OR  (CTE.start_id = CTE.end_id AND CTE.start_id = A.start_id AND CTE.end_id = A.end_id)
        )
    LEFT JOIN B
        ON CTE.id = B.id
        AND
        (
                (CTE.start_id >= B.start_id   AND CTE.start_id < B.end_id)
            OR  (CTE.start_id = CTE.end_id AND CTE.start_id = B.start_id AND CTE.end_id = B.end_id)
        )
ORDER BY CTE.ID, CTE.START_ID