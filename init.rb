# encoding: utf-8
require 'redmine'
require "redmine_issue_statistics"

Redmine::Plugin.register :redmine_issue_statistics do
  name 'Redmine Issue Statistics plugin'
  author "Marcin Świątkiewicz"
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/efigence/redmine_issue_statistics'
  author_url 'http://www.efigence.com/'

  permission :view_statistics, :issue_statistics => [:index, :users_stats, :projects_stats]
  menu :top_menu, 
    :issue_statistics, { :controller => 'issue_statistics', :action => 'index' },
    :caption => :view_statistics,
    :if => proc {
      User.current.admin? ||
      !(User.current.groups.pluck(:id).map(&:to_s) & (Setting.plugin_redmine_issue_statistics['groups'] || [])).blank?
    }

  settings :default =>  {
    'comment_settings' => 5,
    'returned' => 1,
    'per_page' => 1,
    'returned_table_to' =>  IssueStatus.where(is_closed: false).pluck(:id).map(&:to_s),
    'returned_table_from' => IssueStatus.where(is_closed: true).pluck(:id).map(&:to_s)
  }, :partial => 'settings/issue_statistics_settings'
end

Rails.configuration.to_prepare do
  require "redmine_issue_statistics/patches/project_patch"
  require "redmine_issue_statistics/patches/principal_patch"
  require "redmine_issue_statistics/patches/issue_query_patch"
end