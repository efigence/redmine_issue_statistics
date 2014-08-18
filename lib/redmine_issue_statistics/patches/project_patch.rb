require_dependency 'project'

module RedmineIssueStatistics
  module Patches
    module ProjectPatch
      def self.included(base)
        base.extend ClassMethods
        base.acts_as_statisticable
      end

      module ClassMethods
        def acts_as_statisticable
          unloadable # Send unloadable so it will not be unloaded in development
          has_many :issue_statistics, :as => :statisticable
        end
      end
    end
  end
end

unless Project.included_modules.include?(RedmineIssueStatistics::Patches::ProjectPatch)
  Project.include RedmineIssueStatistics::Patches::ProjectPatch
end
