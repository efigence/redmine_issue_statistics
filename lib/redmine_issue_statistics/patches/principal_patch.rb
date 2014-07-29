require_dependency 'principal'

module RedmineIssueStatistics
  module Patches
    module PrincipalPatch
      def self.included(base) # :nodoc:
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
          has_many :issues, :foreign_key => 'assigned_to_id' 
          has_one :issue_statistics, :as => :statisticable
        end
      end
    end
  end
end

unless Principal.included_modules.include?(RedmineIssueStatistics::Patches::PrincipalPatch)
  Principal.send(:include, RedmineIssueStatistics::Patches::PrincipalPatch)
end