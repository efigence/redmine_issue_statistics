# Documentation

This is documentation of usage [Redmine Issue Statistic Plugin][bb]
[bb]: https://github.com/efigence/redmine_issue_statistics


### Start calculations

To run calculations paste this line to your Terminal: (This can take a while)

 `bundle exec rake issue_statistics:calculate`

#### Processing time(example):


Principals | Projects | Principals-Projects
-----------|----------|--------------------
671|408|12344

  This gives results:

Stats count | Processing time
------------|----------------
53796|~2842.5s(~47.5min)

### Highcharts charts

All statistics are represented on charts powered by [Highcharts][bh] library
[bh]: http://www.highcharts.com/ 
* Main charts with all stats(total, opened etc.) - shows User stats
![](https://raw.githubusercontent.com/efigence/redmine_plugins_cdn/master/PIC/issue_statistics/popr_main_chart.png)
* Returned chart (shows percent of returned issues and count of returned issues)

![](https://raw.githubusercontent.com/efigence/redmine_plugins_cdn/master/PIC/issue_statistics/returned.png)
* Closed to opened chart (shows ratio closed to opened)
![](https://raw.githubusercontent.com/efigence/redmine_plugins_cdn/master/PIC/issue_statistics/opened_closed.png)

if you select one of statistics, you will see list of issues that meet the given criteria
![](https://raw.githubusercontent.com/efigence/redmine_plugins_cdn/master/PIC/issue_statistics/issue_list_closed.png)

### Search Stats

You can search stats for User, Project or User per Project
![](https://raw.githubusercontent.com/efigence/redmine_plugins_cdn/master/PIC/issue_statistics/search.png)

### Configuration

  You can change default configuration of plugin as you want (administration/plugins/cofigure)
  * **Number of commentes in issue** (ex. if you set 2, then stats will be looking for only this issues where is more then 2 comments)
  * **Number of returns issue** (How many times issue change status on new or something what you set in cofiguration)
  * **Number of statistics on page** (Set how many stats you want to see on page)
  * **Finding returned issues** (Set how you want to search returned issues)
    * Status From (ex. Issue change status from Resolved)
    * Status To (ex. Issue change status to New)
  * **Allowed groups** (Here you can select groups which can see statistics and API)
    * note: User from specified group can see only stats for users/projects from his group!
    (ex. Teamlider Java can see only stats for users and projects in Java Group)

![](https://raw.githubusercontent.com/efigence/redmine_plugins_cdn/master/PIC/issue_statistics/main_config.png)

![](https://raw.githubusercontent.com/efigence/redmine_plugins_cdn/master/PIC/issue_statistics/returned_config.png)

![](https://raw.githubusercontent.com/efigence/redmine_plugins_cdn/master/PIC/issue_statistics/allowed_groups.png)
### API

  If you want get an API, set your path with .json?key=your_api_access_key
  ex.: `www.myamasingstats.com/statistics.json?key=ee710ac2854asdads12330c097098d862b4982c3493c0`
