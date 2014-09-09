# Documentation

This is documentation of usage [Redmine Issue Statistic Plugin][bb]
[bb]: https://github.com/efigence/redmine_issue_statistics


### Start calculations

To run calculations paste this line to Rails Console: (This can take a while)
`RedmineIssueStatistics::CalculateStatistic.new.calculate`
> `For 408 users and 627 projects plugin generate ~65000 statistics in ~50 minutes`

### Highcharts charts

All statistics are represented on charts powered by [Highcharts][bb] library
[bb]: http://www.highcharts.com/ 
> PICTURE STAT MAIN
> PICTURE RETURNED
> PICTURE CLOSED - OPENED 

if you select one of statistics, you will see list of issues that meet the given criteria
> PICTURE ISSUE LIST

### Search Stats

You can search stats for User, Project or User and Project
> PICTURE SEARCH

### 
