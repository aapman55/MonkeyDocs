# Scheduling
## Format
The format in which the schedule is defined is using crontab. It consists of 5 positions, going from
left to right:

1. minute
2. hour
3. day (of month)
4. month
5. day (of week)

At each position you can use:

* `*` indicating all values. If for exampel an `*` is in the minute position, it means that the schedule
runs every minute.
* `,` with the comma you can give a list of numbers.
* `-` with the dash you can give a range of numbers.
* `/` indicates the step size it takes. `/4` in the minutes position means that every 4th minute the schedule
is going to run.

The allowed numerical values for each of the positions are:

| Cron tab position | Allowed range of numerical values |
|-------------------|-----------------------------------|
| Minute            | 0-59                              |
| Hour              | 0-23                              |
| Day (of month)    | 1-31                              |
| Month             | 1-12                              |
| Day (of week)     | 0-6, where 0 equals Sunday        |

To play around with this notation, go to https://crontab.guru/.

## When does airflow actually start the schedule
