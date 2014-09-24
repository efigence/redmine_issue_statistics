require_relative "./basic_calculation"

module RedmineIssueStatistics
  class ReturnedIssues < BasicCalculation
    attr_reader :results, :period

    def calculate statisticable, period, scope = nil
      #binding.pry
      @periods_datetime = nil
      @period = period
      @scope = scope
      @query = Queries.base_query statisticable, period_to_datetime
      most_commented statisticable
      returned statisticable
      resolved_issues statisticable, period_to_datetime
      return @results
    end

    private

    def initialize
      @results = {}
      @returned = 0
      @comment_count = 0
    end

    def most_commented statisticable
      if statisticable.issues.any?
        @query = Queries.project_scope @query, @scope
        @query.each do |issue|
          comments = Queries.comment_query(issue.id, period_to_datetime).count
          @comment_count += 1 if comments > Setting.plugin_redmine_issue_statistics['comment_settings'].to_i
        end
        @results[:comment_max] = @comment_count
      end
    end

    def returned statisticable
      if statisticable.issues.any?
        @returned = Queries.returned_query(@query, @scope).count
        @results[:returned] = @returned
      end
    end

    def resolved_issues statisticable, period_to_datetime
      if statisticable.class.name == "User" && @scope == nil
        @resolved = Queries.resolved_query statisticable, period_to_datetime
        @results[:resolved] = @resolved.all.count
      elsif statisticable.class.name == "User" && @scope != nil
        resolved_user_per_project statisticable, period_to_datetime
      elsif statisticable.class.name == "Project"
        @results[:resolved] = 0
      end
    end

    def resolved_user_per_project statisticable, period_to_datetime
      resolved = Queries.resolved_user_per_project statisticable, period_to_datetime, @query, @scope
      resolved = resolved.all.count unless resolved.nil?
      resolved = 0 if resolved.nil?
      @results[:resolved] = resolved
    end
  end
end
