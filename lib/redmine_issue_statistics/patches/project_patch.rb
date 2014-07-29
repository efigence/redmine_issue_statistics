require_dependency 'project'

module RedmineIssueStatistics
  module Patches
    module ProjectPatch
      def self.included(base) # :nodoc:
        base.class_eval do
          unloadable
          has_one :issue_statistics, :as => :statisticable
        end
      end
    end
  end
end

unless Project.included_modules.include?(RedmineIssueStatistics::Patches::ProjectPatch)
  Project.send(:include, RedmineIssueStatistics::Patches::ProjectPatch)
end