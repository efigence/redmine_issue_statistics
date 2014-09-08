require_dependency 'issue_query'

module RedmineIssueStatistics
  module Patches
    module IssueQueryPatch
      def self.included(base)
        base.extend ClassMethods
        base.extend_initialize_available_filters
      end

      module ClassMethods
        def extend_initialize_available_filters
          include InstanceMethods
          alias_method_chain :initialize_available_filters, :issue_id
        end      

        module InstanceMethods
          def initialize_available_filters_with_issue_id
            add_available_filter "id", :type => :text
            initialize_available_filters_without_issue_id
          end
        end
      end
    end
  end
end

unless IssueQuery.included_modules.include?(RedmineIssueStatistics::Patches::IssueQueryPatch)
  IssueQuery.send :include, RedmineIssueStatistics::Patches::IssueQueryPatch
end
