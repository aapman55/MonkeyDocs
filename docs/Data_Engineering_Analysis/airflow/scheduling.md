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
If you have the schedule `0 * * * *`, it will run every hour at minute `:00`. Let's say that
the current time is `19:48`, you would expect that at `20:00` the schedule for `20:00` will be run.
This, however, is not the case. At `20:00` the schedule for `19:00` will be run. Airflow runs the
schedule at the end of the scheduling period.

You can read more about it here: https://towardsdatascience.com/apache-airflow-tips-and-best-practices-ff64ce92ef8

