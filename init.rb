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
end
