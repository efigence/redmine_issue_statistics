require 'redmine'
require "redmine_issue_statistics"
Redmine::Plugin.register :redmine_issue_statistics do
  name 'Redmine Issue Statistics plugin'
  author 'Marcin Świątkiewicz'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end
