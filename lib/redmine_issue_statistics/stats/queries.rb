module RedmineIssueStatistics
  class Queries
    class << self

      def base_query statisticable, period_to_datetime
        statisticable.issues.
          where('issues.created_on >= ?', period_to_datetime)
      end

      def base_query_to_log statisticable, period_to_datetime
        TimeEntry.select('issue_id').
          where('user_id = ? AND spent_on >= ? AND issue_id IS NOT NULL', statisticable.id, period_to_datetime).
          uniq('issue_id')
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
          having('count(journalized_id) >= ?', Setting.plugin_redmine_issue_statistics['returned'].to_i).
          joins(journals: :details).
          where('old_value IN(?) AND value IN(?) AND prop_key = ?', Setting.plugin_redmine_issue_statistics['returned_table_from'], Setting.plugin_redmine_issue_statistics['returned_table_to'], "status_id").all
      end

      def comment_query issue, period_to_datetime
        Journal.where("journalized_id = ? AND notes != ? AND created_on >= ?", issue, "", period_to_datetime)
      end

      def resolved_query statisticable, period_to_datetime
        Journal.joins(:details).
          select('journalized_id').
          where('prop_key = ?', "status_id").
          where('user_id = ? AND created_on >= ? ', statisticable.id, period_to_datetime).
          where('value IN(?)', IssueStatus.where(is_closed: true).select('id').pluck(:id)).
          group('journalized_id')
      end

      def resolved_user_per_project statisticable, period_to_datetime, query, project_id
        query_scoped = Queries.project_scope query, project_id
        if !query_scoped.nil?
          query_scoped = query_scoped.collect(&:id)
          Journal.joins(:details).
            select('journalized_id').
            where('prop_key = ?', "status_id").
            where('journalized_id IN(?)', query_scoped).
            where('user_id = ? AND created_on >= ? ', statisticable.id, period_to_datetime).
            where('value IN(?)', IssueStatus.where(is_closed: true).select('id').pluck(:id)).
            group('journalized_id')
        end
      end

      def total_logged_to statisticable, period_to_datetime, scope = nil
        if scope == nil
          query = Queries.base_query_to_log statisticable, period_to_datetime
          query2 = Journal.where('user_id = ? AND created_on >= ?', statisticable.id, period_to_datetime)
          query, query2 = query.map(&:issue_id), query2.map(&:journalized_id)
          query = query.zip(query2).flatten.uniq
        else
          query = Queries.base_query_to_log statisticable, period_to_datetime
          query = query.where('project_id = ?', scope)
          query = query.map(&:issue_id)
          query2 = Journal.where('user_id = ? AND created_on >= ? AND journalized_id IN(?)',
                                 statisticable.id, period_to_datetime, Project.find(scope).issues.collect(&:id)).map(&:journalized_id)
          query = query.zip(query2).flatten.uniq
        end
        query
      end

      private

      def open_projects
        @@open_projects ||= Project.where(status: Project::STATUS_ACTIVE).select('id').pluck(:id)
      end
    end
  end
end
