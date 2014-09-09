# Redmine issue statistics plugin

Lets you calculate issues stats for users, projects, users in projects, divided on periods (week, month, year and all).

Stats: 
  - Total
  - Opened
  - Closed
  - Opened to closed (ratio)
  - Returned - (For example issues which changed status from resolved to new) (configurable)
  - Returned (ratio) - Returned to total
  - Most commented - Issue with a lot of comments (configurable)
  - Older Issues - Issues older then current period


# Requirements

Developed & tested on Redmine 2.5.2

# Installation

1. Go to your Redmine installation's plugins/ directory.
2. `git clone git@github.com:efigence/redmine_issue_statistics.git && cd ..`
3. `bundle exec rake redmine:plugins:migrate NAME=redmine_issue_statistics RAILS_ENV=production`
4. Restart server

# [Usage](https://github.com/efigence/redmine_issue_statistics/blob/master/Documentation.md)

  Documentation of usage.
