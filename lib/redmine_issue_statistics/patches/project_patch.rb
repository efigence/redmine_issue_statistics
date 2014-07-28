require_dependency 'project'

module RedmineIssueStatistics
  module Patch
    module ProjectPatch
      def self.include(base)
        base.class_eval do
          unloadable
          base.send(:include, InstanceMethods)
        end
      end
    end
    module InstanceMethod
      def create_statistics_for_project
        attributes = {
          :object_id => self.id,
          :object_type => "Project",
          :total => total,
          :opened => opened#,
          # :closed => closed,
          # :opened_to_closed => ratio_opened_closed,
          # :returned => returned,
          # :from_close_to => 
          # :avg_issue_time =>
        }
        stats = IssueStatistics.build(attributes)
        stats.save
      end

      def total
        Issue.where(project_id: self.id).count
      end

      def opened
        self.issues.open.count
      end

      # def closed
      # end

      # def ratio_opened_closed
      # end

      # def returned
      # end

      # def from_close_to
      # end

      # def avg_issue_time
      # end

    end
  end
end