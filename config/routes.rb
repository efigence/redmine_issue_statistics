
get "issue_statistics/index",  to: 'issue_statistics#index', as: 'statistics', path: 'statistics'
get "issue_statistics/users_stats",  to: 'issue_statistics#users_stats', as: 'statistics/users'
get "issue_statistics/projects_stats",  to: 'issue_statistics#projects_stats', as: 'statistics/projects'
get "issue_statistics/principal_stats_per_project",  to: 'issue_statistics#principal_stats_per_project', as: 'statistics/projects_principals'

get "issue_statistics/total_issues/:statisticable_id/:statisticable_type/:period", to: 'issue_statistics#total_issues'
get "issue_statistics/opened_issues/:statisticable_id/:statisticable_type/:period", to: 'issue_statistics#opened_issues'
get "issue_statistics/returned_issues/:statisticable_id/:statisticable_type/:period", to: 'issue_statistics#returned_issues' 
get "issue_statistics/most_commented_issues/:statisticable_id/:statisticable_type/:period", to: 'issue_statistics#most_commented_issues' 
get "issue_statistics/closed_issues/:statisticable_id/:statisticable_type/:period", to: 'issue_statistics#closed_issues'
get "issue_statistics/older_issues/:statisticable_id/:statisticable_type/:period", to: 'issue_statistics#older_issues'  
