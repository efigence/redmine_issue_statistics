require_relative "./basic_calculation"
require_relative "../queries"

module RedmineIssueStatistics
  class BaseCalculation < BasicCalculation
    attr_reader :results, :period

    def calculate statisticable, period, scope = nil, class_name = nil
      @periods_datetime = nil
      @period = period
      @scope = scope

      @query = Queries.base_query statisticable, period_to_datetime
      @old_issues = Queries.old_issues_query statisticable, period_to_datetime, scope, class_name
      if statisticable.class.name == "Project"
        calculate_total_issues_for statisticable
        calculate_opened_issues_for statisticable
        calculate_closed_issues_for statisticable
      end
      calculate_old_issues_for statisticable
      return @results
    end

    private

    def initialize
      @results = {}
    end

    def project_scope
      if @scope
        @query = @query.where(project_id: @scope)
      end
    end

    def calculate_total_issues_for(statisticable)
      project_scope
      @results[:total] = @query.count
    end

    def calculate_opened_issues_for(statisticable)
      project_scope
      @results[:opened] = @query.open.count
    end

    def calculate_old_issues_for(statisticable)
      project_scope
      @results[:old_issues] = @old_issues.count
    end

    def calculate_closed_issues_for(statisticable)
      closed = 0
      project_scope
      @query.each do |issue|
        if issue.closed?
          closed += 1
        end
      end
      @results[:closed] = closed
    end
  end
end
