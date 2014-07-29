  require "redmine_issue_statistics/version"
  require 'redmine_issue_statistics/calculate_statistics'
  module RedmineIssueStatistics

  # [:pl, :en]
  def self.available_locales
    Dir.glob(File.join(Redmine::Plugin.find(:redmine_issue_statistics).directory, 'config', 'locales', '*.yml')).collect {|f| File.basename(f).split('.').first}.collect(&:to_sym)
  end

 end
