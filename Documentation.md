# Documentation

This is documentation of usage [Redmine Issue Statistic Plugin][bb]
[bb]: https://github.com/efigence/redmine_issue_statistics


### Start calculation

To run calculations paste this line to Rails Console: (This can take a while)
`RedmineIssueStatistics::CalculateStatistic.new.calculate`.
###### `For 408 users and 627 projects plugin generate ~65000 statistics in ~50 minutes`
