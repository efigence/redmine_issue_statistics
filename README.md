# Redmine issue statistics plugin

Lets you calculate issues stats for users, projects, users in projects, divided on periods (week, month, year and all).

Stats: 
  1. For Project's : 
    - Total (- all assigned to current project)
    - Opened (- all assigned to current project with status open)
    - Closed (- all assigned to currnet project with status closed)
    - Returned - (For example issues which changed status from resolved to new) (configurable)
    - Returned (ratio) - Returned to total
    - Most commented - Issue with a lot of comments (configurable)
    - Older Issues - Issues older then current period
  2. For User's and User's per Project
    - Total (total_assigned) - ( - Tasks where current users logged spent time in current period or modified by this user)
    - Opened ( - Tasks assigned to user with status open and which was assigned and still has status open
)
    - Resolved ( - Tasks which has been change status on resolved etc. by current user and actualy can not be assigned to current user)
    - Older ( - Tasks older then current period, which has status opened)
    - Returned ( - Returned in curent period by Journal)


# Requirements

Developed & tested on Redmine 2.5.2

# Installation

1. Go to your Redmine installation's plugins/ directory.
2. `git clone git@github.com:efigence/redmine_issue_statistics.git && cd ..`
3. `bundle exec rake redmine:plugins:migrate NAME=redmine_issue_statistics RAILS_ENV=production`
4. Restart server
5. Run calculations : `bundle exec rake issue_statistics:calculate`

# [Usage](https://github.com/efigence/redmine_issue_statistics/blob/master/Documentation.md)

  Documentation of usage.
  
# License 

  Highcharts  : [License][bb]
  [bb]: http://creativecommons.org/licenses/by-nc/3.0/legalcode
  
    Redmine issue statistics plugin
    Copyright (C) 2014  efigence S.A.
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
