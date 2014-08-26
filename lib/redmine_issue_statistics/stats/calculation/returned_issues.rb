require_relative "./basic_calculation"

module RedmineIssueStatistics
  class ReturnedIssues < BasicCalculation
    attr_reader :results, :period

    def calculate statisticable, period, scope = nil
      @periods_datetime = nil
      @period = period
      @scope = scope
      @query = Queries.base_query statisticable, period_to_datetime

      most_commented statisticable
      returned statisticable
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
  end
end