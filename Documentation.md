# Documentation

This is documentation of usage [Redmine Issue Statistic Plugin][bb]
[bb]: https://github.com/efigence/redmine_issue_statistics


### Start calculations

To run calculations paste this line to Rails Console: (This can take a while)

`RedmineIssueStatistics::CalculateStatistic.new.calculate`

#### Processing time:


Users | Projects | Groups | User-Projects
------|----------|--------|--------------
627|408|44|12344

This gives results:

Stats count | Processing time
------------|----------------
53796|~2842.5s(~47.5min)

### Highcharts charts

All statistics are represented on charts powered by [Highcharts][bb] library
[bb]: http://www.highcharts.com/ 
* Main chart with all stats(total, opened etc.)
![](https://raw.githubusercontent.com/efigence/redmine_plugins_cdn/master/PIC/issue_statistics/main_chart.png)
* Returned chart (shows percent of returned issues and count of returned issues)

![](https://raw.githubusercontent.com/efigence/redmine_plugins_cdn/master/PIC/issue_statistics/returned.png)
* Closed to opened chart (shows ratio closed to opened)
![](https://raw.githubusercontent.com/efigence/redmine_plugins_cdn/master/PIC/issue_statistics/opened_closed.png)

if you select one of statistics, you will see list of issues that meet the given criteria
![](https://raw.githubusercontent.com/efigence/redmine_plugins_cdn/master/PIC/issue_statistics/issue_list_closed.png)

### Search Stats

You can search stats for User, Project or User per Project
> PICTURE SEARCH

### Configuration

  You can change default configuration of plugin as you want (administration/plugins/cofigure)
  * **Number of commentes in issue** (ex. if you set 2, then stats will be looking for only this issues where is more then 2 comments)
  * **Number of returns issue** (How many times issue change status on new or something what you set in cofiguration)
  * **Numer of statistics on page** (Set how many stats you want to see on page)
  * **Finding returned issues** (Set how you want to search returned issues)
    * Status From (ex. Issue change status from Resolved)
    * Status To (ex. Issue change status to New)
  * **Allowed groups** (Here you can select groups which can see statistics and API)
    * note: User from specified group can see only stats for users/projects from his group!
    (ex. Teamlider Java can see only stats for users and projects in Java Group)

### API

  If you want get an API, set your path with .json?key=your_api_access_key
  ex.: `www.myamasingstats.com/issue_statistics/index.json?key=12124142juh124h1hiu1h24124ui124h1`
  * note: Api access ket
