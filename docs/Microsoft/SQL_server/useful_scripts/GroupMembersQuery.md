# This is a test

=== "default"
    ``` SQL linenums="1"
    SELECT *
    FROM dbo.Users
    ```
=== "Special"
    ``` SQL linenums="1"
    SELECT *
    FROM dbo.Users
    -- You are special
    ```

| Method      | Description                          |
| :---------- | :----------------------------------- |
| `GET`       | :material-check:     Fetch resource  |
| `PUT`       | :material-check-all: Update resource |
| `DELETE`    | :material-close:     Delete resource |