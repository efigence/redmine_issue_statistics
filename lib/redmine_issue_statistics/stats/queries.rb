module RedmineIssueStatistics
  class Queries
    class << self

      def base_query statisticable, period_to_datetime
        statisticable.issues.
          where(project_id: open_projects).
          where('issues.created_on >= ?', period_to_datetime)
      end

      def old_issues_query statisticable, period_to_datetime
        Issue.
        where(project_id: open_projects).
        where('assigned_to_id = ? AND created_on < ? ', statisticable.id, period_to_datetime).open
      end 
      
      def project_scope query, project_id
        if project_id
          query = query.where(project_id: project_id)
        end
        query
      end

      def returned_query query, project_id = nil
        query = Queries.project_scope query, project_id
        query.
          select('journalized_id').
          group('journalized_id').
          having('count(journalized_id) > ?', Setting.plugin_redmine_issue_statistics['returned'].to_i).
          joins(journals: :details).
          where('old_value != ? AND value IN(?) AND prop_key = ?', 1, ["1","2","8"], "status_id").all
      end

      def comment_query issue, period_to_datetime
        Journal.where("journalized_id = ? AND notes != ? AND created_on >= ?", issue, "", period_to_datetime)
      end

      private

      def open_projects
        @@open_projects ||= Project.where(status: Project::STATUS_ACTIVE).select('id').pluck(:id)
      end
    end
  end
end       
          # select('journalized_id, old_value, value').
          # joins(journals: :details).
          # where('old_value != ? AND value IN(?) AND prop_key = ?', 1, ["1","2","8"], "status_id").all

