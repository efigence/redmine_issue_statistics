require_dependency 'user'
require_dependency 'group'

module RedmineIssueStatistics
  module Patches
    module PrincipalPatch
      def self.included(base)
        base.extend ClassMethods
        base.acts_as_statisticable
      end

      module ClassMethods
        def acts_as_statisticable
          unloadable # Send unloadable so it will not be unloaded in development
          has_many :issues, :foreign_key => 'assigned_to_id'
          has_many :issue_statistics, :as => :statisticable
        end
      end
    end
  end
end

# NOTE: it's too late to do it on principal
unless User.included_modules.include?(RedmineIssueStatistics::Patches::PrincipalPatch)
  User.send :include, RedmineIssueStatistics::Patches::PrincipalPatch
end
unless Group.included_modules.include?(RedmineIssueStatistics::Patches::PrincipalPatch)
  Group.send :include, RedmineIssueStatistics::Patches::PrincipalPatch
end
