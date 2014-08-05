# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get "issue_statistics/index",  to: 'issue_statistics#index', as: 'statistics'
get "issue_statistics/users_stats",  to: 'issue_statistics#users_stats', as: 'statistics/users'
get "issue_statistics/projects_stats",  to: 'issue_statistics#projects_stats', as: 'statistics/projects'