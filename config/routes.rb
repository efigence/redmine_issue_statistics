# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get "issue_statistics/index",  to: 'issue_statistics#index'
get "issue_statistics/users_stats",  to: 'issue_statistics#users_stats'
get "issue_statistics/projects_stats",  to: 'issue_statistics#projects_stats'